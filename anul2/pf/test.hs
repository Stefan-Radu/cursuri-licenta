module Stef where 
import Data.Char


-- 1

-- fac o functie auxiliara de codificare
rsCodifica char 
  | (ord char) >= (ord 'a') && (ord char) <= (ord 'z') = (char, '#') -- litere mici
  | (ord char) >= (ord 'A') && (ord char) <= (ord 'Z') = (char, '*') -- litere mari
  | (ord char) >= (ord '0') && (ord char) <= (ord '9') = (char, '^') -- cifre
  | otherwise = (char, '_')                                          -- restul


-- a
-- recursiv, pentru fiecare caracter din lista aplic functia de mai sus asupra lui
-- si concatenez rezultatul la raspuns

rsRecursiv [] = [] -- caz lista vida
rsRecursiv (h:t) = (rsCodifica h):(rsRecursiv t) -- caz general

-- b
-- construiesc lista cu caracterele extrase din lista argument pentru care am apelat
-- functia de mai sus
rsListComp lista = [rsCodifica chr | chr <- lista]

-- c
-- cu map, 'mapuim' fiecare element din lista la corespondentul lui cu ajutorul functiei auxiliare
rsHighLvlF lista = map rsCodifica lista 

-- d
-- test quickcheck -> verifica ca rezultatul apelului cel doua functii este identic
rsVerifica lista = (rsRecursiv lista) == (rsHighLvlF lista)

-- Am testat cu:
-- "azAZ09*" -> [('a','#'),('z','#'),('A','*'),('Z','*'),('0','^'),('9','^'),('*','_')]
-- "" -> []
-- "~Z9a" -> [('~','_'),('Z','*'),('9','^'),('a','#')]

-- 2

-- abordare recursiva

rsFormat [] = [] -- 
rsFormat [a] = [a]
rsFormat (h1:h2:t) 
  | h1 == ' ' && h2 == ' ' = rsFormat (h2:t)
  | h1 == ' ' && h2 == '-' = rsFormat (h2:t)
  | h1 == '-' && h2 == ' ' = rsFormat (h1:t)
  | otherwise = h1:(rsFormat (h2:t))


-- mereu (cand este posibil) consider primele doua caractere din sufixul curent
-- de aici rezulta mai multe cazuri
-- daca avem doua spatii -> il eliminam pe primul
-- daca avem un spatiu, dupa care o cratima -> eliminam spatiul
-- daca avem cratima, dupa care spatiu, vrem sa eliminam spatiul si sa continuam formatarea cu cratima drept primul caracter. daca as fi adaugat in acest moment cratima la raspuns era posibil ca in final sa obtinem un string cu spatiu dupa cratima respectiva
-- in orice alt caz adaugam primul carater la solutie si continuam formatarea pe sufixul ramas

-- Am testat cu:
-- "Mi - am adus  aminte  de  tine." -> "Mi-am adus aminte de tine."
-- "Mi      -      am      adus   aminte   de   tine." -> "Mi-am adus aminte de tine."
-- "        " -> " "
-- "    -    " -> "-"
-- "    -  -    " -> "--"
