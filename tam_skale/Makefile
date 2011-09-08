# -- make --
# T.Przechlewski 2011 (licencja GPL) http://member.acm.org/~tprzechlewski/sem/
#
LISREL=lisrel87 
FILE=Model_TAM
#
prelis:
	prelis27 Model_TAM.pr2 TAM-prelis.out

# wycina pierwszy wiersz i zapisuje reszte w pliku .txt
txt: 
	awk 'NR==2,NR==9999 { print $0 }' $(FILE).txth > $(FILE).txt

## Konfirmacyjna analiza czynnikowa

## model ostateczny CFA (12 zmiennych):
cfa-f: $(FILE).mtx
	$(LISREL) Model_TAM_CFA_f.ls8 TAM-cfa-f.out && \
		perl print_cr_and_ave.pl TAM-cfa-f.out > TAM-cr-ave-f.out

# model wstepny CFA (13 zmiennych):
cfa-p: $(FILE).mtx
	$(LISREL) Model_TAM_CFA_p.ls8 TAM-cfa-p.out

## Model strukturalny:
tam: 
	$(LISREL) Model_TAM.ls8 TAM-str.out

## Test trafno¶ci dyskryminacyjnej:
dvt:
	perl dvt.pl -f 3 -s Model_TAM_DVT.ls8

## Statystyki opisowe:
stats:
	R --no-save < Model_TAM.R

## Usuniêcie plików generowanych:
clean:
	rm *.DSF *.MSF *.dsf *.freq *.FREQ *.BTS *.bts DUMP __test_dv.OUT_ || true
	rm Model_TAM_DVT.ls8 || true

## Usuniêcie plików generowanych i wynikowych:
xclean: clean
	rm *.out
