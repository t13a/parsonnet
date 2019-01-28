local char = import 'char.libsonnet';
local util = import 'util.libsonnet';

local s(src) = char.input.new(src).initState();

local testAnyChar = {
  test1:
    local p = char.anyChar(s('a'));
    std.assertEqual(p.results[0].value, 'a'),
};

local testChar = {
  test1:
    local p = char.char('a')(s('a'));
    std.assertEqual(p.results[0].value, 'a'),
  test2:
    local p = char.char('b')(s('a'));
    std.assertEqual(util.isFailure(p), true),
};

local testNoneOf = {
  test1:
    local p = char.noneOf('abc')(s('b'));
    std.assertEqual(util.isFailure(p), true),
  test2:
    local p = char.noneOf('abc')(s('e'));
    std.assertEqual(p.results[0].value, 'e'),
};

local testString = {
  test1:
    local p = char.string('abc')(s('abc'));
    std.assertEqual(p.results[0].value, 'abc'),
  test2:
    local p = char.string('abc')(s('def'));
    std.assertEqual(util.isFailure(p), true),
};

{
  testAnyChar: testAnyChar,
  testChar: testChar,
  testNoneOf: testNoneOf,
  testString: testString,
}
