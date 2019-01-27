local char = import 'char.libsonnet';
local combinator = import 'combinator.libsonnet';
local primitive = import 'primitive.libsonnet';
local util = import 'util.libsonnet';

local s(src) = char.input.new(src).initState();

local testBind = {
  test1: {
    local p = combinator.bind(char.anyChar, function(a) primitive.result(a.value))(s('abc')),
    value: std.assertEqual(p.results[0].value, 'a'),
    statePos: std.assertEqual(p.results[0].state.pos, 1),
  },
  test2: {
    local p = combinator.bind(
      char.anyChar,
      function(a)
        combinator.bind(
          char.anyChar,
          function(b)
            combinator.bind(
              char.anyChar,
              function(c)
                primitive.result(a.value + b.value + c.value)
            )
        )
    )(s('abc')),
    value: std.assertEqual(p.results[0].value, 'abc'),
    statePos: std.assertEqual(p.results[0].state.pos, null),
  },
};

local testMany = {
  test1: {
    local p = combinator.many(char.char('a'))(s('')),
    value: std.assertEqual(p.results[0].value, []),
    statePos: std.assertEqual(p.results[0].state.pos, 0),
  },
  test2: {
    local p = combinator.many(char.char('a'))(s('aaabbb')),
    value: std.assertEqual(p.results[0].value, ['a', 'a', 'a']),
    statePos: std.assertEqual(p.results[0].state.pos, 3),
  },
};

local testMany1 = {
  test1: {
    local p = combinator.many1(char.char('a'))(s('')),
    failure: std.assertEqual(util.isFailure(p), true),
  },
  test2: {
    local p = combinator.many1(char.char('a'))(s('aaabbb')),
    value: std.assertEqual(p.results[0].value, ['a', 'a', 'a']),
    statePos: std.assertEqual(p.results[0].state.pos, 3),
  },
};

local testOptional = {
  test1: {
    local p = combinator.optional(char.anyChar)(s('')),
    value: std.assertEqual(p.results[0].value, []),
    statePos: std.assertEqual(p.results[0].state.pos, 0),
  },
  test2: {
    local p = combinator.optional(char.anyChar)(s('a')),
    value: std.assertEqual(p.results[0].value, 'a'),
    statePos: std.assertEqual(p.results[0].state.pos, null),
  },
};

local testPlus = {
  test1: {
    local p = combinator.plus(char.char('a'), char.char('b'))(s('a')),
    value: std.assertEqual(p.results[0].value, 'a'),
    statePos: std.assertEqual(p.results[0].state.pos, null),
  },
  test2: {
    local p = combinator.plus(char.char('a'), char.char('b'))(s('b')),
    value: std.assertEqual(p.results[0].value, 'b'),
    statePos: std.assertEqual(p.results[0].state.pos, null),
  },
  test3: {
    local p = combinator.plus(char.char('a'), char.char('b'))(s('c')),
    failure: std.assertEqual(util.isFailure(p), true),
  },
};

local testSepBy = {
  test1: {
    local p = combinator.sepBy(
      combinator.many1(char.noneOf(',')),
      char.char(',')
    )(s('')),
    value: std.assertEqual(p.results[0].value, []),
    statePos: std.assertEqual(p.results[0].state.pos, 0),
  },
  test2: {
    local p = combinator.sepBy(
      combinator.many1(char.noneOf(',')),
      char.char(',')
    )(s('abc')),
    value: std.assertEqual(p.results[0].value, [['a', 'b', 'c']]),
    statePos: std.assertEqual(p.results[0].state.pos, null),
  },
};

local testSepBy1 = {
  test1: {
    local p = combinator.sepBy1(
      combinator.many1(char.noneOf(',')),
      char.char(',')
    )(s('')),
    failure: std.assertEqual(util.isFailure(p), true),
  },
  test2: {
    local p = combinator.sepBy1(
      combinator.many1(char.noneOf(',')),
      char.char(',')
    )(s('abc')),
    value: std.assertEqual(p.results[0].value, [['a', 'b', 'c']]),
    statePos: std.assertEqual(p.results[0].state.pos, null),
  },
  test3: {
    local p = combinator.sepBy1(
      combinator.many1(char.noneOf(',')),
      char.char(',')
    )(s('abc,def')),
    value: std.assertEqual(p.results[0].value, [['a', 'b', 'c'], ['d', 'e', 'f']]),
    statePos: std.assertEqual(p.results[0].state.pos, null),
  },
  test4: {
    local p = combinator.sepBy1(
      combinator.many1(char.noneOf(',')),
      char.char(',')
    )(s('abc,def,')),
    value: std.assertEqual(p.results[0].value, [['a', 'b', 'c'], ['d', 'e', 'f']]),
    statePos: std.assertEqual(p.results[0].state.pos, 7),
  },
};

local testSeq = {
  test1: {
    local p = combinator.seq(char.anyChar, char.anyChar)(s('a')),
    results: std.assertEqual(std.length(p.results), 0),
  },
  test2: {
    local p = combinator.seq(char.anyChar, char.anyChar)(s('abc')),
    value: std.assertEqual(p.results[0].value, ['a', 'b']),
    statePos: std.assertEqual(p.results[0].state.pos, 2),
  },
};

{
  testBind: testBind,
  testMany: testMany,
  testMany1: testMany1,
  testOptional: testOptional,
  testPlus: testPlus,
  testSepBy: testSepBy,
  testSepBy1: testSepBy1,
  testSeq: testSeq,
}
