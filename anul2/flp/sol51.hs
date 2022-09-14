{-
Gasiti mai jos limbajul unui minicalculator si o interpretare partiala. 
Memoria calculatorului este o stivă de valori (intregi), inițial vidă.

Un program este o listă de instrucțiuni iar rezultatul executiei este starea finală a memoriei.
Testare se face apeland `prog test`. 
-}

data Prog  = On [Stmt]
data Stmt
  = Push Int -- pune valoare pe stivă    s --> i s
  | Pop      -- elimină valoarea din vărful stivei            i s --> s
  | Plus     -- extrage cele 2 valori din varful stivei, le adună si pune rezultatul inapoi pe stivă i j s --> (i + j) s
  | Dup      -- adaugă pe stivă valoarea din vârful stivei    i s --> i i s
  | Loop [Stmt]

type Env = [Int]   -- corespunzator stivei care conține valorile salvate

evalAux :: [Stmt] -> Int -> Env -> Env
evalAux ss i env
  | len /= 1 = evalAux ss nextI res
  | otherwise = res
  where s = ss !! i
        res = stmt s env
        len = length res
        nextI = if i == (length ss) - 1 then 0 else i + 1

stmt :: Stmt -> Env -> Env
stmt (Push x) env = x:env
stmt Pop [] = error "stiva goala"
stmt Pop (h:t) = t
stmt Plus [] = error "stiva prea goala"
stmt Plus [_] = error "stiva prea goala"
stmt Plus (h1:h2:t) = (h1 + h2):t
stmt Dup [] = error "stiva goala"
stmt Dup (h:t) = h:(h:t)
stmt (Loop ss) env = evalAux ss 0 env

stmts :: [Stmt] -> Env -> Env
stmts [] env = env
stmts (h:t) env = stmts t (stmt h env)

prog :: Prog -> Env
prog (On ss) = stmts ss []

test1 = On [Push 3, Push 5, Plus]            -- [8]
test2 = On [Push 3, Dup, Plus]               -- [6]
test3 = On [Push 3, Push 4, Dup, Plus, Plus] -- [11]
test4 = On [Push 3, Push 2, Pop, Push 5]     -- [5, 3]
test5 = On [Push 3, Push 2, Push 1, Loop [Pop]]   -- [3] 
test6 = On [Push 3, Push 2, Push 1, Loop [Dup]]   -- la inf
test7 = On [Push 3, Push 2, Push 1, Loop [Pop], Pop, Loop [Push 6]]   -- [6]
-- test8 = On [Push 3, Push 2, Push 1, Loop [Pop], Pop, Loop [Push 6], Plus]   -- error
-- test9 = On [Push 3, Plus]            -- err
--

-----------------


evalAux' :: [Stmt] -> Int -> Maybe Env -> Maybe Env
evalAux' ss i Nothing = Nothing
evalAux' ss i env
  | res == Nothing = Nothing
  | len /= 1 = evalAux' ss nextI res
  | otherwise = res
  where s = ss !! i
        res = stmt' s env
        len = case res of 
          Nothing -> -1
          Just li -> length li
        nextI = if i == (length ss) - 1 then 0 else i + 1

stmt' :: Stmt -> Maybe Env -> Maybe Env
stmt' _ Nothing = Nothing
stmt' (Push x) (Just li) = Just (x:li)
stmt' Pop (Just []) = Nothing
stmt' Pop (Just (h:t)) = Just t
stmt' Plus (Just []) = Nothing
stmt' Plus (Just [_]) = Nothing
stmt' Plus (Just (h1:h2:t)) = Just ((h1 + h2):t)
stmt' Dup (Just []) = Nothing
stmt' Dup (Just (h:t)) = Just (h:(h:t))
stmt' (Loop ss) env = evalAux' ss 0 env

stmts' :: [Stmt] -> Maybe Env -> Maybe Env
stmts' _ Nothing = Nothing
stmts' [] env = env
stmts' (h:t) env = stmts' t (stmt' h env)

prog' :: Prog -> Maybe Env
prog' (On ss) = stmts' ss (Just [])

{-CERINTE

1) (10pct) Finalizati definitia functiilor de interpretare (aruncați excepții dacă stiva nu are suficiente valori pentru o instrucțiune)
2) (10 pct) Adaugati instrucțiunea `Loop ss` care evaluează repetat lista de instrucțiuni ss până când stiva de valori are lungime 1
   -- On [Push 1, Push 2, Push 3, Push 4, Loop [Plus]]  -- [10]
3) (20pct) Modificați interpretarea limbajului extins astfel incat interpretarea unui program / instrucțiune / expresie
   să nu mai arunce excepții, ci să aibă tipul rezultat `Maybe Env` / `Maybe Int`, unde rezultatul final în cazul în care
   execuția programului încearcă să scoată/acceseze o valoare din stiva de valori vidă va fi `Nothing`.
   Rezolvați subiectul 3) în același fișier redenumind funcțiile de interpretare.    
   
Indicati testele pe care le-ati folosit in verificarea solutiilor. 

-}
