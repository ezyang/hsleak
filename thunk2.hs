{-# LANGUAGE BangPatterns #-}
import Harness

-- The details are not important, just that:
--  1. It's spine strict, but
--  2. It's lazy in its values.
data SpineStrictList a = Nil | Cons a !(SpineStrictList a)
ssFromList [] l = l
ssFromList (x:xs) l = ssFromList xs (Cons x l)
-- Can stack overflow: more usual spine strict structures will
-- attempt to make sure their spine grows slowly.
ssMap _ Nil = Nil
ssMap f (Cons x xs) = Cons (f x) (ssMap f xs)

main = initialize $ do
    let x = ssFromList (zip [1..100] (repeat 1)) Nil
    evaluate (loop 80000 x)

loop 0 x = x
loop n x = loop (n-1) (ssMap permute x)

permute (y, z) = (y * 2 + 4 * z, z + 1)

-- Fixes:
--  * Publish a strict version of ssMap
--  * Make the structure spine lazy (e.g. use a traditional list)
--  * rnf the structure every iteration (not recommended!)
-- Not fixes:
--  * Bang pattern permute
-- Perturbations:
--  * Write ssMap in the same style as ssFromList, to avoid stack
--    overflows.  Then you cannot simply make the structure lazy,
--    since the implicit reverse automatically makes the structure spine
--    strict.
-- Note: This example involves 100 moderately long thunk chains
