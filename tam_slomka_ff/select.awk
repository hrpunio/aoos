#!/usr/bin/awk -f

BEGIN {if (FS == ";") { OFS = ";" }  }
/[pu]/ { print $0 ; next ; }
{ $6 = 8 - $6;  $8 = 8 - $8 ; print $0 ; }
