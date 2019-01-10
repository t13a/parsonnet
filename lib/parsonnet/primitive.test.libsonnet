local primitive = import 'primitive.libsonnet';
local state = import 'state.libsonnet';

local expect(a, b) = if a == b then true else error 'Expect equal to:\n%s\n%s' % [a, b];
local expectNot(a, b) = if a != b then true else error 'Expect not equal to:\n%s\n%s' % [a, b];

local failTests = {
  local err = 'ERR',
  local s1 = state.newState('123', 0),

  failAlways: expect(primitive.fail(err)(s1), s1.result.failure(err)),
  noConsumption: expect(primitive.fail(err)(s1).state(), s1),
};

local returnTests = {
  local out = 'OUT',
  local s1 = state.newState('123', 0),

  succeedAlways: expect(primitive.return(out)(s1), s1.result.success(out)),
  noConsumption: expect(primitive.return(out)(s1).state(), s1),
};

local tokenTests = {
  local hasPos(src, pos) = pos != null && pos >= 0 && pos < std.length(src),
  local nextPos(src, pos, token) = if hasPos(src, pos + 1) then pos + 1,
  local getToken(src, pos) = if hasPos(src, pos) then src[pos],
  local testTokenFunctor(char) = function(token) token == char,
  local tokenParser(char) = primitive.token(nextPos, getToken, testTokenFunctor(char)),

  local out = 'OUT',
  local s1 = state.newState('123', 0),

  outputIfMatched: expect(tokenParser('1')(s1).out, '1'),
  noOutputIfNotMatched: expect(tokenParser('2')(s1).out, null),

  noErrorIfMatched: expect(tokenParser('1')(s1).err, null),
  errorIfNotMatched: expectNot(tokenParser('2')(s1).err, null),

  consumeIfMathced: expectNot(tokenParser('1')(s1).state().input.pos, s1.input.pos),
  consumeIfNotMathced: expectNot(tokenParser('2')(s1).state().input.pos, s1.input.pos),
};

{
  failTests: failTests,
  returnTests: returnTests,
  tokenTests: tokenTests,
}
