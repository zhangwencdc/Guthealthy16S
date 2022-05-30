#/usr/bin/perl -w

=head1 Name

	Guthealthy-v3.pl

=head1 Description

1\ Quality Control
2\ Assemble of pair end reads
3\ Genus Num
4\ Pathogen List


=head1 Version

 

  
=head1 Usage

   perl $0 -q <filter Quality value>  <1.fastq.gz>  <2.fastq.gz>;
	--qulity	set the qulity cutoff value to trim the reads
	--verbose   output verbose information to screen
	--help      output help information to screen

=cut

use strict;
use Getopt::Long;
my $pear="/share/nas1/genome/bin/PEAR/bin/pear-0.9.6-bin-64";  #PEAR程序的路径
my $bin="/share/nas3/zhangwen/bin/Guthealthy/bin/";
my $data="/share/nas3/zhangwen/bin/Guthealthy/Data/";
my ($Quality,$Forward,$Reverse,$Verbose,$Help,$tag,$I);
GetOptions(
		"Input|I:s" =>\$I,
		"quality:s" =>\$Quality,
		"tag:s"=>\$tag,
        "verbose"=>\$Verbose,
        "help"=>\$Help
);

##################
unless(defined $Quality){$Quality=20;}
unless(defined $tag){$tag="test";}
unless(defined $I){die;}
my $Time_Start = sub_format_datetime(localtime(time())); #运行开始时间
my $Data_Vision = substr($Time_Start,0,10);
print "Running from [$Time_Start]\n";



###########

print "Step 1: Genus Num 样本中菌属多样性\n";

system "/share/nas1/genome/bin/bowtie2-2.2.6/bowtie2 -x $data/16S-complete-clean.fa -q $I -S $tag.sam\n";
system "perl $bin/bowtie_stat-v3.pl $tag.sam $data/16S-complete-clean.taxon $I $data/Core_genus $tag.stat\n";

print "Step 2:Pathogen Detection 样本中含有的病原菌\n";
system "/share/nas1/genome/bin/bowtie2-2.2.6/bowtie2 -x $data/155pathogens.fa  -q $I -S $tag.bwa.sam\n";
#system "$bin/bwa-0.7.12/bwa mem $data/155pathogens.fa $I >$tag.bwa.sam\n";
system "perl $bin/bwa_stat-v4.pl $tag.stat $tag.bwa.sam $data/16S-complete-clean.taxon $data/pathogen.group $tag.bwa.sam.stat\n";

print "Step 3: Report 报告生成\n";
system "cat $tag.stat.genus $tag.bwa.sam.stat.species >$tag.Report.txt\n";


my $Time_End= sub_format_datetime(localtime(time()));
print "Running from [$Time_Start] to [$Time_End]\n";

###################
sub openfile{
        my $file=shift;
        my $file_h;
        if($file=~/\.gz$/){
		    print "$file\n";
			`gzip -d $file`;
			$file =~ s/\.gz//;
            open $file_h,"$file" or die "cannot open the $file\n";
        }else{
            open $file_h,"$file" or die "cannot open the $file\n";
        }
        return  $file_h;
}


##
sub Stats{
		my $infile=shift;
		print ":$infile stat\n";
		my $out=$infile;
		$out =~ s/\.gz//g;
		my $sample = $out;
		$sample =~ s/\_001\.fastq//;
		my $infile_h=&openfile($infile);
		open (STAT,">$out\.stat") || die "cannot open the file $out\.stat:$!";
		my @read;
		my ($total,$total_len)=(0,0);
		my ($len50,$len100,$len150,$len200,$len250,$len300,$len350)=(0,0,0,0,0,0,0);
		my ($Qi,$Q20,$Q30) = (0,0,0);
		my $SSR_stat = 0;
		while(<$infile_h>){
			$read[0]=$_;
			$read[1]=<$infile_h>;
			$read[2]=<$infile_h>;
			$read[3]=<$infile_h>;
			my $len = length $read[1];
			$total+=1;
			$total_len+=$len;
			if($len<=50){$len50+=1};
			if($len>50 && $len<=100){$len100++;}
   			if($len>100 && $len<=150){$len150++;}
			if($len>150 && $len<=200){$len200++;}
			if($len>200 && $len<=250){$len250++;}
			if($len>250 && $len<=300){$len300++;}
			if($len>300){$len350++;}
			if($read[1]=~ /A{10,}/ || $read[1]=~ /C{10,}/ || $read[1]=~/G{10,}/ || $read[1]=~/T{10,}/){$SSR_stat++;}
			my @Qual = split(//,$read[3]);
			$Qi += @Qual;
			my $i=0;
			for($i=0;$i<@Qual;$i++){
				if($Qual[$i] ge chr(53)){$Q20++;}
				if($Qual[$i] ge chr(63)){$Q30++;}
			}
		}
		my $len50_ratio = $len50/$total;
		$len50_ratio = sprintf"%.4f",$len50_ratio;
		$len50_ratio *= 100;
		my $len100_ratio = $len100/$total;
		$len100_ratio = sprintf"%.4f",$len100_ratio;
		$len100_ratio *= 100;
		my $len150_ratio = $len150/$total;
		$len150_ratio = sprintf"%.4f",$len150_ratio;
		$len150_ratio *= 100;
		my $len200_ratio = $len200/$total;
		$len200_ratio = sprintf"%.4f",$len200_ratio;
		$len200_ratio *= 100;
		my $len250_ratio = $len250/$total;
		$len250_ratio = sprintf"%.4f",$len250_ratio;
		$len250_ratio *= 100;
		my $len300_ratio = $len300/$total;
		$len300_ratio = sprintf"%.4f",$len300_ratio;
		$len300_ratio *= 100;
		my $len350_ratio = $len350/$total;
		$len350_ratio = sprintf"%.4f",$len350_ratio;
		$len350_ratio *= 100;
		my $Q20_ratio = $Q20/$Qi;
		$Q20_ratio = sprintf"%.4f",$Q20_ratio;
		$Q20_ratio *= 100;
        my $Q30_ratio = $Q30/$Qi;
		$Q30_ratio = sprintf"%.4f",$Q30_ratio;
		$Q30_ratio *= 100;
		my $SSR_ratio = $SSR_stat/$total;
		$SSR_ratio = sprintf"%.4f",$SSR_ratio;
		$SSR_ratio *= 100;
		my $total_len_M = $total_len/1000000;
		$total_len_M = sprintf"%.2f",$total_len_M;

		print STAT "Sample : $sample\n";
		print STAT "Num of reads : $total\n";
		print STAT "Total Length: $total_len_M\n";
		print STAT "Q20 : $Q20_ratio\n";
		print STAT "Q30 : $Q30_ratio\n";
		print STAT "300bp : $len350_ratio\n";
		close STAT;
}	

#===============================================================================================================
#  +------------------+
#  | time subprogram  |
#  +------------------+



sub sub_format_datetime 
{
    my($sec, $min, $hour, $day, $mon, $year, $wday, $yday, $isdst) = @_;
	$wday = $yday = $isdst = 0;
    sprintf("%4d-%02d-%02d %02d:%02d:%02d", $year+1900, $mon, $day, $hour, $min, $sec);
}