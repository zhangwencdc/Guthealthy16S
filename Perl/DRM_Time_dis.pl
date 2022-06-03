#!/usr/bin/perl
use strict;
#use warnings;

my $file=$ARGV[0]; #Meta-Storms.People.dm_values
my $DRM=$ARGV[1];##DRM.txt
my $out=$ARGV[2];

open(DRM,$DRM);my %group; my %drug;
while(1){
	my $line=<DRM>;
	unless($line){last;}
	chomp $line;
	my @a=split"\t",$line;
	if($a[0]=~/Sample/){next;}
	$group{$a[0]}=$a[1];$drug{$a[0]}=$a[4];
}
close DRM;

open(FILE,$file);
open(OUT,">$out");
open(O,">$out.drug");
print OUT "ID\tPeople\tTimeDis\tDistance\tGroup\tSample1\tSample2\n";my $id=0;
print O "ID\tPeople\tTimeDis\tDistance\tGroup\tSample1\tSample2\n";
while(1){
	my $line=<FILE>;
	unless($line){last;}
	chomp $line;
	my @a=split"\t",$line;
	unless($a[0]=~/AllWithin/){next;}
	my $t1=substr($a[2],3);
	my $t2=substr($a[4],3);
	my $dis=$t2-$t1;
	unless($dis<2){next;} my $group;  ####Ò»ÔÂÄÚ
	if($group{$a[2]} eq "Abnormal" || $group{$a[4]} eq "Abnormal"){$group="Abnormal";}else{$group="Normal";}
	print  "$a[3]\tM$dis\t$a[6]\t$group\n";$id++;
	print OUT "$id\t$a[3]\tM$dis\t$a[6]\t$group\t$a[2]\t$a[4]\n";
	if($drug{$a[2]} eq "Drug" || $drug{$a[4]} eq "Drug"){
		print O "$id\t$a[3]\tM$dis\t$a[6]\tDrug\t$a[2]\t$a[4]\n"
	}else{
		print O "$id\t$a[3]\tM$dis\t$a[6]\tNormal\t$a[2]\t$a[4]\n"
	}
}
close FILE;