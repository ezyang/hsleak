import Harness

import Data.IORef
import Control.Exception
import Control.DeepSeq
import System.IO.Unsafe

main = initialize $ do
    let x = [1..5000000] :: [Int]
    busy
    evaluate (rnf x)
    ref <- newIORef x
    busy
    writeIORef ref [0]
    busy
