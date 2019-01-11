local primitive = import 'primitive.libsonnet';
local state = import 'state.libsonnet';

local expect(a, b) = if a == b then true else error 'Expect equal to:\n%s\n%s' % [a, b];
local expectNot(a, b) = if a != b then true else error 'Expect not equal to:\n%s\n%s' % [a, b];

local itemTests = {
  local hasPos(input, offsetPos=0) =
    input.pos != null && input.pos + offsetPos >= 0 &&
    input.pos + offsetPos < std.length(input.src),
  local nextPos(input) = if hasPos(input, 1) then input.pos + 1,
  local getToken(input) = if hasPos(input) then input.src[input.pos],
  local testTokenFunctor(char) = function(token) token == char,
  local parser(char) = primitive.item(nextPos, getToken, testTokenFunctor(char)),

  local out = 'OUT',
  local init = state.newState('123', 0),
  local term = state.newState('123', 0).consume(null),
  local empty = state.newState('', 0),

  outputIfMatched: expect(parser('1')(init).out, '1'),
  noOutputIfNotMatched: expect(parser('2')(init).out, null),
  noOutputAtTerm: expect(parser('1')(term).out, null),
  noOutputIfEmpty: expect(parser('1')(empty).out, null),

  noErrorIfMatched: expect(parser('1')(init).err, null),
  errorIfNotMatched: expectNot(parser('2')(init).err, null),
  errorAtTerm: expectNot(parser('1')(term).err, null),
  errorIfEmpty: expectNot(parser('1')(empty).err, null),

  consumptionIfMathced: expectNot(parser('1')(init).state().input.pos, init.input.pos),
  consumptionIfNotMathced: expectNot(parser('2')(init).state().input.pos, init.input.pos),
  noConsumptionAtTerm: expect(parser('')(term).state().input.pos, term.input.pos),
  consumptionIfEmpty: expectNot(parser('1')(empty).state().input.pos, init.input.pos),
};

local resultTests = {
  local out = 'OUT',
  local init = state.newState('123', 0),
  local term = state.newState('123', 0).consume(null),

  succeedAlways: expect(primitive.result(out)(init), init.return.success(out)),
  noConsumption: expect(primitive.result(out)(init).state().input.pos, init.input.pos),
};

local zeroTests = {
  local err = 'ERR',
  local init = state.newState('123', 0),

  failAlways: expect(primitive.zero(err)(init), init.return.failure(err)),
  noConsumption: expect(primitive.zero(err)(init).state().input.pos, init.input.pos),
};

{
  itemTests: itemTests,
  resultTests: resultTests,
  zeroTests: zeroTests,
}
