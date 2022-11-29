--- Day 3: Binary Diagnostic ---

{--
A lot of stuff influenced by:
https://github.com/ryanorendorff/aoc2021/blob/main/src/AOC/Day/Three.idr
https://github.com/jumper149/AoC2021/blob/main/03/src/Main.idr
--}         

module BinaryDiagnostic
import System
import System.File
import Data.List
import Data.List1
import Data.String
import Data.Vect
import Data.Bits
import Data.String.Parser


data Bit = Low | High

Show Bit where
    show Low = "0"
    show High = "1"

Cast Bool Bit where
    cast False = Low
    cast True = High

Cast Bit Integer where
    cast Low = 0
    cast High = 1

parseBit : Parser Bit
parseBit = char '0' $> Low
       <|> char '1' $> High

getLength : List a -> (len ** Vect len a)
getLength [] = (Z ** [])
getLength (x :: xs) with (getLength xs)
        _ | (n ** xs') = ((S n) ** x :: xs')       

parseBits : Parser (n ** Vect n Bit)
parseBits = getLength <$> many parseBit

InputType : Type
InputType = (n ** List1 (Vect n Bit))

exactLengths : (len : Nat) -> Traversable t => t (n ** Vect n a) -> Maybe (t (Vect len a))
exactLengths len xs = traverse (\(_ **  bits) => exactLength len bits) xs

validateBinaryList : List1 (n ** Vect n Bit) -> Maybe InputType
validateBinaryList ((len ** bits) ::: tail) = exactLengths len tail >>= (\list => pure (len ** bits ::: list))

countBit : Bit -> Integer -> Integer
countBit Low x = x - 1
countBit High x = x + 1

mostCommon : Vect n Integer -> Vect n Bit
mostCommon = map $ cast . (> 0)

calculateGamma : {n : Nat} -> List1 (Vect n Bit) -> Vect n Integer
calculateGamma list = foldr (\x, acc => zipWith countBit x acc) (replicate n 0) list

bitsToInteger : Vect n Bit -> Integer
bitsToInteger [] = 0
bitsToInteger (b :: xs) = 2 * bitsToInteger xs + (cast b)

calculatePowerConsumption : InputType -> Integer
calculatePowerConsumption (n ** list) =
    let
        gamma = (bitsToInteger . reverse . mostCommon . calculateGamma) list
        epsilon = gamma `xor` (bitsToInteger $ replicate n High)
    in
        gamma * epsilon

main : IO ()
main = do
        args <- getArgs
        let (file :: _) = drop 1 args | [] => printLn "No file provided!"
        (Right symbols) <- readFile file | (Left error) => printLn error
        let (Right bits) = parse (sepBy1 parseBits $ char '\n') symbols | (Left error) => printLn error
        let (Just input) = (validateBinaryList . fst) bits | Nothing => printLn "Lengths of binary arrays are not equal!"
        (printLn . calculatePowerConsumption) input
