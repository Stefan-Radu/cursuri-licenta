-- Lab 1


doubleMe x = x * 2

doubleUs x y = doubleMe (x + y)

doubleSmallNumber x = if x > 100
                         then x
                         else x * 2

main = print "hello world"

f [_, _] = False
f [_, _, _, _] = False
f _ = True

fact 0 = 1
fact x = x * (fact (x - 1))
-------------------------------------------------------------------------------



-- Lab 2

imparele :: [Integer] -> [Integer]
imparele [] = []
imparele (h:t) = 
  if even h then
            imparele t
  else
    h:(imparele (t))


foo a b [] = []
foo a b (h:t) = 
  if a <= h && h <= b then h:(foo a b t)
  else (foo a b t)


foo' a b li = [x | x <- li, a <= x, x <= b]


pozimp [] = []
pozimp [_] = [] 
pozimp (h:hh:t) = hh:(pozimp t)


pozimp' li = [ x | (x, i) <- (zip li [1..]), odd i]


pozImp [] _ = []
pozImp (h:t) i = if even h then pozImp t (i + 1)
                else (i):(pozImp t (i + 1))

pozImpRec li = pozImp li 0

-------------------------------------------------------------------------------

-- Lab 3

factori n = [x | x <- [1..n], n `mod` x == 0]
prim n = factori n == [1, n]
numerePrime n = filter prim [1..n]


-- ex3 l = map (^2) (filter (\(_, i) -> odd i) (zip l [1..]))

ex3' li = 
  let l' = zip li [1..] in
  let l'' = filter (\(_, y) -> odd y) l' in
  map (\(x, _) -> x ^ 2) l''


ordonataNat [] = True
ordonataNat [x] = True
ordonataNat li = 
  let l' = zip li (tail li) in
  and [ x < y | (x, y) <- l' ]


rev li = foldl (\x y -> (y:x)) [] li

fumFoldl l = foldl (+) 0 l
fumFoldr l = foldr (+) 0 l


filter' f li = foldr (\x accum -> if f x then (x:accum) else accum) [] li

map' f li = foldr (\x accum -> (f x):accum) [] li

-- asta face reverse
map'' f li = foldl (\accum x -> (f x):accum) [] li

-------------------------------------------------------------------------------

-- Lab 4

recap [] = 0
recap [_] = error "len par"
recap (a:b:t) = (a * b) + recap (t)

-- Expresii

data Expr = Numar Int 
          | Adunare Expr Expr 
          | Inmultire Expr Expr
          | Scadere Expr Expr
          deriving(Show)

-- 2  * (5 + 7) + 3
expr = Adunare (Inmultire (Numar 2) (Adunare (Numar 5) (Numar 7))) (Numar 3)

eval (Adunare expr1 expr2) = (eval expr1) + (eval expr2)
eval (Inmultire expr1 expr2) = (eval expr1) * (eval expr2)
eval (Scadere expr1 expr2) = (eval expr1) - (eval expr2)
eval (Numar n) = n


data Stiva = Goala | Element Int Stiva deriving(Show)

-- add::Int -> Stiva -> Stiva
-- add x Stiva = Element x Stiva


-- Algaebraic data types
-- Sum data types

data Optional a = Nimic | Ceva a deriving(Show)

find [] _ = Nimic
find ((a, b):t) cheie = if a == cheie then Ceva a
                                      else find t cheie

data Fructe = Mere String Int | Portocale Int | Nuci Int deriving(Show)
fructe = [Mere "Golden" 18, Portocale 39, Portocale 19, Nuci 3]

emar (Mere _ _) = True
emar _ = False

doar_mere :: [] Fructe -> [Fructe]
-- doar_mere :: [Fructe] -> [Fructe]
doar_mere fructe = filter emar fructe
doar_mere' fructe = filter (\fruct -> case fruct of
                        (Mere _ _) -> True
                        _ -> False
                     ) fructe

data Result a b = Ok a | Err b deriving(Show)

divopt _ 0 = Err "nu impart la 0"
divopt a b = Ok (a `div` b)

-------------------------------------------------------------------------------

-- Lab 5

sum2 :: [Int] -> (Int, Int)
sum2 li
  | length li == 0 = (0, 0)
  | length li == 1 = (head li, 0)
  | otherwise = (x + (head li), y + head (tail li))
  where
    (x, y) = sum2 (tail (tail li))


data Figura a = Cerc a | Dreptunghi a a | Patrat a deriving(Show)

-- aria 

aria (Cerc raza) = pi * raza * 2
aria (Dreptunghi l1 l2) = l1 * l2
aria (Patrat l) = l ^ 2

aria' figura = case figura of
                    Cerc raza -> raza ^ 2 * pi
                    Dreptunghi l1 l2 -> l1 * l2
                    Patrat l -> l ^ 2


data Expr' a = Numar' a | (Expr' a) :+: (Expr' a) | (Expr' a) :*: (Expr' a)

-- "If it walks like a duck and it quacks like a duck it probably is a duck"
-- Type class -> functionalitate
-- implementez un typeclass -> implementez functionalitatea din acel type class


data Nat = Zero | Succ Nat deriving(Show)

egal Zero Zero = True
egal _ Zero = False
egal Zero _ = False
egal (Succ a) (Succ b) = egal a b

-- cum implementam == ?

instance Eq Nat where
  x == y = egal x y

instance Ord Nat where
  Zero <= _ = True
  _ <= Zero = False
  (Succ x) <= (Succ y) = x <= y


instance Show a => Show (Expr' a) where
  show (Numar' x) = show x
  show (x :+: y) = show x ++ " + " ++ show y
  show (x :*: y) = "(" ++ show x ++ ") * (" ++ show y ++ ")"


-- facem typeclass u nostru
-- typeclass -> atasam functionalitate la chestii

class Meow a where
  meow :: a -> String


-- :t (+)
-- pentru un a showable definim o expresie de a mewoable
instance Show a => Meow (Expr' a) where
  meow x  = "meow: " ++ (show x)

-- in stanga lu => restrictii, in dreapta definitiile

instance Meow Int where
  meow 1 = "meow"
  meow n = meow (n - 1) ++ " meow"



instance Num Nat where
  Zero + x = x
  (Succ x) + y = Succ (x + y)
  Zero * _ = Zero
  (Succ Zero) * x = x 
  (Succ y) * x = (y * x) + x

  abs x = x

  signum Zero = Zero
  signum _ = (Succ Zero)

  x - Zero = x
  Zero - x = error "scadem prea mult"
  (Succ x) - (Succ y) = x - y

  fromInteger 0 = Zero
  fromInteger x = if x < 0 then error "nu merge cu negative"
                           else Succ (fromInteger (x - 1))


-- typeclasuri mari -> Eq Ord Show
-- facem noi mai incolo Foldable


f32xy [] = []
f32xy [_] = []
f32xy li = let li2 = [i | (nr, i) <- zip li [1.. length li], 0 <= nr, nr < 10] in 
               [b - a - 1 | (a, b) <- zip li2 (tail li2)]



