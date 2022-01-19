--- Day 2: Dive! ---

module Dive
import System
import System.File
import Data.List
import Data.String
import Data.Either
import Data.String.Parser           


data Command = Forward Integer | Down Integer | Up Integer

implementation Show Command where
        show (Forward dx) = "Forward " ++ show dx
        show (Down dy) = "Down " ++ show dy
        show (Up dy) = "Up " ++ show dy

parseCommand : Parser Command
parseCommand = string "forward" *> space $> Forward <*> integer
           <|> string "down" *> space $> Down <*> integer
           <|> string "up" *> space $> Up <*> integer

parseCommands : Parser (List Command)
parseCommands = sepBy parseCommand $ char '\n'

move : (pos : (Integer, Integer)) -> Command-> (Integer, Integer)
move (x, y) cmd = case cmd of
                  (Forward dx) => (x + dx, y)
                  (Down dy) => (x, y + dy)
                  (Up dy) => (x, y - dy)

move2 : (pos : (Integer, Integer, Integer)) -> Command -> (Integer, Integer, Integer)
move2 (x, y, aim) cmd = case cmd of
                     (Forward dx) => (x + dx, y + aim * dx, aim) 
                     (Down dy) => (x, y, aim + dy)
                     (Up dy) => (x, y, aim - dy)

eval : (cmds : List Command) -> Integer
eval = uncurry (*) . foldl move (0, 0) 

eval2 : (cmds : List Command) -> Integer
eval2 cmds = let (x, y, _) = foldl move2 (0, 0, 0) cmds in x * y

main : IO ()
main = do
        args <- getArgs
        let (file :: _) = drop 1 args | [] => printLn "No file provided!"
        (Right symbols) <- readFile file | (Left error) => printLn error
        let (Right cmds) = parse parseCommands symbols | (Left error) => printLn error
        (printLn . eval . fst) cmds
        (printLn . eval2 . fst) cmds

