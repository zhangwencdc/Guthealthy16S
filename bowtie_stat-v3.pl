#!/usr/bin/perl
use strict;
#use warnings;

my $file=$ARGV[0]; #sam
my $taxon=$ARGV[1];#taxon
my $input=$ARGV[2]; #fq文件
my $core=$ARGV[3];#Core
my $out=$ARGV[4];

##read数目
my $sum=0;
open(FQ,$input);
while(1){
	my $line=<FQ>;
	unless($line){last;}
	chomp $line;
	if(substr($line,0,1) eq "@"){$sum++;}
}
close FQ;

###taxon
open(TAXON,$taxon);
my %genus; my %species;
while(1){
	my $line=<TAXON>;
	unless($line){last;}
	chomp $line;
	my @a=split"\t",$line;
	if(substr($a[0],0,1)eq ">"){$a[0]=substr($a[0],1);}
	my @b=split" ",$a[1];
	$genus{$a[0]}=$b[0];
	$species{$a[0]}=$b[0]." ".$b[1];
	#print "$a[0],$genus{$a[0]},$species{$a[0]}\n";
}
close TAXON;


###
open(FILE,$file);
my %query;my %identity;
while(1){
	my $line=<FILE>;
	unless($line){last;}
	chomp $line;
	if(substr($line,0,1) eq "@"){next;}
	my @a=split" ",$line;
	unless($a[2]=~/[0-9a-zA-Z]/){next;}
	my $len=length($a[9]);
	my $l=length($a[5]);
	my $num="";my $match=0;my $total;
	foreach  (0..($l-1)) {
		my $site=substr($a[5],$_,1);
		if($site=~/[0-9]/){
			$num=$num.$site;
		}else{
			if($site eq "M"){$match+=$num;}
			$total+=$num;
			$num="";			
		}
	}
	my $identity=$match/$total*100;
	if($match<100 || $identity<97){next;}
	unless(exists $identity{$a[0]}){$identity{$a[0]}=$identity; $query{$a[0]}=$a[2];}
	if($identity>$identity{$a[0]} ){
		$identity{$a[0]}=$identity; $query{$a[0]}=$a[2];
	}
}
open(OUT,">$out");
open(O2,">$out.genus");
my @key=keys %query;
my %num_genus;
foreach my $key (@key) {
	print OUT "$key,$query{$key},$genus{$query{$key}},$species{$query{$key}},$identity{$key}\n";
	unless(substr($genus{$query{$key}},length($genus{$query{$key}})-1,1)=~/[0-9a-zA_Z]/){$genus{$query{$key}}=substr($genus{$query{$key}},0,length($genus{$query{$key}})-1);}
	if($genus{$query{$key}}=~/Lachnospiracea/){print "Lachnospiracea,$genus{$query{$key}},\n";}
	$num_genus{$genus{$query{$key}}}++;
}

my @k=sort keys %num_genus;
my $total=0;
my $shannon;
print OUT "\nGenus\n";
foreach my $k (@k) {
	print OUT "$k,$num_genus{$k}\n";
	$shannon+=($num_genus{$k}/$sum)*log($num_genus{$k}/$sum)/log(2);
	$total++;
}
$shannon=0-$shannon;
my $pielou=$shannon/(log($total)/log(2));
print "(1)Summary Information\n";
print "Total Genus Num, $total\n";

print "Total Read Num, $sum\n";
print "Shannon-Weiner index, $shannon\n";
print "Pielou index, $pielou\n";
print O2 "(1)Summary Information\n";
print O2 "Total Genus Num: $total (51-232)\n";
print O2 "Total Read Num: $sum\n";
print O2 "Shannon-Weiner index: $shannon (0.89-3.13)\n";
print O2 "Pielou index: $pielou (0.21-0.63)\n";

open(CORE,$core);
print  "(2)Core Genus information\n";
print O2 "(2)Core Genus information\n";
while(1){
	my $line=<CORE>;
	unless($line){last;}
	chomp $line;
	unless(substr($line,length($line)-1,1)=~/[0-9a-zA-Z]/){$line=substr($line,0,length($line)-1);}
	my @a=split"\t",$line;
	my $n=0;
	my @b=split"_",$a[0];
	print "$a[0],$b[0]\n";
	foreach my $b (@b) {
		unless(substr($b,length($b)-1,1)=~/[0-9a-zA-Z]/){$b=substr($b,0,length($b)-1);}
		print "$b,$num_genus{$b}\n";
		$n+=$num_genus{$b};
	}
	my $v=$n/$sum*100;
	print O2 "$a[0]: $v\t";
	if($v<$a[1]){
		print O2 "Less than Mix ( $a[1] ~ $a[2] ) \n";
	}elsif($v>$a[2]){
		print O2 "More than Max ( $a[1] ~ $a[2] ) \n";
	}else{
		print O2 "\n";
	}
}

close CORE;