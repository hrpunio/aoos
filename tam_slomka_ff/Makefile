# -- make --
#
LISREL=lisrel87
FILE=wyniki_firefox

prelis:
	prelis27 TAM_ff.pr2 tam_ff_prelis.out

# Modele CFA dla 3 czynników:
# model wstepny (13 miar ; 3 czynniki)
#
cfa-3-0:
	$(LISREL) TAM_ff_cfa_3-0.ls8 tam_ff_cfa_3-0.out && \
		  perl print_cr_and_ave.pl tam_ff_cfa_3-0.out

# model wstepny (12 zmiennych ; 3 czynniki)
cfa-3-1:
	$(LISREL) TAM_ff_cfa_3-1.ls8 tam_ff_cfa_3-1.out

# model wstepny (11 zmiennych ; 3 czynniki)
cfa-3-2:
	$(LISREL) TAM_ff_cfa_3-2.ls8 tam_ff_cfa_3-2.out

# model ostateczny (10 zmiennych ; 3 czynniki)
cfa-3-3:
	$(LISREL) TAM_ff_cfa_3-3.ls8 tam_ff_cfa_3-3.out && \
 		  perl print_cr_and_ave.pl tam_ff_cfa_3-3.out


# Z zaleznosci± PEOU-PU
# ---------------------
tam:
	$(LISREL) TAM_ff.ls8 tam_ff.out && perl print_cr_and_ave.pl tam_ff.out > tam_ff-cr_and_ave.out

# testowanie trafno¶ci dyskryminacyjnej
test-dv:
	perl dvt.pl -f 3 -s TAM_ff_cfa-DV.ls8

stats:
	R --no-save < TAM_ff.R

## ## ## ## ## ## ## ## ## ##
## Usuniêcie plików generowanych:
clean:
	rm *.DSF *.MSF *.dsf *.freq *.FREQ *.BTS *.bts DUMP __test_dv.OUT_ || true
	rm Model_TAM_DVT.ls8 || true

## Usuniêcie plików generowanych i wynikowych:
xclean: clean
	rm *.out

## ## ## ##
## Przekodowuje dwie miary o skalach o odwrotnym porzadku
recode:
	gawk -F'x' -f select.awk wyniki_firefox_R.csv > wyniki_firefox.csv
	gawk -f select.awk wyniki_firefox_R.txt > wyniki_firefox.txt
