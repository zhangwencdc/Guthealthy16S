#!/usr/bin/perl
use strict;
use warnings;

my $file=$ARGV[0];

open(OUT,">$file.filter.fq");
open(FILE,$file);
while(1){
	my $line=<FILE>;
		unless($line){last;}
	chomp $line;
	my $seq=<FILE>;chomp $seq;
	my $a=<FILE>;chomp $a;
	my $b=<FILE>;chomp $b;
	unless(length($seq)>=300){next;}
	if($seq=~/N/){next;}
	if($seq=~/^T/){
	print OUT "$line\n$seq\n$a\n$b\n";
	}else{
		my $rb=reverse $b;
		my $reverse=convert($seq);
		print OUT "$line\n$reverse\n$a\n$rb\n";
		#print "O,$seq\nR,$reverse\n";
	}

}
close OUT;

sub convert {
	my $seq=shift;
	my $rseq=reverse $seq;
	$rseq=~tr/ATCG/TAGC/;
	return $rseq;
}