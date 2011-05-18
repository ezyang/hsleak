import Harness

import Data.IORef

main = initialize $ do
    let x = [1..5000000] :: [Int]
    busy
    evaluate (length x)
    ref <- newIORef x
    busy
    writeIORef ref []
    busy

-- Fixes:
--  * Don't put big structures in a reference
--  * Zero references as soon as possible
--  * Let the reference drop out of scope earlier
-- Perturbations:
--  * Global reference with unsafePerformIO
--      Amazingly, letting the reference drop out of scope still
--      works, due to CAF garbage collection
