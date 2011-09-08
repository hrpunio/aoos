# Przetwarza wyniki ankiety i usuwa nag³ówek
# 
$1 !~ /#/ {
 ocena = sprintf ("%.2f", (20 - ($37 + $38 + $39 + $40 )) /4 );  ## ¶rednia z pytañ p5--p8

 if ($31 == 0) {$31 = 1} ; if ($32 == 0) {$32 = 1} ; if ($33 == 0) {$33 = 1}
 if ($34 == 0) {$34 = 1} ;

 llkomp=sprintf ("%.4f",log($31)); $31= llkomp ; ## logarytm liczby komputerów 
 $32=sprintf ("%.4f", log($32)) ; ## logarytm liczby zatr w dziale IT
 $33=sprintf ("%.4f",log($33)) ; ## logarytm liczby zatr w dziale IT
 #if ($33 == 0 ) {$33 = 1} ;
 $34 = sprintf ("%.4f", log($34)) ; ## logarytm liczby zatr ogó³em/liczby zatr w dziale IT
 ###$31 = $32 = $33 = $34 = 1 ; ### nieu¿ywane

##recode ekd ('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'O', 'P' = 'P')
##  ('L', 'M', 'N' = 'B') ('?' = '?') into typf .

 if ($1 ~ /[ABCDEFGHIJKOP]/) { budzet = 0; }
 else { 
    if ($1 ~ /[LMN]/) { budzet = 1 ; }
    else {  budzet = -1 ; }
 }
 
 

 uzywa_lub_nie = $35;

 ## Przypisanie zmienia numeracje (UWAGA)
 $1 = $2 = "";
 gsub(/^[ ]+/, "");

 respond1 = $0 " " ocena " " llkomp ;

 print respond1;

 if (uzywa_lub_nie > 0) {  print respond1  > "badanie2__178.raw"  }

 if (budzet == 1  ) {  print respond1 > "badanie2__budzet.raw" }
 else {
    if (budzet == 0  ) {  print respond1 > "badanie2__przemysl.raw" }
 }
}
