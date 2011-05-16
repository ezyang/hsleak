module Harness (initialize, busy) where

import Data.Time
import System.IO
import System.Mem
import Control.Exception

initialize m = hSetBuffering stdout NoBuffering >> m
busy = do
    putStr "busy... "
    n <- calculateWaitTime
    -- A magical number that seems to give the
    -- right perceived delay
    evaluate $ sum [1 .. floor (400 / n)]
    putStrLn "done"
calculateWaitTime = do
    performGC -- avoid inaccuracies due to lots of garbage
    t  <- getCurrentTime
    performGC
    t' <- getCurrentTime
    return (diffUTCTime t' t)
