local parserCombinator = import 'parserCombinator-combinator.libsonnet';

local factory = {
  oneOf(chars)::
    function(s)
      if s.hasToken() then
        if std.setMember(s.getToken(), std.stringChars(chars)) then
          s.success(s.getToken()).consume()
        else
          s.consume()
      else
        s.consume(),

  anyDigit:: self.oneOf('1234567890'),
};

local input = {
  local initPos(src) = 0,
  local hasPos(src, pos) = pos != null && pos >= 0 && pos < std.length(src),
  local nextPos(src, pos) = if hasPos(src, pos + 1) then pos + 1 else null,
  local getToken(src, pos) = if hasPos(src, pos) then src[pos] else null,
  new(src):: parserCombinator.input.new(src, initPos, nextPos, getToken),
};

local f = calc.factory;
local i = calc.input;

local s = calc.state;
local success(ret, pos) = { ret: ret, pos: pos };
local failure(pos) = { ret: [], pos: pos };

local calcTests = {
  anyDigit: {
    pass2: std.assertEqual(f.anyDigit(s.new('1', 0)), success(['1'], null)),
    pass3: std.assertEqual(f.anyDigit(s.new('123', 0)), success(['1'], 1)),
    pass4: std.assertEqual(f.anyDigit(s.new('123', 1)), success(['2'], 2)),
    pass5: std.assertEqual(f.anyDigit(s.new('123', 2)), success(['3'], null)),
    fail1: std.assertEqual(f.anyDigit(s.new('', 0)), failure(null)),
    fail2: std.assertEqual(f.anyDigit(s.new('1', 1)), failure(null)),
    fail3: std.assertEqual(f.anyDigit(s.new('123', 4)), failure(null)),
  },
  digit: {
    pass1: std.assertEqual(f.digit(1)(s.new('1')), success(['1'], null)),
    fail1: std.assertEqual(f.digit(1)(s.new('2')), failure(null)),
  },
};

local c = parserCombinator;

local primitiveTests = {
  bind: {
    pass1: std.assertEqual(
      c.bind(f.anyDigit, function(lstate) lstate)(s.new('1', 0)),
      success('1', null)
    ),
    pass2: std.assertEqual(
      c.bind(f.anyDigit, function(lstate) lstate.merge(lstate))(s.new('1', 0)),
      success('11', null)
    ),
  },
  map: {
    pass1: std.assertEqual(
      c.map(function(lstate) lstate, f.anyDigit)(s.new('1', 0)),
      success('1', null)
    ),
    pass2: std.assertEqual(
      c.map(function(lstate) lstate.merge(lstate), f.anyDigit)(s.new('1', 0)),
      success('11', null)
    ),
  },
  return: {
    pass1: std.assertEqual(c.return('PASS')(s.new('', 0)), success('PASS', 0)),
    pass2: std.assertEqual(c.return('PASS')(s.new('1', 0)), success('PASS', 0)),
    pass4: std.assertEqual(c.return('PASS')(s.new('123', 10)), success('PASS', 10)),
  },
  zero: {
    fail1: std.assertEqual(c.zero(s.new('', 0)), failure(0)),
    fail2: std.assertEqual(c.zero(s.new('1', 0)), failure(0)),
    fail3: std.assertEqual(c.zero(s.new('123', 10)), failure(10)),
  },
};

local combinatorTests = {
  and: {
    pass1: std.assertEqual(c.and(f.digit(1), f.digit(2))(s.new('12345', 0)), success('12', 2)),
    fail1: std.assertEqual(c.and(f.digit(1), f.digit(2))(s.new('1', 0)), success(null, null)),
    fail2: std.assertEqual(c.and(f.digit(1), f.digit(2))(s.new('67890', 0)), success(null, 2)),
  },
  many: {
    pass1: std.assertEqual(c.many(f.digit(1))(s.new('', 0)), success('', null)),
    pass2: std.assertEqual(c.many(f.digit(1))(s.new('12345', 0)), success('1', 1)),
    pass3: std.assertEqual(c.many(f.digit(1))(s.new('11111', 0)), success('11111', null)),
  },
};

