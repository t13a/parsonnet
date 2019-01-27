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
  testSeq: testSeq,
}
