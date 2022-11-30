--- Day 4: Giant Squid ---

{--
A lot of stuff influenced by:
https://github.com/414owen/advent-of-code-2021/blob/master/src/Ad04.hs
https://github.com/pinselimo/AoC2021/blob/main/Fensterl04/Main.idr
--}

module GiantSquid
import System
import System.File
import Data.List
import Data.List1
import Data.Vect
import Data.String.Parser
import Debug.Trace


Square : Type
Square = Maybe Integer

Row : Type
Row = Vect 5 Square

Board : Type
Board = Vect 5 Row

Numbers : Type
Numbers = List1 Integer

InputType : Type
InputType = (Numbers, List1 Board)

parseSquare : Parser Square
parseSquare = Just <$> lexeme integer

parseRow : Parser Row
parseRow = ntimes 5 parseSquare

parseBoard : Parser Board
parseBoard = ntimes 5 parseRow

parseBoards : Parser (List1 Board)
parseBoards = sepBy1 parseBoard spaces

parseNumbers : Parser Numbers
parseNumbers = lexeme $ commaSep1 integer

parseInput : Parser InputType
parseInput = do
        nums <- parseNumbers
        boards <- parseBoards
        pure (nums, boards)

markSquare : Integer -> Square -> Square
markSquare x Nothing = Nothing
markSquare x (Just y) = if x == y then Nothing else Just y

markBoard : Integer -> Board -> Board
markBoard x = map $ map $ markSquare x

markBoards : Integer -> List Board -> List Board
markBoards x = map $ markBoard x

checkMarked : Board -> Bool
checkMarked = any $ all (== Nothing)

checkBingo : Board -> Bool
checkBingo b = checkMarked b || checkMarked (transpose b)

bingoScore : Board -> Integer
bingoScore = sum . catMaybes . toList . Data.Vect.concat

draw : List Integer -> List Board -> List (Integer, Board)
draw [] _ = []
draw (last :: rest) boards = 
        let
                boards' = markBoards last boards
                winners = filter checkBingo boards'
                losers = boards' \\ winners
        in
                map (last,) winners ++ draw rest losers

main : IO ()
main = do
        args <- getArgs
        let (file :: _) = drop 1 args | [] => printLn "No file provided!"
        (Right symbols) <- readFile file | (Left error) => printLn error
        let (Right ((nums, boards), _)) = parse parseInput symbols | (Left error) => printLn error
        let winners = draw (forget nums) (forget boards)
        case winners of
             [] => printLn "No Winners found!"
             ((l, b) :: tail) => 
                       let
                               (l', b') = last ((l, b) ::: tail)
                       in do
                               printLn $ bingoScore b * l
                               printLn $ bingoScore b' * l'

