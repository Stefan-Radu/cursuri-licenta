module Stef where

import Data.List

data Point = P Integer Integer deriving Show
data Geom = Geom [ Point ] deriving Show

-- 1

vPozitive (Geom puncte) = Geom [P a b | P a b <- puncte, a > 0, b > 0]

vNegative puncte = length [P a b | P a b <- puncte, a <= 0 || b <= 0]

-- 2
figPozitive lista = [Geom g | Geom g <- lista, vNegative g == 0]


-- 3


sumaDist (Geom list1) (Geom list2) 
  | length list1 /= length list2 = error "*** Exception: numar de varfuri diferit!"
  | otherwise = foldr (\(p1, p2) accum -> (dist p1 p2) + accum) 0 (zip list1 list2)
  where 
    dist (P x1 y1) (P x2 y2) = sqrt (fromIntegral ((x1 - x2) ^ 2 + (y1 - y2) ^ 2))
