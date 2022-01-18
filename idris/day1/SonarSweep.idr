--- Day 1: Sonar Sweep ---

module SonarSweep
import System
import System.File
import Data.List
import Data.String

countIncreased : (nums : List Integer) -> List Integer
countIncreased nums = zipWith (\a, b => if b > a then 1 else 0) nums $ drop 1 nums

countIncreased3 : (nums: List Integer) -> List Integer
countIncreased3 nums = countIncreased $ sum <$> transpose [drop 2 nums, drop 1 nums, nums]

main : IO ()
main = do
      args <- getArgs
      let (file :: _) = drop 1 args | [] => printLn "No file provided!"
      (Right symbols) <- readFile file | (Left error) => printLn error
      let nums = catMaybes $ parsePositive <$> lines symbols
      (printLn . sum) $ countIncreased nums
      (printLn . sum) $ countIncreased3 nums
