--- Day 4: Giant Squid ---

module GiantSquid
import System
import System.File
import Data.List
import Data.List1
import Data.Vect
import Data.String.Parser


Row : Type
Row = Vect 5 Integer

Board : Type
Board = Vect 5 Row

Numbers : Type
Numbers = List1 Integer

InputType : Type
InputType = (Numbers, List1 Board)

parseRow : Parser Row
parseRow = ntimes 5 $ lexeme integer

parseBoard : Parser Board
parseBoard = ntimes 5 $ parseRow

parseBoards : Parser (List1 Board)
parseBoards = sepBy1 parseBoard spaces

parseNumbers : Parser Numbers
parseNumbers = lexeme $ commaSep1 integer

parseInput : Parser InputType
parseInput = do
        nums <- parseNumbers
        boards <- parseBoards
        pure (nums, boards)

main : IO ()
main = do
        args <- getArgs
        let (file :: _) = drop 1 args | [] => printLn "No file provided!"
        (Right symbols) <- readFile file | (Left error) => printLn error
        let (Right res) = parse parseInput symbols | (Left error) => printLn error
        printLn res

