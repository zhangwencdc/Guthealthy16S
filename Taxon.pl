#!/usr/bin/perl
use strict;
#use warnings;

my $file=$ARGV[0];#ASV_silva.blat

open(FILE,$file);
my %max;my %maxid;
while(1){
	my $line=<FILE>;
	unless($line){last;}
	chomp $line;
	my @a=split"\t",$line;
	my $asv=$a[9];
	if($a[0]>=$max{$asv}){$max{$asv}=$a[0];$maxid{$asv}=$line;}
}

close FILE;

open(OUT,">$file.best");
my @asv=sort keys %max;
foreach my $asv (@asv) {
	print OUT "$maxid{$asv}\n";
}
close OUT;
my $silva="/home/zhangwen/project/2022Time/silva_species_assignment_v138.1.fa";
my %genus;my %species;
open(S,$silva);
while(1){
	my $line=<S>;
	unless($line){last;}
	chomp $line;
	unless(substr($line,0,1) eq ">"){next;}
	my @a=split" ",$line;
	my $id=substr($a[0],1);
	$genus{$id}=$a[1];
	$species{$id}=$a[1]."_".$a[2];
}
close S;

open(OUT,">$file.taxon");
#my @asv=sort keys %max;
foreach my $asv (@asv) {
	my @a=split "\t",$maxid{$asv};
	unless($a[10]=~/[0-9]/){next;}
	unless(($a[0]/$a[10])>0.97){next;}
	print OUT "$asv,$a[13],$genus{$a[13]},$species{$a[13]}\n";
}
close OUT;