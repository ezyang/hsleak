{-# LANGUAGE BangPatterns #-}
import Harness

main = do
    evaluate (fst (f [1..4000000] (0 :: Int, 1 :: Int)))

f []     c = c
f (x:xs) c = f xs (tick x c)

tick x (c0, c1) | even x    = (c0, c1 + 1)
                | otherwise = (c0 + 1, c1)

-- Fixes:
--  * rnf c `seq` f xs (tick x c)
--  * Bang-pattern c0 and c1 (strictify tick)
--  * Manually tick permute and remove tuple (or use
--    an unboxed return)
-- Not fixes:
--  * Only bang pattern c in f
--  * Make tuple irrefutable
--      That makes more THUNK_2_0 (tuple thunks)!
-- Perturbations:
--  * Replace tuple with a flat data type
--      With optimizations, GHC can manage strictness analysis fine;
--      for example, calculating length of a list without any strictness
--      annotations works fine if you have -O.  And of course, using a
--      strict tuple does the same as bang-patterning c0 and c1.
--  * Compile with -O0
--      Stack overfows, and bang-patterns c0 and c1 doesn't work
--      (need bang pattern on c as well)
--  * A single-value container type (data I a = I a) or reference type
--    (IOVar, MVar) also suffers from these leaks.
-- Note: This example involves only a few very long thunk chains
