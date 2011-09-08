#!/usr/bin/perl
# Assessing discriminant validity of multifactor scale by collapsing two factors into one and testing
# if chi^2 difference of restricted model (compared to baseline model) is significant
#
# Test is performed on every possible pair of factors
# Result is saved in the $lisrel_out file
#
my $factor_max=3; # number of factors
# lisrel CFA script; this file is modified in every loop
my $lisrel_script='tam_ff_cfa_test_dv.ls8'; ## lisrel CFA script
# lisrel binary
my $lisrel = 'lisrel87';
my $cfa_test_out = "cfa_test_dv.out";

use Getopt::Long;
GetOptions( 'f=i' => \$factor_max, 'l=s' => \$lisrel, 's=s' => \$lisrel_script, 'o=s' => \$cfa_test_out );

# lisrel CFA `meta-script'; this file contains baseline model 
my $lisrel_script_x= "${lisrel_script}x";

# results are stored in $lisrel_out
my $lisrel_out ='__test_dv.OUT_';

my $critical_chi = 6.635 ; ## chi-squared with 1 df (p = 0.01)

## ### ###

my $i =0; my $j = 0;

open (LL, ">$cfa_test_out");

open (LS, $lisrel_script_x);
undef $/;
$script = <LS>;
close (LS);

## initial lisrel run. Computing baseline model with PHI completly free
$chi = run_lisrel($script, 0, 0, -1); print STDERR "done\n";

print LL "\nvi,vj => chi^2min ($chi^2 = baseline) => wart. krytyczna Chi^2\n";

## Now restrict one PHI element to `1' in every loop
for ($i=1; $i< $factor_max ; $i++) {
   for ($j = $i + 1; $j<= $factor_max ; $j++) {

    run_lisrel($script, $i, $j, $chi);
    print STDERR "done\n";

}}

close(LL);

## ## ### ##

sub run_lisrel {
    my $lscript = shift ;
    my $v1 = shift ;
    my $v2 = shift ;
    my $baseline = shift ;

    print STDERR "Testing for $v1 $v2... (baseline: $baseline)";

    open (LX, ">$lisrel_script");
    unless ($baseline < 0 ) { ## Do not modify LISREL script for baseline model
    ## modify LISREL script restricting appropriate PHI element
      $lscript =~ s/! <<FIXPHI>>/FI PHI($v1,$v2)\nVA 1 PHI($v1,$v2)/; }
    print LX $lscript ; 
    close(LX);  

    ## run LISREL on modified script
    @lisrel_run = ($lisrel, $lisrel_script, "$lisrel_out");
    system(@lisrel_run);
    open (LO, "$lisrel_out");
    $out = <LO>;

    ## Look for `Minimum Fit Function Chi-Square' in the LISREL output file
    if ( $out =~ /Minimum Fit Function Chi-Square = ([0-9\.]+)/ ) {
      $chi_min = $1; } else {  $chi_min = -1; }
    
    if ( $baseline  > 0) {
        $chi_min_diff = $chi_min - $baseline;
        print LL "$v1,$v2 => $chi_min_diff ($chi_min) => $critical_chi\n";
    } else {
        print LL "$v1,$v2 => $chi_min ($chi_min) => $critical_chi\n";
    }

    close(LO);

    ## return Chi^2 value
    return $chi_min;

}

## OK
