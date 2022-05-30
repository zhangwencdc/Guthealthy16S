#!/usr/bin/perl
use strict;
use warnings;

my $file=$ARGV[0];# Genus_bray_curtis.list

open(FILE,$file); my %people; my %same;my %diff;my %samen;my %diffn; my %bray; 
while(1){
	my $line=<FILE>;
	unless($line){last;}
	chomp $line;
	my @a=split"\t",$line;
	if($a[0] eq "ID"){next;}
	$people{$a[7]}=$a[3];
	$people{$a[8]}=$a[4];
	
	if($a[3] eq $a[4]){$same{$a[3]}+=$a[9];$samen{$a[3]}++;}else{$diff{$a[3]}+=$a[9];$diffn{$a[3]}++;$diff{$a[4]}+=$a[9];$diffn{$a[4]}++;}

}
close FILE;
my $total;
my @people=keys %people;
$total=@people; my %sample;
foreach my $people (@people) {
	$sample{$people{$people}}++;
}
open(OUT,">$file.permution");
print OUT "Sample,True,,Permution Num,Mix,Max,Percentage\n";
foreach  (1..7) {
	my $people="P".$_;

	my $avg=($diff{$people}/$diffn{$people})-($same{$people}/$samen{$people});
	
	my $num1=$sample{$people};my $num2=$total-$num1;
	print "$people,$avg,$num1,$num2\n";
	my %a;my @value;
	foreach  (1..10000) {
	
		foreach  (1..$num1) {
			my $num=int(rand($total-1));
			$a{$people[$num]}++;
			#print "$num,$people[$num],";
		}
		open(FILE,$file);my $s;my $sn;my $d;my $dn;
		while(1){
			my $line=<FILE>;
			unless($line){last;}
			chomp $line;
			my @a=split"\t",$line;
			if($a[0] eq "ID"){next;}
			if(exists $a{$a[7]} && exists $a{$a[8]}){
				$s+=$a[9];$sn++;
			}else{
				if(exists $a{$a[7]} ||  exists $a{$a[8]} ){
				$d+=$a[9];$dn++;
				}
			}
		}
		close FILE;
		my $value=($d/$dn)-($s/$sn);
		#print "$d,$dn,$s,$sn,$value\n";
		push @value,$value;
	}
	my @v=sort{$a<=>$b} @value;
	print "Mix,$v[0]\n";
	my $num=@v;
	print "Max,$v[$num-1]\n";
	#	print "@v\n";
	foreach (0..($num-2)) {
		if($avg>=$v[$_] && $avg<=$v[$_+1]){
			my $per=$_/($num-1);
			print OUT "$people,$avg,$_,$num,$v[0],$v[$num-1],$per\n";
			print "$people,$avg,$_,$num,$per\n";
			#print "@v\n";
		}
	}
		if($avg>=$v[$num-1] ){
			my $per=1;
			print OUT "$people,$avg,$num,$num,$v[0],$v[$num-1],$per\n";
		}
}