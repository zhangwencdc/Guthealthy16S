#!/usr/bin/perl
use strict;
#use warnings;
use Getopt::Long;
use FindBin qw($Bin $Script);
use File::Basename qw(basename dirname); 


my $file=$ARGV[0];



my @file=glob "$file/*.stat";
my %genus;my %species;
open(OG,">Genus.matrix");
open(OS,">Species.matrix");
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
		print OG "$genus{$genus}{$name},";
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
		print OS "$species{$species}{$name},";
		unless(exists $species{$species}{$name}){$type=1;}
	}
	print OS "\n";
	if($type==0){print "Core Species,$species\n";}
}