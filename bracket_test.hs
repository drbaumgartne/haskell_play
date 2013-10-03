-- bracket_test.hs
-- testing the bracket command

-- imports
import Control.Exception
import System.IO
import System.Directory

-- main
main = do
    bracket (readFile "todo.txt") (myExit) (\handle -> do putStrLn handle)

-- helpers
myExit _ = putStrLn "Exiting from bracket."
