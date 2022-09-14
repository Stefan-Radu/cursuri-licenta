{-
Gasiti mai jos limbajul unui minicalculator si o interpretare partiala. 
Calculatorul are doua celule de memorie, care au valoarea initiala 0. Expresia `Mem := Expr` are urmatoarea semantica: 
`Expr` este evaluata, iar valoarea este pusa in `Mem`.  
Un program este o expresie de tip `Prog`iar rezultatul executiei este dat de valorile finale ale celulelor de memorie.
Testare se face apeland `run test`. 
-}

data Prog  = Stmt ::: Prog | Off
data Stmt  = Mem := Expr
data Mem = Mem1 | Mem2 
data Expr  =  M Mem | V Int | Expr :+ Expr | Expr :\ Expr

infixl 6 :+
infix 3 :=
infixr 2 :::

type Env = (Int, Int)   -- corespunzator celor doua celule de memorie (Mem1, Mem2)

expr :: Expr -> Env -> Int
expr (e1 :+ e2) m = expr e1 m + expr e2 m
expr (M mem) m = case mem of
  Mem1 -> fst m
  Mem2 -> snd m
expr (V x) m = x
expr (e1 :\ e2) m 
  | r2 == 0 = error "belea ala e 0"
  | otherwise = r1 `div` r2
  where r1 = expr e1 m
        r2 = expr e2 m


stmt :: Stmt -> Env -> Env
stmt (mem := e) env =
  let res = expr e env
   in case mem of
     Mem1 -> (res, snd env)
     Mem2 -> (fst env, res)

prog :: Prog -> Env -> Env
prog Off env = env
prog (s ::: p) env =
  let newEnv = stmt s env
   in prog p newEnv 

run :: Prog -> Env
run p = prog p (0, 0)

test1 = Mem1 := V 3 ::: Mem2 := M Mem1 :+ V 5 ::: Off
test2 = Mem2 := V 3 ::: Mem1 := V 4 ::: Mem2 := (M Mem1 :+ M Mem2) :+ V 5 ::: Off
test3 = Mem1 := V 3 :+  V 3 ::: Off
test4 = Mem1 := V 5 ::: Mem2 := V 0 ::: Mem1 := (M Mem1 :\ M Mem2) ::: Off
test5 = Mem1 := V 6 ::: Mem2 := V 2 ::: Mem1 := (M Mem1 :\ M Mem2) ::: Off

-------------------------------------

data Log = L [String]
data EnvLog = E (Int, Int, Log)
  
fst' :: EnvLog -> Int
fst' (E (a, _, _)) = a

snd' :: EnvLog -> Int
snd' (E (_, a, _)) = a

exprLog :: Expr -> EnvLog -> Int
exprLog (e1 :+ e2) env = exprLog e1 env + exprLog e2 env
exprLog (M mem) env = case mem of
  Mem1 -> fst' env
  Mem2 -> snd' env
exprLog (V x) env = x
exprLog (e1 :\ e2) env 
  | r2 == 0 = error "belea ala e 0"
  | otherwise = r1 `div` r2
  where r1 = exprLog e1 env
        r2 = exprLog e2 env


stmtLog :: Stmt -> EnvLog -> EnvLog
stmtLog (mem := e) (E (m1, m2, L log)) =
  let res = exprLog e (E (m1, m2, L log))
   in case mem of
     Mem1 -> E (res, m2, L (log ++ ["am pus " ++ (show res) ++ " in m1"]))
     Mem2 -> E (m1, res, L (log ++ ["am pus " ++ (show res) ++ " in m2"]))

progLog :: Prog -> EnvLog -> EnvLog
progLog Off env = env
progLog (s ::: p) env =
  let newEnv = stmtLog s env
   in progLog p newEnv 

runLog :: Prog -> EnvLog
runLog p = progLog p (E (0, 0, L []))

instance Show Log where
  show (L []) = ""
  show (L (h:t)) = show h ++ "\n" ++ show (L t)

instance Show EnvLog where
  show (E (a, b, c)) = "Env: (" ++ (show a) ++ ", " ++
    (show b) ++ ")\n" ++ show c

{-CERINTE

1) (10pct) Finalizati definitia functiilor de interpretare.
2) (10 pct) Adaugati expresia `e1 :/ e2` care evaluează expresiile e1 și e2, apoi
  - dacă valoarea lui e2 e diferită de 0, se evaluează la câtul împărțirii lui e1 la e2;
  - în caz contrar va afișa eroarea "împarțire la 0" și va încheia execuția.
3)(20pct) Definiti interpretarea  limbajului extins astfel incat executia unui program fara erori sa intoarca valoarea finala si un mesaj
   care retine toate modificarile celulelor de memorie (pentru fiecare instructiune `m := v` se adauga 
   mesajul final `Celula m a fost modificata cu valoarea v`), mesajele pastrand ordine de efectuare a instructiunilor.  
    Rezolvați subiectul 3) în același fișier redenumind funcțiile de interpretare. 

Indicati testele pe care le-ati folosit in verificarea solutiilor. 

-}
