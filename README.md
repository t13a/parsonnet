# Parsonnet

A parser combinator implementation for [Jsonnet](https://jsonnet.org/).

## Introduction

TODO

## Development

### ToDo

- Documentation
- Implement combinators
- Implement builtin parsers
    - Character parser
    - JSON object parser
    - JSONPath parser
    - JSONPath selecter
- Consideration of stack overflow
    - parsing of 100 characters exceeds max stack frame :-(
- Consideration of performance efficiency

## References

- [Monadic Parser Combinators](http://www.cs.nott.ac.uk/~pszgmh/monparsing.pdf)
- [Parsec](https://hackage.haskell.org/package/parsec)
- [bindで毎回詰まる人の為のパーサーコンビネータの仕組み](https://karino2.livejournal.com/264801.html)
