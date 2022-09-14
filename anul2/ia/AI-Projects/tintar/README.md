# Tintar + AI (Minimax & Alpha-Beta pruning)

## Cerinte

- [x] (5%) Să se păstreze următoare lucruri deja implementate în exemplu (sau să se implementeze daca cineva decide să refacă programul de la zero):
  - [x] La inceputul programului utilizatorul va fi intrebat ce algoritm doreste sa foloseasca (minimax sau alpha-beta)
  - [x] Utilizatorul va fi întrebat cu ce simbol sa joace (la jocurile unde are sens aceasta intrebare)
  - [x] Se va încerca evitarea sau tratarea situației în care utilizatorul ar putea răspunde greșit (de exemplu, nu poate selecta decât opțiunile corecte dintre care sunt selectate valorile default; sau, unde nu se poate așa ceva, jocul nu pornește până nu se primește un răspuns corect).
  - [x] Afisarea a cui este rândul să mute.
  - [x] Indicarea, la finalul jocului, a câstigatorului sau a remizei daca este cazul.
- [x] (5%) Utilizatorul va fi întrebat care sa fie nivelul de dificultate a jocului (incepator, mediu, avansat). In functie de nivelul ales se va seta adancimea arborelui de mutari (cu cat nivelul ales e mai mare, cu atat adancimea trebuie sa fie mai mare ca sa fie mai precisa predictia jocului). Posibilitatea utilizatorului de a face eventuale alte setări cerute de enunț. Se va verifica dacă utilizatorul a oferit un input corect, iar dacă nu se va trata acest caz (i se poate reafișa ecranul cu setările afișând și un mesaj de atenționare cu privire la inputul greșit).
- [x] (5%) Generarea starii initiale
- [x] (10%) Desenarea tablei de joc (interfața grafică) si afișarea în consolă a tablei (pentru debug; în ce format vreți voi). Titlul ferestrei de joc va fi numele vostru + numele jocului.
- [x] (15%) Functia de generare a mutarilor (succesorilor) + eventuala functie de testare a validitatii unei mutari (care poate fi folosita si pentru a verifica mutarea utilizatorului)
- [x] (5%) Realizarea mutarii utilizatorului. Utilizatorul va realiza un eveniment în interfață pentru a muta (de exemplu, click). Va trebui verificata corectitudinea mutarilor utilizatorului: nu a facut o mutare invalida.
- [x] (10%) Functia de testare a starii finale, stabilirea castigatorului și, dacă e cazul conform cerinței, calcularea scorului. Se va marca în interfața grafică configurația câștigătoare (sau simbolurile câștigătoare, în funcție de regulile jocului). Marcarea se poate face colorând, de exemplu, simbolurile sau culoare de fundal a eventualelor căsuțe în care se află.
- [x] (20%=10+10) Doua moduri diferite de estimare a scorului (pentru stari care nu sunt inca finale)
- [x] (15% impărtit după cum urmează) Afisari (în consolă).
  - [x] (5%) Afisarea timpului de gandire, dupa fiecare mutare, atat pentru calculator (deja implementat în exemplu) cat si pentru utilizator. Pentru timpul de găndire al calculatorului: afișarea la final a timpului minim, maxim, mediu și a medianei.
  - [x] (2%) Afișarea scorurilor (dacă jocul e cu scor), atat pentru jucator cat si pentru calculator și a estimărilor date de minimax și alpha-beta (estimarea pentru rădacina arborelui; deci cât de favorabilă e configurația pentru calculator, în urma mutării sale - nu se va afișa estimarea și când mută utilizatorul).
  - [x] (5%) Afișarea numărului de noduri generate (în arborele minimax, respectiv alpha-beta) la fiecare mutare. La final se va afișa numărul minim, maxim, mediu și mediana pentru numarul de noduri generat pentru fiecare mutare.
  - [x] (3%) Afisarea timpului final de joc (cat a rulat programul) si a numarului total de mutari atat pentru jucator cat si pentru calculator (la unele jocuri se mai poate sari peste un rand și atunci să difere numărul de mutări).
- [x] (5%) La fiecare mutare utilizatorul sa poata si sa opreasca jocul daca vrea, caz in care se vor afisa toate informațiile cerute pentru finalul jocului ( scorul lui si al calculatorului,numărul minim, maxim, mediu și mediana pentru numarul de noduri generat pentru fiecare mutare, timpul final de joc și a numarului total de mutari atat pentru jucator cat si pentru calculator) Punctajul pentru calcularea efectivă a acestor date e cel de mai sus; aici se punctează strict afișarea lor în cazul cerut.
- [ ] (5%) Comentarii. Explicarea algoritmului de generare a mutarilor, explicarea estimarii scorului si dovedirea faptului ca ordoneaza starile cu adevarat in functie de cat de prielnice ii sunt lui MAX (nu trebuie demonstratie matematica, doar explicat clar). Explicarea pe scurt a fiecarei functii si a parametrilor.
- [ ] Bonus (10%). Ordonarea succesorilor înainte de expandare (bazat pe estimare) astfel încât alpha-beta să taie cât mai mult din arbore.
- [x] Bonus (20%). Opțiuni în meniu (cu butoane adăugate) cu:
   - [x] Jucator vs jucător
   - [x] Jucător vs calculator (selectată default)
   - [x] Calculator (cu prima funcție de estimare) vs calculator (cu a doua funcție de estimare)
