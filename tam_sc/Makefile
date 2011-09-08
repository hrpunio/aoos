# -- make --
# tworzenie macierzy  kowariancji z pliku RAW 
# Plik $FILE.txth zawiera dane + wiersz nag³ówka z tego pliku s± generowane:
# $(FILE).txt zawiera same dane (bez wiersza nag³ówka); 
# $(FILE).mtx zawiera macierz kowariancji (jest tworzony za pomoc± prelis)
#
LISREL=lisrel87 
PRELIS=00.pr2
TETFILE=Model_TAM_00
FILE=Model_TAMSC_00

prelis:
	prelis27 $(PRELIS) tam_ff_prelis.out

# wycina pierwszy wiersz i zapisuje reszte w pliku .txt
txt: 
	cat $(TETFILE).txth | tr '\t' ' ' | awk ' NR==2,NR==9999 {print $0 }'  > $(FILE).txt


txt2: 
	awk -f proc1.awk $(TETFILE).txth > $(FILE).txt

txt2csv:
	cat $(FILE).lbl $(FILE).txt | tr ' ' ';'  > $(FILE).csv

## Konfirmacyjna analiza czynnikowa
## --------------------------------
## ostateczny model (24 zmiennych)
cfa-f: $(FILE).mtx
	$(LISREL) tamsc_cfa_final.ls8 tamsc__cfa_final.out && \
		perl print_cr_and_ave.pl tamsc__cfa_final.out > cr_and_ave_cfa_final.out

# model wstepny (26 zmiennych)
cfa-p: $(FILE).mtx
	$(LISREL) tamsc_cfa_prelim.ls8 tamsc_cfa_prelim.out && \
		perl print_cr_and_ave.pl tamsc_cfa_prelim.out > cr_and_ave_cfa_prelim.out

#
# model strukturalny
# ---------------------------------

full: prelis cfa-p cfa-f fully fullx test-dv

fully: $(FILE).mtx
	$(LISREL) tam_ff_fully.ls8 tam_ff__fully.out && \
		perl print_cr_and_ave.pl tam_ff__fully.out > cr_and_ave_fully.out

fullx: $(FILE).mtx
	$(LISREL) tam_ff_fullx.ls8 tam_ff__fullx.out && \
		perl print_cr_and_ave.pl tam_ff__fullx.out > cr_and_ave_fully_x.out
#
test-dv:
	perl test_discriminant_validity.pl  -f 8 -s tamsc_cfa_final-dv.ls8

stats:
	R --no-save < 00.R

