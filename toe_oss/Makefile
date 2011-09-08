# -- make --
#
LISREL=lisrel87 
FILE=badanie2__216
FILES=badanie2__216_S
FILED=badanie2__216_D

prelis:
	prelis27 $(FILE).pr2 $(FILE)_prelis.out

all: m44 m44-1 m3 cfa-s cfa-sx cfa-d cfa-dx  test-dv

## pe³ny model strukturalny
## ------------------------
## modele podstawowe (Zastosowania serwerowe):
# ------------------------------
m44: 
	$(LISREL) $(FILES)-M44.ls8 $(FILES)-M44.out
	$(LISREL) $(FILED)-M44.ls8 $(FILED)-M44.out

m44-1: 
	$(LISREL) $(FILES)-M44-1.ls8 $(FILES)-M44-1.out
	$(LISREL) $(FILED)-M44-1.ls8 $(FILED)-M44-1.out

# modele podstawowe (Zastosowania desktopowe):

m3: 
	$(LISREL) $(FILES)-M3.ls8 $(FILES)-M3.out
	$(LISREL) $(FILED)-M3.ls8 $(FILED)-M3.out

# CFA
# ----
# pliki SS/DD to to samo tylko skale s± ustawiane inaczej:
cfa-s: 
	$(LISREL) $(FILES)_cfa.ls8  $(FILES)_cfa.out
	perl print_cr_and_ave.pl  $(FILES)_cfa.out > $(FILES)_cfa_crave.out
	$(LISREL) $(FILES)S_cfa.ls8  $(FILES)S_cfa.out 
	perl print_cr_and_ave.pl  $(FILES)S_cfa.out  > $(FILES)S_cfa_crave.out
cfa-sx: 
	$(LISREL) $(FILES)X_cfa.ls8  $(FILES)X_cfa.out
	perl print_cr_and_ave.pl  $(FILES)X_cfa.out > $(FILES)X_cfa_crave.out

cfa-d: 
	$(LISREL) $(FILED)_cfa.ls8  $(FILED)_cfa.out
	perl print_cr_and_ave.pl  $(FILED)_cfa.out > $(FILES)_cfa_crave.out
	$(LISREL) $(FILED)D_cfa.ls8  $(FILED)D_cfa.out
	perl print_cr_and_ave.pl  $(FILED)D_cfa.out > $(FILES)D_cfa_crave.out

cfa-dx: 
	$(LISREL) $(FILED)X_cfa.ls8  $(FILED)X_cfa.out
	perl print_cr_and_ave.pl  $(FILED)X_cfa.out >  $(FILED)X_cfa_crave.out

# testowanie trafno¶ci dyskryminacyjnej
# wynik jest w pliku tam_ff_cfa_test_dv.out
test-dv:
	perl test_discriminant_validity.pl  -f 5 -s badanie2__216_S_cfa_DV.ls8  -o cfa_test_dv_S.out
	perl test_discriminant_validity.pl  -f 5 -s badanie2__216_D_cfa_DV.ls8  -o cfa_test_dv_D.out
	rm badanie2__216_D_cfa_DV.ls8 badanie2__216_S_cfa_DV.ls8 toe_cfa_test_dv.out_

# Usuwa naglowek i przetwarza plik
txt2raw:
	LANG=C awk -f strip.awk  badanie_toe.txt  > badanie_toe.raw


clean:
	rm *.DSF *.PSF *.MSF *.BTS *.dsf

xclean: clean
	rm *.out
