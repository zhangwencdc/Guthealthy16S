#!/usr/bin/perl
use strict;
use warnings;

my $input=$ARGV[0];#taxa.genus.Abd

my $out=$ARGV[1];

open(FILE,$input);
my $name=<FILE>;chomp $name;
my @name=split"\t",$name;my %strain;my %core;my %j; my $strain_sum;
while(1){
	my $line=<FILE>;
	unless($line){last;}
	chomp $line;
	my @a=split"\t",$line;
	my $n=@a;
	my $strain=$a[0];
	unless($strain=~/[0-9a-zA-Z]/){next;}
	$strain_sum++;
	foreach  (1..($n-1)) {
		my $n=$name[$_];
		if($a[$_]>0.00001){$strain{$n}+=$a[$_];$j{$n}++;}  ####仅考虑大于十万分之一菌属
	}

}
close FILE;
open(OUT,">$out");
my @key=keys %j;
foreach my $key (@key) {
	if($j{$key}==$strain_sum){print OUT "$key,";
		my $avg=$strain{$key}/$strain_sum;
		print OUT "$avg\n";
	}
}