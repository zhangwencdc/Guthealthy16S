#!/usr/bin/perl
use strict;
use warnings;

my $file=$ARGV[0]; #Meta-Storms.People.dm_values

my $out=$ARGV[1];

open(FILE,$file);
open(OUT,">$out");
while(1){
	my $line=<FILE>;
	unless($line){last;}
	chomp $line;
	my @a=split"\t",$line;
	unless($a[0]=~/AllWithin/){next;}
	my $t1=substr($a[2],3);
	my $t2=substr($a[4],3);
	my $dis=$t2-$t1;
	if(length($dis)==1){$dis="0".$dis;}
	print  "$a[3],M$dis,$a[6]\n";
	print OUT "$a[3],M$dis,$a[6]\n";
}
close FILE;