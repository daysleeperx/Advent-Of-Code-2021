--- Day 17: Trick Shot ---
           

module TrickShot
import System
import System.File
import Data.List
import Data.List1
import Data.Colist
import Data.Colist1
import Data.String.Parser


-- %default total

Point : Type
Point = (Integer, Integer)

BoundingBox : Type
BoundingBox = List1 Point

boundingBox : (xRange : Point) -> (yRange: Point) -> Maybe BoundingBox
boundingBox (x1, x2) (y1, y2) = fromList [(x, y) | x <- [x1..x2], y <- [y2..y1]]

inBounds : (point : Point) -> (box : BoundingBox) -> Bool
inBounds point = elem point . forget

outOfRange : (point : Point) -> (box : BoundingBox) -> Bool
outOfRange (x, y) box with (last box)
        _ | (x2, y2) = x > x2 || y < y2

sign : Integer -> Integer
sign x = if x > 0 then 1 else if x < 0 then -1 else 0

step : (start : Point) -> (deltas : Point) -> Colist Point
step (x, y) (dx, dy) = (x, y) :: step (x + dx, y + dy) (dx + negate (sign dx), dy - 1)

simulate : (deltas : Point) -> (box : BoundingBox) -> List Point
simulate deltas box = go $ step (0, 0) deltas
                            where
                                go : Colist Point -> List Point
                                go [] = []
                                go (pos :: path) = case (inBounds pos box) || (outOfRange pos box) of
                                                        False => (pos :: go path)
                                                        True => [pos]

getAllPaths : (box: BoundingBox) -> (vels: List Point) -> List (List Point)                                                        
getAllPaths box vels = foldl checkPath [] vels
                        where
                            checkPath : (acc : List (List Point)) -> (vel : Point) -> List (List Point)    
                            checkPath acc vel = let 
                                                    path = simulate vel box
                                                    (Just goal) = last' path | Nothing => acc
                                                in
                                                    if inBounds goal box then (path :: acc) else acc

main : IO ()
main = do
        args <- getArgs
        let (file :: _) = drop 1 args | [] => printLn "No file provided!"
        (Right symbols) <- readFile file | (Left error) => printLn error
        let (Just box) = boundingBox (143, 177) (-106, -71) | Nothing => printLn "Invalid ranges!"
        let paths = getAllPaths box [(x, y) | x <- [(cast . floor . sqrt) (2 * 143)..177], y <- [-106..105]]
        printLn $ length paths
