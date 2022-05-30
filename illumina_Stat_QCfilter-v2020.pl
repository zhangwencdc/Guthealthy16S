#/usr/bin/perl -w

=head1 Name

	illumina_Stat_QCfilter-v2017.pl

=head1 Description

1.Dispense with assigning the data into individual sample(already done by the matchine);

2.Evalue the sequencing data the Miseq PE250 platform using the following aspects:
(1) the length of the sequences in the pair-end reads,respectively. eg <50,50<=seq<100;
(2) the quality of the sequences in the pair-end reads,respectively. eg Q20 and Q30;
(3) the number and ratio of Simple Sequence Repeats(SSR),eg AAAAAAAAAA;
(4) the number and ratio of primer dimer. 
(5) the total length of individual samples.

3.Trim the low-quality reads and gain the high-quality reads for individual paired-end file
(using the quality-value the user set);
Step 1:FastQC
Step 2:filter the sequence
Step 3: 统计
Step 4: 拼接。两种拼接结果：（a）直接拼接未质控的read；（b）拼接质控后的read

=head1 Version1.0

  Author: Han Na, hanna@icdc.cn
  Version: 1.0,  Date: 2016-8-2
updated: Wen Zhang, Date:2017/08/30
  
=head1 Usage

   perl $0 -q <filter Quality value> -f <1.fastq.gz> -r <2.fastq.gz> -tag Name;
	--qulity	set the qulity cutoff value to trim the reads
	--forward	input the forward sequence file in *.fastq.gz postfix
	--reverse	input the reverse sequence file in *.fastq.gz postfix
	--verbose   output verbose information to screen
	--help      output help information to screen

=cut


use strict;
use Getopt::Long;
my $pear="/share/nas1/genome/bin/PEAR/bin/pear-0.9.6-bin-64";  #PEAR程序的路径
my ($Quality,$Forward,$Reverse,$Verbose,$Help,$tag,$outdir);

##################
$Quality=20;
my $Time_Start = sub_format_datetime(localtime(time())); #运行开始时间
my $Data_Vision = substr($Time_Start,0,10);
print "Running from [$Time_Start]\n";

#######################

my $Q = $Quality;
$Q = chr( 33 + $Q );
print "$Q\n";

my $Forward=$ARGV[0];
my $Reverse=$ARGV[1];
my $tag=$ARGV[2];
my $outdir=$ARGV[3];
#######################
my $file_R1 = &openfile($Forward);
my $file_R2 = &openfile($Reverse);


if($Forward =~ /\.gz$/||$Reverse =~ /\.gz$/){
	$Forward =~ s/\.gz//g;
	$Reverse =~ s/\.gz//g;
}
print "$Forward\t$Reverse\n";


#######the basic info of the file#########
print "Step1:stat the basic info for reads\n";

my $stat_R1 = &Stats($Forward,$tag);
system "mv $tag.stat $tag.forward.stat\n";
my $stat_R2 = &Stats($Reverse,$tag);
system "mv $tag.stat $tag.reverse.stat\n";

print "Step1:finished\n";

###拼接
print "Step2: Assemble pair end reads\n";
print "Assemble raw reads....\n";
print " $pear -f $Forward -r $Reverse -o $outdir/$tag –v 10 –m 500 –n 300 –t 100 –q 20  -j 20\n";
system "$pear -f $Forward -r $Reverse -o $outdir/$tag –v 10 –m 500 –n 300 –t 100 –q 20  -j 20\n";
my $assemble=&Stats("$tag.assembled.fastq",$tag);

print "Step2:finished\n";

system "cat *.stat >$tag.summary";
system "rm *.stat\n";
#######################
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


sub Stats{
		my $infile=shift;
		my $tag=shift;
		print ":$infile stat\n";
		my $out=$infile;
		$out =~ s/\.gz//g;
		my $sample = $out;
		$sample =~ s/\_001\.fastq//;
		my $infile_h=&openfile($infile);
		open (STAT,">$tag\.stat") || die "cannot open the file $out\.stat:$!";
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
		#print STAT "\<50\t$len50\t$len50_ratio\%\n";
		#print STAT "50~100\t$len100\t$len100_ratio\%\n";
		#print STAT "100~150\t$len150\t$len150_ratio\%\n";
		#print STAT "150~200\t$len200\t$len200_ratio\%\n";
		#print STAT "200~250\t$len250\t$len250_ratio\%\n";
		#print STAT "250~300\t$len300\t$len300_ratio\%\n";
		#print STAT "\>300\t$len350\t$len350_ratio\%\n";
		#print STAT "\n\n";
		#print STAT "Q20\t$Q20_ratio\%\n";
		#print STAT "Q30\t$Q30_ratio\%\n";
		#print STAT "\n\n";
		#print STAT "Simple Sequence Repeats\t$SSR_stat\t$SSR_ratio\%\n";
		#print STAT "Total\t$total\n";
		print STAT "Sample\t\\#of reads\ttotal_len\tQ20\tQ30\t\<50\t50\~100\t100\~150\t150\~200\t200\~250\t250\~300\t301\n";
		print STAT "$sample\t$total\t$total_len_M"."M\t$Q20_ratio\%\t$Q30_ratio\%\t$len50_ratio\%\t$len100_ratio\%\t$len150_ratio\%\t$len200_ratio\%\t$len250_ratio\%\t$len300_ratio\%\t$len350_ratio\%\n";
		close STAT;
}	

sub trim_qu {
        my $fastqarr = shift;
        chomp($fastqarr->[3]);
        chomp($fastqarr->[1]);
        my @it = split '',  $fastqarr->[3];
        my $i = 0;
        for ( $i = 0 ; $i < @it ; $i++ ) {
                last if $it[$i] lt $Q;
        }
        $i = 1 if $i == 0;
        $fastqarr->[1]=substr( $fastqarr->[1], 0, $i ) ."\n";
        $fastqarr->[3]=substr( $fastqarr->[3], 0, $i ) ."\n";
}


#===============================================================================================================
#  +------------------+
#  | time subprogram  |
#  +------------------+

my $Time_End= sub_format_datetime(localtime(time()));
print "Running from [$Time_Start] to [$Time_End]\n";

sub sub_format_datetime 
{
    my($sec, $min, $hour, $day, $mon, $year, $wday, $yday, $isdst) = @_;
	$wday = $yday = $isdst = 0;
    sprintf("%4d-%02d-%02d %02d:%02d:%02d", $year+1900, $mon, $day, $hour, $min, $sec);
}
#=================================================================================================================
		
