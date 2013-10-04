-- todo.hs
-- To-Do list from Learn You a Haskell for Great Good

-- modules

-- imports
import System.IO
import System.Directory
import System.Environment
import Text.Read

-- thought process for building (at least according to LYAHFGG)
-- BASICS -> COMPLEX 
--      Raw add
--      Raw delete
--      Commands
--      Error handling
-- 
-- What my brain thinks I need before attempting each stage
-- RAW ADD:
--      Ask for input
--      Take input
--      Append to file

-- RAW DELETE:
--      Ask for add or delete
--      Display items currently on the list
--      Ask for which deletion
--      Write new file with handles 

-- COMMAND VERSION:
--      take arguments with main
--      1st argument dictates the action
--      f to handle the command
--      put each action in its own function
--      consolidate main

-- main
main = do
    (command:args) <- getArgs   -- remember that getArgs passes [String]
    commandControl command args


-- commandControl
-- handles the commands
commandControl :: String -> [String] -> IO ()
commandControl "add"     = add 
commandControl "delete"  = delete
commandControl "view"    = view
commandControl _         = usage

-- ADD
-- add something to the file (defined previously, now just segmenting the code)
add :: [String] -> IO ()
add []      = putStrLn "Command <add> requires an additional argument."
add (str:_) = appendFile "todo.txt" (str ++ "\n")

-- DELETE
-- remove something from the list
delete :: [String] -> IO ()
delete []      = delErr
delete (str:_) =
    if isValidNumber str
        then do oldTodoList <- readFile "todo.txt"
                let number = read str
                    newTodoList = unlines $ removeItem (number - 1) (lines oldTodoList)
                (tempFile, tempHandle) <- openTempFile "." "temphandle"
                hPutStr tempHandle newTodoList
                hClose tempHandle
                removeFile "todo.txt"
                renameFile tempFile "todo.txt"
         else do delErr

-- VIEW
-- print out the beautified version of the list
view :: [String] -> IO ()
view _ = do
    contents <- readFile "todo.txt"
    mapM_ putStrLn $ enumList contents

-- USAGE
-- anything not add, del, or view, we'll just exit
usage :: [String] -> IO ()
usage _ = do
    putStrLn "Usage: [command>] [\"text\"]."
    putStrLn "Commands: add, delete, view"


-- helper functions

-- delErr :: error message for delete
delErr :: IO ()
delErr =  putStrLn "Command <delete> requires a number."

-- isValidNumber :: is the string a number and >= 1
isValidNumber :: String -> Bool
isValidNumber s = case readMaybe s of
    Just n -> n >= 1
    _      -> False

-- enumList :: convert the read file into lines and add contextual information
enumList :: String -> [String]
enumList contents = zipWith (\n line -> show n ++ " - " ++ line) [1..] (lines contents)

-- removeItem :: removes the n-th item given
removeItem :: Int -> [String] -> [String]
removeItem n xs = let (ys,zs) = splitAt n xs in ys ++ (tail zs)
-- if we had Data.List there is a delete command (which deletes the first occurence of something)
-- removeItem :: delete ((lines contents) !! (number - 1)) (line contents)
-- more hardcore would be
-- removeItem eqx (y:ys) = if eqx == y then ys else y : removeItem eqx ys
-- in the above you would need to provide the item to match (eqx "equitable x item")
