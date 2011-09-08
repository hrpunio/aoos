#!/usr/bin/perl
# Computes/prints Composite Reliability (CR) and Average Variance Extracted (AVE)
# from LISREL OUT file. Measures can load on several factors
#
# (c) 2010; t.przechlewski http://pinkaccordions.homelinux.org/staff/tp/
# GPL license
# 
# The formulas for CR and AVE are as follows [cf. Hair, Anderson, Tatham and Black, Multivariate Data Analysis, 5th Ed., Pearson Education, p. 637]:
# CR = (\sum standardized loading)^2 / (  (\sum standardized loading)^2 + \sum  indicator measurement error ), 
# AVE = (\sum (standardized loading)^2 ) / ( \sum (standardized loading)^2  + \sum indicator measurement error ) 
#    where: indicator measurement error  = 1 - loading^2
# see also: http://zencaroline.blogspot.com/2007/06/composite-reliability.html
#
# usage: perl print_cr_and_ave lisrel-output-file
#
my $scan = 0; ## flag to figure out where we are
my $initial_latent_var_no = 0;

while (<>) {
 chomp;

 if (/LK[ \t]+;/) { s/.*;// ; @lk_vars = split  ' ', $_; print STDERR "*** LK: @lk_vars ***\n";  next ; }
 if (/LE[ \t]+;/) { s/.*;// ; @le_vars = split  ' ', $_; print STDERR "*** LE: @le_vars ***\n";  next ; }

 # first Eta then Xi variables:
 @lk_le = (@le_vars, @lk_vars);

 # We are looking for the line with `Completely Standardized Solution' (CSS), which
 # starts the block containing relevant data
 if (/Completely Standardized Solution/) { $scan = 1 ; 
     print STDERR "*** Found *** $_ ***\n";  next ; }

 # After CSS line we look the line with LAMBDA-* (there are up to two such lines)
 if ( $scan > 0 && /LAMBDA-[XY]/ ) {  
   $scan++;

   print STDERR "*** Found *** $_ (initial: $initial_latent_var_no) ***\n";
				      
   $_ = <> ; $_ = <> ; $_ = <> ; ## eat exactly next three lines

   ## ok we are about to scan LAMBDA-X/Y matrix
   while (<>) { 
     chomp;

     if (/^[ \t]*$/) { # exmpty line ends LAMBDA-X/Y matrix
       ## before reading next block store the number of latent vars from the 1st block
       ## first latent var number in the second block = number of vars in the previous block +1
       $initial_latent_var_no += $#loadings;

       print STDERR "*** Initial var number = $initial_latent_var_no ***\n";
       last ; ## OK, all rows in matrix was read...
     }

     s/- -/xxx/g; # change `- -' to `xxx'
     @loadings = split ' ', $_;
     
     # column number = latent var number ; column `0' contains measurement variable name
     for ($l=1; $l <= $#loadings; $l++) {
       if ($loadings[$l] !~ /xxx/) { ## store in hash
	 $Loadings{$l + $initial_latent_var_no }{$loadings[0]} = $loadings[$l];  
	 $VarLabel{ $l + $initial_latent_var_no } = $lk_le [$l + $initial_latent_var_no - 1];
       }
     }
   } ### end_of_last
 } ## end_of_if LAMBDA

 if ( $scan > 0 && /PHI/ ) {  
   $scan++;
   print "Squared PHI matrix\n";
   ### drukujemy macierz kowariancji zmienneych Xi
   $_ = <> ; $_ = <> ; $_ = <> ; ## eat exactly next three lines
   while (<>) { 
     chomp;
     if (/^[ \t]*$/) { # exmpty line ends PHI MATRIX
       last ; ## OK, all rows in matrix was read...
     }
     @phi_ = split ' ', $_; ## split a'la AWK

     printf "%9.9s", $phi_[0];

     for ($i = 1; $i <= $#phi_ ; $i++ ) { printf "+%6.3f", $phi_[$i] * $phi_[$i]; }
     print "\n";
   }
 }

}

print STDERR "*** Latent variables = $initial_latent_var_no ***\n";

print "=======================================================\n";

###  Compute/print CR i AVE ### ### ### ###

    for $l (sort keys %Loadings ) {
       $loadings = $sqloadings = $errors = 0;

       if ( defined $VarLabel{$l} ) {
       print STDERR "*** Xi/Eta: $l ($VarLabel{$l})***\n";
       } else {  print STDERR "*** Xi/Eta: $l ***\n"; }

       for $m ( sort  keys %{ $Loadings{ $l }} ) {
         $load = $Loadings{$l}{$m};

         print STDERR "$m ($l) = $load\n";
         
         $loadings += $load ;
         $sqloadings += $load * $load ;
         $errors += (1 - $load * $load);
       }

       $cr = ($loadings * $loadings) / ( ($loadings * $loadings) +  $errors ) ;
       $ave = $sqloadings / ($sqloadings + $errors ) ;

       printf "Xi/Eta_%2d (%s) -> CR = %6.3f AVE = %6.3f\n", $l, $VarLabel{$l},  $cr, $ave;
     
    }

print "=======================================================\n";
## koniec
