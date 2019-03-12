#!/usr/bin/env stack
{- stack
  script
  --resolver lts-13.12
  --package pandoc-types
-}


{- Author: Pablo Baeyens (@mx-psi)
Usage: pandoc -F ./$0 yourfile.md -o yourfile.pdf
Description: Transforms divs into environments -}

import Text.Pandoc.JSON

main :: IO ()
main = toJSONFilter envtify

raw = (: []) . RawBlock (Format "tex")
command name val = raw $ "\\" ++ name ++ "{" ++ val ++"}"
begin  name opts = raw $ "\\begin{" ++ name ++"}" ++ (maybe "" (\x -> "[" ++ x ++ "]") opts)
end              = command "end"
label ident      = if null ident then [] else command "label" ident


envtify :: Block -> [Block]
envtify (Div (ident, [name], values) contents) =
  begin name opts ++ label ident ++ contents ++ end name
  where opts  = lookup "name" values
envtify b = [b]
