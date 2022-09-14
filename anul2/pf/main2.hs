module Stef where

import Data.Char

-- 1 -- letter from first hal

f :: Char -> Bool
f c 
  | notLetter c = error "nu e litera"
  | ord (lower (c)) <= ord ('m') = True
  | otherwise = False
  where 
    notLetter c
      | ord (c) > ord ('z') = True
      | ord (c) > ord ('Z') && ord (c) < ord ('a') = True
      | ord (c) < ord ('A') = True
      | otherwise = False
    lower x = if ord (x) < ord ('a') then chr (ord (x) + 32) else x


-- 2 -- 

g :: String -> Bool
g s
  | bune > rele = True
  | otherwise = False
  where 
    bune = sum [1 | x <- s, f x]
    rele = sum [1 | x <- s, not (f x)]


-- 3 -- 
g'' [] x y = x < y
g'' (h:t) x y = if f h then g'' t (x + 1) y else g'' t x (y + 1)
g' li = g'' li 0 0


-- 4 --

c :: [Int] -> [Int]
c li = [x | (x, y) <- zip (li) (tail li), x == y]

-- 5 --

d :: [Int] -> [Int]
d [] = []
d [_] = []
d (h1:h2:t) = if h1 == h2 then h1:(d (h2:t)) else d(h2:t)

-- 6 --

-- prop_cd c d li

