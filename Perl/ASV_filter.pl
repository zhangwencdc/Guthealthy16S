#!/usr/bin/perl
use strict;
#use warnings;

my $file=$ARGV[0];

my @file=glob "$file/*.fastq";

foreach my $f (@file) {
	open(FILE,$f);
	open(OUT,">$f.filter");
	while(1){
		my $line=<FILE>;
		unless($line){last;}
		chomp $line;
		my $seq=<FILE>;chomp $seq;
		my $a=<FILE>;chomp $a;
		my $b=<FILE>;chomp $b;
		my $n=$seq;$n=~/N/g;
		my $posn=pos($n);
		my $seq2;
		if($posn>0){
			$seq2=$seq;
			$seq2=~s/N//g;
			#print "$seq\n$seq2\n";
		}
		
		$seq2=$seq;
		my $s=substr($seq,0,50);
		my $e=substr($seq,length($seq)-50,50);
		$s=~/CCTACGGG/g;
		$e=~/GGATTAGATACCC/g;
		my $ps=pos($s);
		my $pe=pos($e);
		
		if($ps>0 && $pe>0){
			my $news=$ps+9;
		my $newe=length($seq)-64+$pe;
		my $newl=$newe-$news+1;
		#print "$seq,$news,$newl\n";
		my $new=substr($seq,$news,$newl);
		my $newfq=substr($b,$news,$newl);
			print OUT "$line\n$new\n$a\n$newfq\n";
		}else{
			print OUT "$line\n$seq\n$a\n$b\n";
		}
		
	}
	close FILE;
	close OUT;
}