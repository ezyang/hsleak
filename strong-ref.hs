import Harness

import Data.IORef
import Control.Exception
import Control.DeepSeq
import System.IO.Unsafe

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
