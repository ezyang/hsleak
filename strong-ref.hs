import Data.IORef
import Data.Time
import Control.Concurrent
import Control.Exception
import Control.DeepSeq
import System.IO.Unsafe
import System.IO
import System.Mem

{-# NOINLINE ref #-}
ref = unsafePerformIO (newIORef [0])

main = initialize $ do
    let x = [1..5000000] :: [Int]
    busy
    evaluate (rnf x)
    writeIORef ref x
    busy
    writeIORef ref [0]
    busy

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
