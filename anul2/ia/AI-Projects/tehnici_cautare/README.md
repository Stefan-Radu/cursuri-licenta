# Tehnici de cautare - Evadarea lui Mormocel

## Cerinte

- [x] 1. (5%) Fișierele de input vor fi într-un folder a cărui cale va fi dată în linia de comanda. În linia de comandă se va da și calea pentru un folder de output în care programul va crea pentru fiecare fișier de input, fișierul sau fișierele cu rezultatele. 
  * Tot în linia de comandă se va da ca parametru și numărul de soluții de calculat (de exemplu, vrem primele NSOL=4 soluții returnate de fiecare algoritm)
  * Ultimul parametru va fi timpul de timeout. Se va descrie în documentație forma în care se apelează programul, plus 1-2 exemple de apel.
- [x] 2. (5%) Citirea din fisier + memorarea starii. Parsarea fișierului de input care respectă formatul cerut în enunț
- [x] 3. (15%) Functia de generare a succesorilor
- [x] 4. (5%) Calcularea costului pentru o mutare
- [x] 5. (10%) Testarea ajungerii în starea scop (indicat ar fi printr-o funcție de testare a scopului)
- [x] 6. (15% = 2+5+5+3 ) 4 euristici:
  - [x] (2%) banala
  - [x] (5%+5%) doua euristici admisibile posibile (se va justifica la prezentare si in documentație de ce sunt admisibile)
  - [x] (3%) o euristică neadmisibilă (se va da un exemplu prin care se demonstrează că nu e admisibilă). Atenție, euristica neadmisibilă trebuie să depindă de stare (să se calculeze în funcție de valori care descriu starea pentru care e calculată euristica).
- [x] 7. (10%) crearea a 4 fisiere de input cu urmatoarele proprietati:
  - [x] un fisier de input care nu are solutii
  - [x] un fisier de input care da o stare initiala care este si finala (daca acest lucru nu e realizabil pentru problema, aleasa, veti mentiona acest lucru, explicand si motivul).
  - [x] un fisier de input care nu blochează pe niciun algoritm și să aibă ca soluții drumuri lungime micuță (ca să fie ușor de urmărit), să zicem de lungime maxim 20.
  - [x] un fisier de input care să blocheze un algoritm la timeout, dar minim un alt algoritm să dea soluție (de exemplu se blochează DF-ul dacă soluțiile sunt cât mai "în dreapta" în arborele de parcurgere)
  - [x] dintre ultimele doua fisiere, cel putin un fisier sa dea drumul de cost minim pentru euristicile admisibile si un drum care nu e de cost minim pentru cea euristica neadmisibila
- [x] 8. (15%) Pentru cele NSOL drumuri(soluții) returnate de fiecare algoritm (unde NSOL e numarul de soluții dat în linia de comandă) se va afișa:
  - [x] lungimea drumului ( nr de salturi )
  - [x] costului drumului ( distanta parcursa )
  - [x] timpul de găsire a unei soluții (atenție, pentru soluțiile de la a doua încolo timpul se consideră tot de la începutul execuției algoritmului și nu de la ultima soluție)
  - [x] numărul maxim de noduri existente la un moment dat în memorie
  - [x] numărul total de noduri calculate (totalul de succesori generati; atenție la DFI și IDA* se adună pentru fiecare iteratie chiar dacă se repetă generarea arborelui, nodurile se vor contoriza de fiecare dată afișându-se totalul pe toate iterațiile
Obținerea soluțiilor se va face cu ajutorul fiecăruia dintre algoritmii studiați:
  - [x] UCS
  - [x] A* (varianta care dă toate drumurile)
  - [x] A* optimizat (cu listele open și closed, care dă doar drumul de cost minim)
  - [x] IDA*
  - [x] Pentru toate variantele de A\* (cel care oferă toate drumurile, cel optimizat pentru o singură soluție, și IDA\*) se va rezolva problema cu fiecare dintre euristici. Fiecare din algoritmi va fi rulat cu timeout, si se va opri daca depășește acel timeout (necesar în special pentru fișierul fără soluții unde ajunge să facă tot arborele)
- [x] 9. (5%) Afisarea in fisierele de output in formatul cerut
- [x] 10. (5%) Validări și optimizari. Veți implementa elementele de mai jos care se potrivesc cu varianta de temă alocată vouă:
  - [x] găsirea unui mod de reprezentare a stării, cât mai eficient
  - [x] verificarea corectitudinii datelor de intrare
  - [x] găsirea unui mod de a realiza din starea initială că problema nu are soluții.
  - [x] Validările și optimizările se vor descrie pe scurt în documentație.
- [x] 11. (5%) Comentarii pentru clasele și funcțiile adăugate de voi în program (dacă folosiți scheletul de cod dat la laborator, nu e nevoie sa comentați și clasele existente). Comentariile pentru funcții trebuie să respecte un stil consacrat prin care se precizează tipul și rolurile parametrilor, căt și valoarea returnată (de exemplu, reStructured text sau Google python docstrings).
- [x] 12. (5%) Documentație cuprinzând explicarea euristicilor folosite. În cazul euristicilor admisibile, se va dovedi că sunt admisibile. În cazul euristicii neadmisibile, se va găsi un exemplu de stare dintr-un drum dat, pentru care h-ul estimat este mai mare decât h-ul real. Se va crea un tabel în documentație cuprinzând informațiile afișate pentru fiecare algoritm (lungimea și costul drumului, numărul maxim de noduri existente la un moment dat în memorie, numărul total de noduri). Pentru variantele de A* vor fi mai multe coloane în tabelul din documentație: câte o coloană pentru fiecare euristică. Tabelul va conține datele pentru minim 2 fișiere de input, printre care și fișierul de input care dă drum diferit pentru euristica neadmisibilă. În caz că nu se găsește cu euristica neadmisibilă un prim drum care să nu fie de cost minim, se acceptă și cazul în care cu euristica neadmisibilă se obțin drumurile în altă ordine decât crescătoare după cost, adică diferența să se vadă abia la drumul cu numărul K, K>1). Se va realiza sub tabel o comparație între algoritmi și soluțiile returnate, pe baza datelor din tabel, precizând și care algoritm e mai eficient în funcție de situație. Se vor indica pe baza tabelului ce dezavantaje are fiecare algoritm.


