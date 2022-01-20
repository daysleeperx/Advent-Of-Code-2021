--- Day 3: Binary Diagnostic ---

module BinaryDiagnostic
import System
import System.File
import Data.List
import Data.Vect
import Data.String.Parser

data Bit = Low | High

implementation Show Bit where
        show Low = "0"
        show High = "1"

parseBit : Parser Bit
parseBit = char '0' $> Low
       <|> char '1' $> High 

parseBits : Parser (List Bit)
parseBits = many parseBit

InputType : Type
InputType = (n ** List (Vect n Bit))


main : IO ()
main = do
        args <- getArgs
        let (file :: _) = drop 1 args | [] => printLn "No file provided!"
        (Right symbols) <- readFile file | (Left error) => printLn error
        let res = parse parseBits "1001"
        printLn res
