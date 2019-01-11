local charparser = import 'charparser.libsonnet';

local success = charparser.success;
local failure = charparser.failure;

local ap = charparser.new(success, failure);

local tests = {
  anyChar: {
    empty0: std.assertEqual(ap.anyChar('', 0), failure()),
    empty1: std.assertEqual(ap.anyChar('', 1), failure()),
    one0: std.assertEqual(ap.anyChar('A', 0), success('A', null)),
    one1: std.assertEqual(ap.anyChar('A', 1), failure()),
    more0: std.assertEqual(ap.anyChar('ABC', 0), success('A', 1)),
    more1: std.assertEqual(ap.anyChar('ABC', 1), success('B', 2)),
    more2: std.assertEqual(ap.anyChar('ABC', 2), success('C', null)),
    more3: std.assertEqual(ap.anyChar('ABC', 3), failure()),
  },
  oneOf: {
    succ1: std.assertEqual(ap.oneOf('A')('A', 0), success('A', null)),
    succ2: std.assertEqual(ap.oneOf('A')('AB', 0), success('A', 1)),
    succ3: std.assertEqual(ap.oneOf('B')('AB', 1), success('B', null)),
    succ4: std.assertEqual(ap.oneOf('123')('1', 0), success('1', null)),
    succ5: std.assertEqual(ap.oneOf('123')('3', 0), success('3', null)),
    fail1: std.assertEqual(ap.oneOf('B')('A', 0), failure()),
    fail2: std.assertEqual(ap.oneOf('ABC')('2', 0), failure()),
  },
  codepoint:
    local zero = 48;
    local A = 65;
    local num = [48, 57];
    {
      succ1: std.assertEqual(ap.codepoint(A)('A', 0), success('A', null)),
      succ2: std.assertEqual(ap.codepoint(num[0], num[1])('0', 0), success('0', null)),
      succ3: std.assertEqual(ap.codepoint(num[0], num[1])('9', 0), success('9', null)),
      fail1: std.assertEqual(ap.codepoint(zero)('A', 0), failure()),
      fail2: std.assertEqual(ap.codepoint(num[0], num[1])('A', 0), failure()),
    },
};

local posixTests = {
  digit: {
    succ1: std.assertEqual(ap.digit('0', 0), success('0', null)),
    succ2: std.assertEqual(ap.digit('9', 0), success('9', null)),
    fail1: std.assertEqual(ap.digit('/', 0), failure()),
    fail2: std.assertEqual(ap.digit(':', 0), failure()),
  },
  print: {
    succ1: std.assertEqual(ap.print(' ', 0), success(' ', null)),
    succ2: std.assertEqual(ap.print('~', 0), success('~', null)),
  },
  word: {
    succ1: std.assertEqual(ap.word('A', 0), success('A', null)),
    succ2: std.assertEqual(ap.word('a', 0), success('a', null)),
    succ3: std.assertEqual(ap.word('9', 0), success('9', null)),
    succ4: std.assertEqual(ap.word('_', 0), success('_', null)),
    fail1: std.assertEqual(ap.word('/', 0), failure()),
    fail2: std.assertEqual(ap.word(':', 0), failure()),
  },
};

local unicodeTests = {
  unicode: {
    succ1: std.assertEqual(ap.anyChar('あ', 0), success('あ', null)),
    succ2: std.assertEqual(ap.codepoint(12354)('あ', 0), success('あ', null)),
  },
};

tests + posixTests + unicodeTests