## Documentatie

### Cerinta

[Evadarea lui Mormocel, de aici](http://irinaciocan.ro/inteligenta_artificiala/exemple-teme-a-star.php)

### Cum rulezi
``` bash
python -m tehnici_cautare input_folder output_folder -ns NSOL -t TIMEOUT
```
exemplu: ` python -m tehnici_cautare tehnici_cautare/input/ tehnici_cautare/output -ns 10 -t 1`


### Format fisier de intrare

* raza lac
* greutate initiala
* id frunza start
* oricate frunze de forma {id, x, y, nr_insecte, greutate_maxima}

### Validari / Optimizari

#### Reprezentarea starii

Am separat nodul si starea in obiecte separate: 

Nod: `{ _id, coor(x, y), nr_insecte, limita_greutate }` 
Encapsuleaza detalii din input

Stare: `{ node, weight, prev_state, eaten_insects, cost, dist }`
Encapsuleaza o stare. Tin informatiile strict necesare + un _backpointer_ ca sa pot reconstrui pathul usor. Overload pe `__lt__` ca sa pot sorta usor dupa cost in priority queue.

#### Validarea datelor de intrare

* verific tipurile de date
* ma asigur ca limitele de greutate sunt pozitive
* ma asigur ca numarul de insecte e pozitiv

``` python
assert isinstance(x, int)
assert isinstance(y, int)
assert isinstance(ma_we, int) and ma_we >= 0
assert isinstance(ins_co, int) and ins_co >= 0
```

* ma asigur ca coordonatele frunzelor sunt **STRICT** in interiorul lacului

``` python
dist = Graph.GetDist((x, y), (0, 0))
assert dist < self.radius
```

* ma asigur ca id-ul nodului de start este valid

``` python
self.nodes = {}
# ... #
for eachnode in input:
  # ... #
  self.nodes[_id] = Node(_id, x, y, ins_co, ma_we)

assert self.start_node in self.nodes
```

#### Verificare din start ca nu exista solutii

Daca nu exista nicio frunza care sa fie mai apropia de `max_weight // 3` de mal sigur nu am cum sa ajung vreodata la mal.
``` python
found_exit_leaf = False

for line in input:
  # ... #
  dist = Graph.GetDist((x, y), (0, 0))
  if self.radius - dist <= ma_we // 3: found_exit_leaf = True
  # ... #

if not found_exit_leaf: print(f'No solutions for input {in_id}')
```

#### Optimizari

* am facut generatori pentru expansiunea nodurilor si a starilor pentru a solicita mai putin memoria
* folosesc un set pentru verificare apartenentei in path a unui nod pentru a reduce complexitatea
* am utilizat priority queue peste tot unde era posibil 

### Despre Euristici

#### Euristica Triviala

Daca sunt in interiorul lacului, sigur mai am cel putin un pas de facut (_distanta 1 de parcurs_), iar daca am ajuns mai am 0 pasi de facut. E admisibila.

``` python
def trivial_heuristic(self, state: State):
  ''' final state -> good else nothing '''
  return 0 if self.is_final_state(state) else 1
```

#### Euristica Admisibila 1

Distanta Manhattan de la frunza la cel mai apropiat punct de pe mal. Cum am folosit si in restul problemei distanta manhattan, e clar ca orice drum de la frunza la mal o sa fie cel putin la fel de lung ca estimarea mea, deci euristica e admisibila.

``` python
def admissible_heuristic1(self, state: State):
  ''' manhattan distance from node to edge '''
  dist = Graph.GetDist(state.node.coord, (0, 0))
  return max(0, self.radius - dist)
```

#### Euristica Admisibila 2

Distanta Euclidiana de la frunza la cel mai apropiat punct de pe mal. Consider observatia de la `Euristica Admisibila 1` si faptul ca distanta Euclidiana intre doua puncte este cel mult la fel de mare ca distanta Manhattan intre aceleasi doua puncte. Ajung la concluzia ca euristica e admisibila.

``` python
def admissible_heuristic2(self, state: State):
  ''' euclidian distance from node to edge '''
  dist = Graph.GetEuclidianDist(state.node.coord, (0, 0))
  return max(0, self.radius - dist)
```

#### Euristica Neadmisibila

Complementul fata de centru al `Euristicii admisibile 1`, adica distanta Manhattan pana la centru. Practic, sunt prioritizate drumurile care duc spre contru, in locul celor care duc spre mal.

``` python
def inadmissible_heuristic(self, state: State):
  ''' distance from the center '''
  return Graph.GetDist(state.node.coord, (0, 0))
```

Pentru `raza = 6`, frunza cu `coord = (3, -2)` limita de greutate `6` si `greutate = 6` euristica estimeaza `5`, in timp ce distanta reala este `dist = 1` deoarece starea noastra este finala si putem ajunge la mal dintr-un salt de lungime `1`

### Detalii suplimentare

#### Input 2 - starea initiala e si finala

| Detaliu | UCS | A* ET | A* E1 | A* E2 | A* EI | A*OC ET | A*OC E1 | A*OC E2 | A*OC EI | IDA* ET | IDA* E1 | IDA* E2 | IDA* EI |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| Runtime | 0.014ms | 0.011ms | 0.011ms | 0.011ms | 0.009ms | 0.009ms | 0.009ms | 0.008ms | 0.008ms | 0.005ms | 0.011ms | 0.004ms | 0.011ms |
| Pasi    | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 |
| Lungime | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
| Cnt max | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 2 | 3 | 4 | 5 |
|Cnt total| 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 |


#### Input 3 - merg toate

| Detaliu | UCS | A* ET | A* E1 | A* E2 | A* EI | A*OC ET | A*OC E1 | A*OC E2 | A*OC EI | IDA* ET | IDA* E1 | IDA* E2 | IDA* EI |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| Runtime | 1.110ms | 0.963ms | 0.794ms | 1.202ms | 0.945ms | 0.344ms | 0.269ms | 0.291ms | 0.344ms | 0.177ms | 0.094ms | 0.387ms | 0.578ms |
| Pasi    | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 |
| Lungime | 5 | 5 | 5 | 5 | 6 | 5 | 5 | 5 | 6 | 5 | 5 | 5 | 5 |
| Cnt max | 50 | 33 | 20 | 58 | 50 | 17 | 11 | 12 | 17 | 58 | 67 | 103 | 164 |
|Cnt total| 92 | 73 | 55 | 92 | 92 | 34 | 26 | 26 | 34 | 84 | 95 | 147 | 238 |


#### Input 4 - crapa unele

| Detaliu | UCS | A* ET | A* E1 | A* E2 | A* EI | A*OC ET | A*OC E1 | A*OC E2 | A*OC EI | IDA* ET | IDA* E1 | IDA* E2 | IDA* EI |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| Runtime | TIMEOUT | TIMEOUT | 40.472ms | 402.40ms | TIMEOUT | 11.931ms | 3.718ms | 8.463ms | 13.183ms | TIMEOUT | 5.967ms | 621.227ms | TIMEOUT |
| Pasi    | N/A | N/A | 7 | 6 | N/A | 5 | 6 | 5 | 6 | N/A | 6 | 6 | N/A |
| Lungime | N/A | N/A | 8 | 8 | N/A | 8 | 8 | 8 | 8 | N/A | 8 | 8 | N/A |
| Cnt max | 64886 | 61138 | 2437 | 19805 | 58410 | 73 | 76 | 81 | 87 | 183116 | 183681 | 236673 | 313384 |
|Cnt total| 81777 | 77001 | 3092 | 26597 | 75517 | 1277 | 437 | 909 | 1482 | 239074 | 239800 | 308561 | 415271 |


Din tabele se observa:
* A* cu euristica buna are runtime mai bun ca UCS dar mai rau ca restul
* A*OC (optimizat) foloseste semnificativ mai putine resurese ca A*
* A*OC (optimizat) are un runtime semnificativ mai bun ca A*
* Euristicile au un efect foarte proeminent asupra runtime-ului, in ciuda diferentelor aparent mici (Manhattan vs Euclidiana)
* IDA* se misca mai bine ca A*OC pe testul micut, dar mai rau(pentru ca foloseste mult mai multe resurse probabil) pe testul mai mare
