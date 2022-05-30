#!/usr/bin/perl
use strict;
use warnings;

my $input=$ARGV[0];#taxa.genus.Abd

my $out=$ARGV[1];

open(FILE,$input);
my $name=<FILE>;chomp $name;
my @name=split"\t",$name;my %strain;my %core;my %j; my $strain_sum;

open(OUT,">$out");
print OUT "Sample,Top Genus,Percentage\n";
while(1){
	my $line=<FILE>;
	unless($line){last;}
	chomp $line;
	my @a=split"\t",$line;
	my $n=@a;
	my $strain=$a[0];
	unless($strain=~/[0-9a-zA-Z]/){next;}
	$strain_sum++;my $max;my $max_n;
	foreach  (1..($n-1)) {
		my $n=$name[$_];
		if($n=~/Unclassified/){next;}
		if($a[$_]>$max){$max=$a[$_];$max_n=$name[$_];}  
	}
	print OUT "$strain,$max_n,$max\n";

}
close FILE;
