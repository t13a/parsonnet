local char = import 'char.libsonnet';
local primitive = import 'primitive.libsonnet';

local s(src) = char.input.new(src).initState();

local testItem = {
  test1: std.assertEqual(std.length(primitive.item(s('')).results), 0),
  test2: {
    local p = primitive.item(s('a')),
    value: std.assertEqual(p.results[0].value, 'a'),
    statePos: std.assertEqual(p.results[0].state.pos, null),
  },
  test3: {
    local p = primitive.item(s('ab')),
    value: std.assertEqual(p.results[0].value, 'a'),
    statePos: std.assertEqual(p.results[0].state.pos, 1),
  },
};

{
  testItem: testItem,
}
