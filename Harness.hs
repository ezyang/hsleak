module Harness (initialize, busy) where

import Data.Time
import System.IO
import System.Mem
import Control.Exception

initialize m = hSetBuffering stdout NoBuffering >> m
busy = do
    putStr "busy... "
    (n, w) <- timed $ do
        n <- calculateWaitTime
        -- A magical number that seems to give the
        -- right perceived delay
        evaluate (sum [1 .. floor (400 / n)])
        performGC
        return n
    putStrLn ("gc = " ++ show n ++ ", wait = " ++ show w)
calculateWaitTime = do
    performGC -- avoid inaccuracies due to lots of garbage
    (_, r) <- timed performGC
    return r
timed m = do
    t  <- getCurrentTime
    r  <- m
    t' <- getCurrentTime
    return (r, diffUTCTime t' t)
