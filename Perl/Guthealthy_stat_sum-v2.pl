#!/usr/bin/perl
use strict;
#use warnings;
use Getopt::Long;
use FindBin qw($Bin $Script);
use File::Basename qw(basename dirname); 


my $file=$ARGV[0];
###读取read数
my @file=glob "$file/*.Report.txt"; my %read;my %g;my %shannon;my %pielou;
open(O,">Guthealthy.Sample.sum");
foreach my $f (@file){
	open(F,$f);
	my $name=basename ($f);
	$name=substr($name,0,length($name)-11);
	
	while(1){
		my $l=<F>;
		unless ($l) {
			last;
		}
		my @a=split"\:",$l;
		my @b=split " ",$a[1];
		if($l=~/Total Genus Num/){$g{$name}=$b[0];}
		if($l=~/Total Read Num/){$read{$name}=$b[0];}
		if($l=~/Shannon-Weiner/){$shannon{$name}=$b[0];}
		if($l=~/Pielou/){$pielou{$name}=$b[0];}
	}
}
my @name=keys %g;print O "Sample,";
foreach my $name (@name) {
	print O "$name,";
}
print O "\n";
print O "Reads,";
foreach my $name (@name) {
	print O "$read{$name},";
}
print O "\n";
print O "Genus,";
foreach my $name (@name) {

	print O "$g{$name},";
}
print O "\n";
print O "Shannon-Weiner,";
foreach my $name (@name) {
	print O "$shannon{$name},";
}
print O "\n";
print O "Pielou,";
foreach my $name (@name) {
	print O "$pielou{$name},";
}
print O "\n";
###Genus matrix
my @file=glob "$file/Bowtie_stat/*.stat"; 
my %genus;my %species;
open(OG,">Guthealthy.Genus.matrix");
open(OS,">Guthealthy.Species.matrix");
print OG "Sample,";print OS "Sample,";
foreach my $f (@file){
	open(F,$f);
	my $name=basename ($f);
	$name=substr($name,0,length($name)-5);
	print OG "$name,";
	print OS "$name,";
	while(1){
		my $l=<F>;
		unless ($l) {
			last;
		}
		my @a=split",",$l;
		if($a[4]>=97){
			$genus{$a[2]}{$name}++;
		}
		if($a[4]>=99){
			$species{$a[3]}{$name}++;
		}
	}
	close F;
}
print OG "\n";
print OS "\n";

my @genus=keys %genus;
foreach my $genus (@genus) {
	print OG "$genus,";my $type=0;
	foreach my $f (@file) {
		my $name=basename ($f);
		$name=substr($name,0,length($name)-5);
		my $t=$genus{$genus}{$name}/$read{$name};
		if(exists $genus{$genus}{$name}){print OG "$t,";}else{print OG "NA,";}
		unless(exists $genus{$genus}{$name}){$type=1;}
	}
	print OG "\n";
	if($type==0){print "Core Genus,$genus\n";}
}

my @species=keys %species;
foreach my $species (@species) {
	print OS "$species,";my $type=0;
	foreach my $f (@file) {
		my $name=basename ($f);
		$name=substr($name,0,length($name)-5);
		my $t=$species{$species}{$name}/$read{$name};
		if(exists $species{$species}{$name}){print OS "$t,";}else{print OS "NA,";}
		unless(exists $species{$species}{$name}){$type=1;}
	}
	print OS "\n";
	if($type==0){print "Core Species,$species\n";}
}


###pathogen matrix
#group
open(GROUP,"$Bin/pathogen.group");
my %group;
while(1){
	my $line=<GROUP>;
	unless($line){last;}
	chomp $line;
		unless(substr($line,length($line)-1,1)=~/[0-9a-zA-Z]/){$line=substr($line,0,length($line)-1);}
	my @a=split"\t",$line;
	$group{$a[0]}=$a[1];

}
my @file=glob "$file/Bwa_stat/*.stat"; 
open(OP,">Guthealthy.Pathogen.matrix");print OP "Sample,Group,";my %pathogen;
open(OL,">Guthealthy.Pathogen.list");  ###含有Group1 和Group3 的病原菌列表
foreach my $f (@file){
	open(F,$f);
	my $name=basename ($f);
	$name=substr($name,0,length($name)-13);
	print OP "$name,";
	while(1){
		my $l=<F>;
		unless ($l) {
			last;
		}
		my @a=split",",$l;

		if($a[4]>=99){
			$pathogen{$a[3]}{$name}++;
		}
	}
	close F;
}
print OP "\n";
my @pa=keys %pathogen; my %list;
foreach my $pa (@pa) {
	print OP "$pa,$group{$pa},";
		foreach my $f (@file) {
		my $name=basename ($f);
		$name=substr($name,0,length($name)-13);
		if(exists $pathogen{$pa}{$name} && $pathogen{$pa}{$name}>1){  ###跳过仅有1条序列的比对结果
			my $t=$pathogen{$pa}{$name}/$read{$name};
			print OP "$t,";
			if($group{$pa} eq "Group1" || $group{$pa} eq "Group3" ){$list{$name}=$list{$name}.",".$pa;}
		}else{print OP "0,";}
	}
	print OP "\n";

}

my @list=keys %list;
foreach my $f (@file) {
		my $list=basename ($f);
		$list=substr($list,0,length($list)-13);
	print OL "$list,$shannon{$list},$pielou{$list},$list{$list}\n";
}