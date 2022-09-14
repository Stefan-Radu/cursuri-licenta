module Test where

data Linie = L [Int] 
data Matrice = M [Linie]

-- ex 1
liniiN (M linii) n = if n < 0
                  then error "nu se poate cu lungime negativa"
                  else [L l | L l <- linii, length l == n]


-- ex 2
doarPozN (M linii) n 
  | n >= 0 = [x | x <- partial, x == True] == []
  | otherwise = error "lungime negativa"
  where
    liniiLungN = liniiN (M linii) n
    liLungN = [li | L li <- liniiLungN]
    hasNeg [] = False
    hasNeg (h:t) = if h <= 0 then True else hasNeg t 
    partial = [hasNeg l | l <- liLungN]


-- ex 3

sumLi :: Linie -> Int
sumLi (L li) = foldr (+) 0 li

verifica (M linii) n = 
  foldr (\linie accum -> accum && ((sumLi linie) == n)) True linii

instance Show Linie where
  show (L []) = "\n"
  show (L (h:t)) = show h ++ " " ++ show (L t)

instance Show Matrice where
  show (M []) = ""
  show (M (h:t)) = show h ++ show (M t)


-- T nr 1

-- ex 1
data Punct = Pt [Int] deriving Show

nrPozitive :: Punct -> Int
nrPozitive (Pt []) = 0
nrPozitive (Pt (h:t)) = if h > 0 then 1 + nrPozitive (Pt t) else nrPozitive (Pt t)


-- ex 2
z3Poz :: [Punct] -> [Punct]
z3Poz lista = [Pt k | (Pt k) <- lista, length k == 3, nrPozitive (Pt k) == length k]


-- ex 3

length' li = foldr (\x accum -> accum + 1) 0 li

calculeaza (Pt li1) (Pt li2)
  | length' li1 /= length' li2 = "*** Exception lungimi diferite"
  | otherwise = foldr (\(a, b) accum -> accum + (a + b) ^ 2) 0 zipLi
  where 
    zipLi = zip li1 li2
