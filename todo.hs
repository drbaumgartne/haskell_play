-- todo.hs
-- To-Do list from Learn You a Haskell for Great Good

-- modules

-- imports
import System.IO

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


-- main
main = do
    putStrLn "Add to to-do list:"
    todoItems <- getLine
    appendFile "todo.txt" (todoItems ++ "\n") -- add a new line for spacing

-- help functions
