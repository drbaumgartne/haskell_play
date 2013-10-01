-- todo.hs
-- To-Do list from Learn You a Haskell for Great Good

-- modules

-- imports
import System.IO
import System.Directory

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
--

-- main
main = do
    putStrLn "Add or Delete (A/D):"
    response <- getLine
    if qAddDelete response
        then do putStrLn "Add to to-do list:"
                todoItems <- getLine
                appendFile "todo.txt" (todoItems ++ "\n") -- new line for spacing
        -- read file, ask about task to delete, remove it, create a temp file, delete orig, rename temp
        else do contents <- readFile "todo.txt"
                putStrLn "Which task has been completed:"
                mapM_ putStrLn $ enumList contents
                deletion <- getLine
                let number = read deletion
                    newtodoItems = unlines $ removeItem (number - 1) (lines contents)
                (tempFile, tempHandle) <- openTempFile "." "temp"
                hPutStr tempHandle newtodoItems
                hClose tempHandle
                removeFile "todo.txt"
                renameFile tempFile "todo.txt"


-- helper functions

-- qAddDelete :: Bool check for response
qAddDelete :: String -> Bool
qAddDelete c
    | c == "A"  = True
    -- todo: c == "D" = False
    -- todo: otherwise = error handling somehow
    | otherwise = False

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
