import Harness

main = evaluate (f [1..4000000] (0 :: Int))

f []     c = c
f (x:xs) c = f xs (c + 1)

-- Fixes:
--  * Compile with optimizations
--  * Bang pattern 'c' (making f strict)
