local primitive = import 'primitive.libsonnet';
local state = import 'state.libsonnet';

local expect(a, b) = if a == b then true else error 'Expect equal to:\n%s\n%s' % [a, b];
local expectNot(a, b) = if a != b then true else error 'Expect not equal to:\n%s\n%s' % [a, b];

local itemTests = {
  local nextPos(input) = if input.pos != null && hasToken(input { pos: super.pos + 1 }) then input.pos + 1,
  local getToken(input) = if input.pos != null && hasToken(input) then input.src[input.pos],
  local hasToken(input) = input.pos != null && input.pos >= 0 && input.pos < std.length(input.src),
  local sat(char) = primitive.item(nextPos, getToken, hasToken, function(token) token == char),

  local out = 'OUT',
  local init = state.newState('123', 0),
  local term = state.newState('123', 0).consume(null),
  local empty = state.newState('', 0),

  outputIfMatched: expect(sat('1')(init).out, '1'),
  noOutputIfNotMatched: expect(sat('2')(init).out, null),
  noOutputAtTerm: expect(sat('1')(term).out, null),
  noOutputIfEmpty: expect(sat('1')(empty).out, null),

  noErrorIfMatched: expect(sat('1')(init).err, null),
  errorIfNotMatched: expectNot(sat('2')(init).err, null),
  errorAtTerm: expectNot(sat('1')(term).err, null),
  errorIfEmpty: expectNot(sat('1')(empty).err, null),

  consumptionIfMathced: expectNot(sat('1')(init).remaining().input.pos, init.input.pos),
  consumptionIfNotMathced: expectNot(sat('2')(init).remaining().input.pos, init.input.pos),
  noConsumptionAtTerm: expect(sat('')(term).remaining().input.pos, term.input.pos),
  consumptionIfEmpty: expectNot(sat('1')(empty).remaining().input.pos, init.input.pos),
};

local resultTests = {
  local out = 'OUT',
  local init = state.newState('123', 0),
  local term = state.newState('123', 0).consume(null),

  succeedAlways: expect(primitive.result(out)(init), init.return.success(out)),
  noConsumption: expect(primitive.result(out)(init).remaining().input.pos, init.input.pos),
};

local zeroTests = {
  local err = 'ERR',
  local init = state.newState('123', 0),

  failAlways: expect(primitive.zero(err)(init), init.return.failure(err)),
  noConsumption: expect(primitive.zero(err)(init).remaining().input.pos, init.input.pos),
};

{
  itemTests: itemTests,
  resultTests: resultTests,
  zeroTests: zeroTests,
}
