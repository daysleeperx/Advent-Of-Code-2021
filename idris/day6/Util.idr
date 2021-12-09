{--
AoC Utils Module
TODO: move to separate package
--}

module Util
import Data.Vect

public export
zeroes: (n: Nat) -> Vect n Nat
zeroes n = replicate n Z

public export
consolidate:  List (Maybe a) -> Maybe (List a)
consolidate []  =  Just []
consolidate (Nothing :: mxs)  =  Nothing
consolidate ((Just x) :: mxs)  =
        case consolidate mxs  of
        		Nothing  =>  Nothing
        		Just xs  =>  Just (x :: xs)
