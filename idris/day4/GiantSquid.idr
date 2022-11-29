--- Day 4: Giant Squid ---

module GiantSquid
import System
import System.File
import Data.List
import Data.List1
import Data.Vect
import Data.String.Parser


Row : Type
Row = Vect 5 (Maybe Integer)

Board : Type
Board = Vect 5 Row

Numbers : Type
Numbers = List1 Integer

InputType : Type
InputType = (Numbers, List1 Board)

parseRow : Parser Row
parseRow = ntimes 5 $ Just <$> lexeme integer

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

markSquare : Integer -> Maybe Integer -> Maybe Integer
markSquare x Nothing = Nothing
markSquare x (Just y) = if x == y then Nothing else Just y

markBoard : Integer -> Board -> Board
markBoard x = map $ map $ markSquare x

markBoards : Integer -> List1 Board -> List1 Board
markBoards x = map $ markBoard x

checkMarked : Board -> Bool
checkMarked = any $ all (== Nothing)

checkBingo : Board -> Bool
checkBingo b = checkMarked b || checkMarked (transpose b)

bingoScore : Board -> Integer
bingoScore = sum . catMaybes . toList . Data.Vect.concat

main : IO ()
main = do
        args <- getArgs
        let (file :: _) = drop 1 args | [] => printLn "No file provided!"
        (Right symbols) <- readFile file | (Left error) => printLn error
        let (Right res) = parse parseInput symbols | (Left error) => printLn error
        printLn res

