# Parsonnet

A parser combinator implemented by [Jsonnet](https://jsonnet.org/). There is **no production quality**. This is my learning project trying to use Jsonnet as a purely functional programming language.

## How to try

There are several implementations of Jsonnet. This project includes a Dockerfile to create a Docker container that ships with three implementations of [`jsonnet`](https://github.com/google/jsonnet), [`go-jsonnet`](https://github.com/google/go-jsonnet) and [`sjsonnet`](https://github.com/databricks/sjsonnet). As far as I evaluate, `go-jsonnet` has the highest performance.

```sh
$ git clone https://github.com/t13a/parsonnet
$ cd parsonnet
$ docker build parsonnet-test-runner test/runner
$ docker run --rm -ti -e JSONNET_CMD=go-jsonnet -v $(pwd):/parsonnet parsonnet-test-runner
```

The following is an example of parsing CSV with an example CSV parser. The CSV parser library itself (`examples/csvparser/csv.libsonnet`) is written in less than 50 lines, and it is almost clearly expressed except for the `bind` function.

```sh
$ jsonnet \
-J src \
--ext-str-file src=examples/csvparser/test.csv \
examples/csvparser/csvparser.jsonnet
{
   "results": [
      {
         "state": {
            "pos": null
         },
         "value": [
            [
               "Product",
               "Price"
            ],
            [
               "O'Reilly Socks",
               "10"
            ],
            [
               "Shirt with \"Haskell\" text",
               "20"
            ],
            [
               "Shirt, \"O'Reilly\" version",
               "20"
            ],
            [
               "Haskell Caps",
               "15"
            ]
         ]
      }
   ]
}
```

In my environment, it takes about 150 ms. Yes, it can not be said that it is fast. According to the results of the benchmark, although array "comprehension" is very fast, it takes a lot of time to "join" arrays.

## Acknowledgments

First of all I thank [karino2](https://github.com/karino2) who written "[bindで毎回詰まる人の為のパーサーコンビネータの仕組み](https://karino2.livejournal.com/264801.html)" a wonderful article that can be read in my native language. Without their work, I would never have understood the theory of parser combinator.

And I thank Graham Hutton and Erik Meijer who are the authors of the great paper "[Monadic Parser Combinators](http://www.cs.nott.ac.uk/~pszgmh/monparsing.pdf)". I referred to many implementations of parser combinator, but I eventually followed the design shown in this paper.

Also I am grateful to Daan Leijen and Haskell community for developing [Parsec](https://hackage.haskell.org/package/parsec). The implementation of each combinator is ported from Parsec.
