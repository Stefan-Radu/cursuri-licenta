
type Val = Bool
data Operatie = And | If Operatie Operatie
data Lit = V Val | Id String
data Arb
   = Leaf Lit
   | Node Operatie [Arb]
type Stare = [(String, Val)]   -- valori pentru identificatorii (`Id x`) din arbore

-- evaluez lista cu And
evalAnd :: [Arb] -> Stare -> Val
evalAnd [] _ = True
evalAnd (h:t) env = (eval h env) && (evalAnd t env)

eval :: Arb -> Stare -> Val
eval (Leaf l) env = evalLit l env
eval (Node And li) env = evalAnd li env
eval (Node (If op1 op2) []) env = error "lista vida"
eval (Node (If op1 op2) (h:t)) env = 
  let f = test (eval h env)
   in if f == True then eval (Node op1 t) env
                   else eval (Node op2 t) env

evalLit :: Lit -> Stare -> Val
evalLit (V v) _ = v
evalLit (Id str) env = 
  let val = lookup str env
   in case val of
     Nothing -> error "variabila negasita"
     Just x -> x


test :: Val -> Bool
test = id

-- pt 1
-- eroare
test1 = eval (Node And [(Leaf (V True)), (Leaf (Id "x"))]) []
-- False
test2 = eval (Node And [(Leaf (V True)), (Leaf (Id "x"))]) [("x", False)]
-- True
test3 = eval (Node And [(Leaf (V True)), (Leaf (Id "x"))]) [("x", True)]

-- pt 2
-- False
test4 = eval (Node (If And (If And And)) [(Leaf (V True)), (Leaf (Id "x")), (Leaf (V False))]) [("x", True)]
-- False
test5 = eval (Node (If And (If And And)) [(Leaf (V False)), (Leaf (Id "x")), (Leaf (V True))]) [("x", True)]
-- Error
test6 = eval (Node (If And (If And And)) [(Leaf (Id "y"))]) [("x", True), ("y", False)]


-- pt 3

maybeAnd :: Maybe Val -> Maybe Val -> Maybe Bool
maybeAnd (Just a) (Just b) = Just (a && b)
maybeAnd Nothing _ = Nothing
maybeAnd _ Nothing = Nothing

evalAnd' :: [Arb] -> Stare -> Maybe Val
evalAnd' [] _ = Just True
evalAnd' (h:t) env = (eval' h env) `maybeAnd` (evalAnd' t env)

eval' :: Arb -> Stare -> Maybe Val
eval' (Leaf l) env = evalLit' l env
eval' (Node And li) env = evalAnd' li env
eval' (Node (If op1 op2) []) env = Nothing
eval' (Node (If op1 op2) (h:t)) env = 
  let f = test' (eval' h env)
   in case f of
     (Just v) -> if v == True then eval' (Node op1 t) env
                               else eval' (Node op2 t) env
     Nothing -> Nothing

evalLit' :: Lit -> Stare -> Maybe Val
evalLit' (V v) _ = Just v
evalLit' (Id str) env = lookup str env -- intoarce maybe deja

test' :: Maybe Val -> Maybe Bool
test' (Just val) = Just (test val)
test' Nothing = Nothing

-- pt 1
-- Nothing
test1' = eval' (Node And [(Leaf (V True)), (Leaf (Id "x"))]) []
-- False
test2' = eval' (Node And [(Leaf (V True)), (Leaf (Id "x"))]) [("x", False)]
-- True
test3' = eval' (Node And [(Leaf (V True)), (Leaf (Id "x"))]) [("x", True)]

-- pt 2
-- False
test4' = eval' (Node (If And (If And And)) [(Leaf (V True)), (Leaf (Id "x")), (Leaf (V False))]) [("x", True)]
-- False
test5' = eval' (Node (If And (If And And)) [(Leaf (V False)), (Leaf (Id "x")), (Leaf (V True))]) [("x", True)]
-- Nothing
test6' = eval' (Node (If And (If And And)) [(Leaf (Id "y"))]) [("x", True), ("y", False)]
