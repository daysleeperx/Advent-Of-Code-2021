--- Day 2: Dive! ---

module Dive
import Data.String.Parser           


data Command = Forward Integer | Down Integer | Up Integer

implementation Show Command where
        show (Forward f) = "Forward " ++ show f
        show (Down d) = "Down " ++ show d
        show (Up u) = "Up " ++ show u

parseCommand : Parser Command
parseCommand = string "forward" *> space $> Forward <*> integer
           <|> string "down" *> space $> Down <*> integer
           <|> string "up" *> space $> Up <*> integer

parseCommands : Parser (List Command)
parseCommands = many parseCommand <* eos

main : IO ()
main = do
        let (Right cmds)  = parse parseCommands "down -14forward 9up 0" | (Left error) => printLn error
        printLn cmds
