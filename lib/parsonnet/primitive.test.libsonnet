local primitive = import 'primitive.libsonnet';
local state = import 'state.libsonnet';

local expect(a, b) = if a == b then true else error 'Expect equal to:\n%s\n%s' % [a, b];
local expectNot(a, b) = if a != b then true else error 'Expect not equal to:\n%s\n%s' % [a, b];

local failTests = {
  local err = 'ERR',
  local init = state.newState('123', 0),

  failAlways: expect(primitive.fail(err)(init), init.result.failure(err)),
  noConsumption: expect(primitive.fail(err)(init).state().input.pos, init.input.pos),
};

local returnTests = {
  local out = 'OUT',
  local init = state.newState('123', 0),
  local term = state.newState('123', 0).consume(null),

  succeedAlways: expect(primitive.return(out)(init), init.result.success(out)),
  noConsumption: expect(primitive.return(out)(init).state().input.pos, init.input.pos),
};

local tokenTests = {
  local hasPos(src, pos) = pos != null && pos >= 0 && pos < std.length(src),
  local nextPos(src, pos, token) = if pos != null && hasPos(src, pos + 1) then pos + 1,
  local getToken(src, pos) = if hasPos(src, pos) then src[pos],
  local testTokenFunctor(char) = function(token) token == char,
  local tokenParser(char) = primitive.token(nextPos, getToken, testTokenFunctor(char)),

  local out = 'OUT',
  local init = state.newState('123', 0),
  local term = state.newState('123', 0).consume(null),
  local empty = state.newState('', 0),

  outputIfMatched: expect(tokenParser('1')(init).out, '1'),
  noOutputIfNotMatched: expect(tokenParser('2')(init).out, null),
  noOutputAtTerm: expect(tokenParser('1')(term).out, null),
  noOutputIfEmpty: expect(tokenParser('1')(empty).out, null),

  noErrorIfMatched: expect(tokenParser('1')(init).err, null),
  errorIfNotMatched: expectNot(tokenParser('2')(init).err, null),
  errorAtTerm: expectNot(tokenParser('1')(term).err, null),
  errorIfEmpty: expectNot(tokenParser('1')(empty).err, null),

  consumptionIfMathced: expectNot(tokenParser('1')(init).state().input.pos, init.input.pos),
  consumptionIfNotMathced: expectNot(tokenParser('2')(init).state().input.pos, init.input.pos),
  noConsumptionAtTerm: expect(tokenParser('')(term).state().input.pos, term.input.pos),
  consumptionIfEmpty: expectNot(tokenParser('1')(empty).state().input.pos, init.input.pos),
};

{
  failTests: failTests,
  returnTests: returnTests,
  tokenTests: tokenTests,
}
