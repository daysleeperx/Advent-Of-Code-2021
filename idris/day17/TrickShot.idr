--- Day 17: Trick Shot ---
           
module TrickShot
import System
import System.File
import Data.List
import Data.List1
import Data.String.Parser


Point : Type
Point = (Integer, Integer)

Path : Type
Path = List1 Point

BoundingBox : Type
BoundingBox = (Point, Point)

parsePoint : Parser Point
parsePoint = (,) <$> (string "x=" *> integer) <*> (string ".." *> integer)
         <|> (,) <$> (string "y=" *> integer) <*> (string ".." *> integer)

parseArea : Parser BoundingBox
parseArea = (,) <$> (string "target area: " *> parsePoint) <*> (string ", " *> parsePoint)

inBounds : (point : Point) -> (box : BoundingBox) -> Bool
inBounds (x, y) ((x1, x2), (y1, y2)) = x >= x1 && x <= x2 && y >= y1 && y <= y2

outOfRange : (point : Point) -> (box : BoundingBox) -> Bool
outOfRange (x, y) ((x1, x2), (y1, y2)) = x > x2 || y < y1

sign : Integer -> Integer
sign x = if x > 0 then 1 else if x < 0 then -1 else 0

step : (start : Point) -> (deltas : Point) -> Stream Point
step (x, y) (dx, dy) = (x, y) :: step (x + dx, y + dy) (dx + negate (sign dx), dy - 1)

simulate : (deltas : Point) -> (box : BoundingBox) -> Path
simulate deltas box = go $ step (0, 0) deltas
                            where
                                go : Stream Point -> Path
                                go (pos :: path) = if (inBounds pos box) || (outOfRange pos box) 
                                                      then singleton pos
                                                      else (pos ::: (forget . go) path)

getAllPaths : (box: BoundingBox) -> (vels: List Point) -> List Path
getAllPaths box vels = foldl checkPath [] vels
                        where
                            checkPath : (acc : List Path) -> (vel : Point) -> List Path
                            checkPath acc vel = let path = simulate vel box in
                                                if inBounds (last path) box then (path :: acc) else acc

main : IO ()
main = do
        args <- getArgs
        let (file :: _) = drop 1 args | [] => printLn "No file provided!"
        (Right symbols) <- readFile file | (Left error) => printLn error
        let (Right (((x1, x2), (y1, y2)), _)) = parse parseArea symbols | (Left error) => printLn error
        let paths = getAllPaths ((x1, x2), (y1, y2))  [
             (x, y)
            | x <- [(cast . floor . sqrt . cast) (2 * x1)..x2]
            , y <- [y1..abs y1 - 1]
        ]           
        printLn $ foldl (\acc, path => max acc $ (foldl1 max . map snd) path) 0 paths
        printLn $ length paths