local c = null;
local s = null;
local success = null;
local failure = null;

local oldTests = {
  and: {
    succ1: std.assertEqual(c.and([s.char('A'), s.char('B')])('ABC', 0), success('AB', 2)),
    succ2: std.assertEqual(c.and([s.char('A'), s.char('B'), s.char('C')])('ABC', 0), success('ABC', null)),
    fail1: std.assertEqual(c.and([s.char('A'), s.char('B')])('A', 0), failure()),
    fail2: std.assertEqual(c.and([s.char('A'), s.char('B')])('BC', 0), failure()),
    fail3: std.assertEqual(c.and([s.char('A'), s.char('B'), s.char('C')])('AB', 0), failure()),
  },
  left: {
    succ1: std.assertEqual(c.left(s.char('A'), s.char('B'))('ABC', 0), success('A', 2)),
    fail1: std.assertEqual(c.left(s.char('A'), s.char('B'))('A', 0), failure()),
    fail2: std.assertEqual(c.left(s.char('A'), s.char('B'))('BC', 0), failure()),
  },
  many: {
    succ1: std.assertEqual(c.many(s.char('A'))('', 0), success('', 0)),
    succ2: std.assertEqual(c.many(s.char('A'))('A', 0), success('A', null)),
    succ3: std.assertEqual(c.many(s.char('A'))('AAA', 0), success('AAA', null)),
    succ4: std.assertEqual(c.many(s.char('A'))('ABC', 0), success('A', 1)),
    succ5: std.assertEqual(c.many(s.char('A'))('XYZ', 0), success('', 0)),
  },
  or: {
    succ1: std.assertEqual(c.or([s.char('A'), s.char('B')])('AB', 0), success('A', 1)),
    succ2: std.assertEqual(c.or([s.char('A'), s.char('B')])('BA', 0), success('B', 1)),
    succ3: std.assertEqual(c.or([s.char('A'), s.char('B'), s.char('C')])('CB', 0), success('C', 1)),
    fail1: std.assertEqual(c.or([s.char('A'), s.char('B')])('CD', 0), failure()),
    fail2: std.assertEqual(c.or([s.char('A'), s.char('B'), s.char('C')])('DE', 0), failure()),
  },
  repeat: {
    succ1: std.assertEqual(c.repeat(s.anyChar, 1)('AAA', 0), success('A', 1)),
    succ2: std.assertEqual(c.repeat(s.anyChar, 2)('AAA', 0), success('AA', 2)),
    succ3: std.assertEqual(c.repeat(s.anyChar, 3)('AAA', 0), success('AAA', null)),
    succ5: std.assertEqual(c.repeat(s.anyChar, 2, 4)('AA', 0), success('AA', null)),
    succ6: std.assertEqual(c.repeat(s.anyChar, 2, 4)('AAA', 0), success('AAA', null)),
    succ7: std.assertEqual(c.repeat(s.anyChar, 2, 4)('AAAA', 0), success('AAAA', null)),
    succ8: std.assertEqual(c.repeat(s.anyChar, 2, 4)('AAAAA', 0), success('AAAA', 4)),
    fail1: std.assertEqual(c.repeat(s.anyChar, 4)('AAA', 0), failure()),
    fail2: std.assertEqual(c.repeat(s.anyChar, 5)('AAA', 0), failure()),
    fail3: std.assertEqual(c.repeat(s.anyChar, 2, 4)('A', 0), failure()),
  },
  right: {
    succ1: std.assertEqual(c.right(s.char('A'), s.char('B'))('ABC', 0), success('B', 2)),
    fail1: std.assertEqual(c.right(s.char('A'), s.char('B'))('A', 0), failure()),
    fail2: std.assertEqual(c.right(s.char('A'), s.char('B'))('BC', 0), failure()),
  },
};

calcTests  //+
//primitiveTests +
//combinatorTests



