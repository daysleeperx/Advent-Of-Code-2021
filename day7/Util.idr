{--
AoC Utils Module
TODO: move to separate package
--}

module Util
import Data.Vect

public export
fromIntegerNat : Integer -> Nat
fromIntegerNat 0 = Z
fromIntegerNat n =
  if (n > 0) then
    S (fromIntegerNat (assert_smaller n (n - 1)))
  else
    Z

public export
consolidate:  List (Maybe a) -> Maybe (List a)
consolidate []  =  Just []
consolidate (Nothing :: mxs)  =  Nothing
consolidate ((Just x) :: mxs)  =
        case consolidate mxs  of
        		Nothing  =>  Nothing
        		Just xs  =>  Just (x :: xs)
