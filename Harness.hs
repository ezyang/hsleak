module Harness (
    initialize,
    busy,
    module Control.Exception,
) where

import Data.Time
import System.IO
import System.Mem
import Control.Exception

initialize m = hSetBuffering stdout NoBuffering >> m
busy = do
    putStr "busy... "
    -- I don't actually understand why this seems to produce a
    -- consistent time, but it seems to work OK.  Maybe an alternate
    -- approach might be to split up the work into small quanta and keep
    -- doing it until the desired time is met.
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
