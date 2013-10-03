-- imports
import System.IO
import System.Directory
import System.Environment
import Data.List

main = do
    (command:args) <- getArgs
    commandControl command (head args)

-- commandControl
-- handles the commands
commandControl :: String -> String -> IO ()
commandControl "add" = add
--commandControl "del" str = del str
--commandControl "view" str = view str

-- dumbed down for now
add = putStrLn
