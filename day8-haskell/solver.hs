{-# LANGUAGE OverloadedStrings #-}
import System.IO
import Data.Text (pack, unpack, splitOn, length, Text, concat)
import Data.List

main = do
    -- ["cagedb", "ab", "gcdfa", "fbcad", "eafb", "cdfbe", "cdfgeb", "dab", "acedgfb", "abcdfg"]
    let seg7 = ["abcdeg","ab","acdfg","abcdf","abef","bcdef","bcdefg","abd","abcdefg","abcdfg"]

    let inputs = []

    inpStr <- readFile "input.txt"

    let inp = splitOn "\n" (pack inpStr)
    let inputs = map (splitOn " | ") inp

    let checkWordP1 word = Data.Text.length word `elem` [2,3,4,7]

    let countNums line = Prelude.length (Prelude.filter checkWordP1 (splitOn " " line))

    let countNumsP1 = sum (map (\x -> countNums (x!!1)) inputs)
    print countNumsP1

