
double :: Int -> Int
double x = 2 * x

triple :: Int -> Int
triple x = 3 * x

penta :: Int -> Int
penta x = 5 * x

test x = (double x + triple x) == (penta x)

myLookUp :: Int -> [(Int, String)] -> Maybe String
myLookUp x ((key, val):t) = if (x == key) then Just val else myLookUp x t
myLookUp _ [] = Nothing

myLookUp' :: Int -> [(Int, String)] -> Maybe String
myLookUp' x li = 
  let l = [v | (k, v) <- li, k == x] in
      if l == [] then Nothing else Just (head l)

testLookUp :: Int -> [(Int, String)] -> Bool
testLookUp x li = ((lookup x li) == (myLookUp x li)) && 
  ((lookup x li) == (myLookUp' x li))


data ElemIS = I Int | S String deriving(Show, Eq)

-- instance Arbitrary ElemIS where
--   arbitrary = elements [I 5, S "salut", S "Hello world", I 0]
--
-- myLookUpElem :: Int -> [(Int, ElemIS)] -> Maybe ElemIS
-- myLookUpElem = lookup
--
-- testLookUpElem :: Int -> [(Int, ElemIS)] -> Bool
-- testLookUpElem elem lista = (myLookUpElem elem lista) == (lookup elem lista)


-- Functor, Applicative, Monad

-- (a -> b)  -> [] a -> [] b -- asta e um map

data Arbore a = Leaf | Nod (Arbore a) a (Arbore a)

-- generalizarea lui map
instance Functor Arbore where 
  fmap f Leaf = Leaf
  fmap f (Nod left x right) = Nod (fmap f left) (f x) (fmap f right)

-- generalizarea/ implementarea lui foldr
instance Foldable Arbore where
  foldr f accum Leaf = accum
  foldr f accum (Nod left x right) = 
    let dreapta = foldr f accum right in
    let mijloc = f x dreapta in
    foldr f mijloc left


instance Semigroup Int where
  x <> y = x + y

instance Monoid Int where
  mempty = 0
