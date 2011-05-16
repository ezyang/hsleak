import Harness

import Data.IORef
import Control.Exception
import Control.DeepSeq

main = initialize $ do
    let x = [1..5000000] :: [Int]
    busy
    evaluate (rnf x)
    ref <- newIORef x
    busy
    writeIORef ref []
    busy
