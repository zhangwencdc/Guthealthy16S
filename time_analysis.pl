#!/usr/bin/perl
use strict;
use warnings;

my $time=$ARGV[0];#time_info.txt
open(T,$time);my %time;
while(1){
	my $line=<T>;
	unless($line){last;}
	chomp $line;
	my @a=split"\t",$line;
	$time{$a[0]}=$a[1];
}
close T;

my $file=$ARGV[1];#time_info.txt
open(OUT,">$file.v2");
open(F,$file);
while(1){
	my $line=<F>;
	unless($line){last;}
	chomp $line;
	my @a=split"\t",$line;
	print OUT "$line\t$time{$a[2]}\n";
}
close F;