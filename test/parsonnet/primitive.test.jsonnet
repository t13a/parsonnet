local primitive = import 'parsonnet/primitive.libsonnet';
local state = import 'parsonnet/state.libsonnet';

local expect(a, b) = if a == b then true else error 'Expect equal to:\n%s\n%s' % [a, b];
local expectNot(a, b) = if a != b then true else error 'Expect not equal to:\n%s\n%s' % [a, b];

local itemTest = {
  local remainingInp(inp) = if inp != null then inp + 1 else null,
  local getToken(inp) = inp,
  local hasToken(inp) = inp != null,
  local sat(n) = primitive.item(remainingInp, getToken, hasToken, function(token) token == n),

  local init = state.newState(0),
  local term = state.newState(0).setInp(null),

  singleAtInitIfMatched: expect(std.length(sat(0)(init)), 1),
  singleAtInitIfNotMatched: expect(std.length(sat(0)(init)), 1),
  singleAtTerm: expect(std.length(sat(0)(term)), 1),

  outputAtInitIfMatched: expect(sat(0)(init)[0].out, 0),
  noOutputAtInitIfNotMatched: expect(std.objectHas(sat(1)(init)[0], 'out'), false),
  noOutputAtTerm: expect(std.objectHas(sat(0)(term)[0], 'out'), false),

  noErrorAtInitIfMatched: expect(std.objectHas(sat(0)(init)[0], 'err'), false),
  errorAtInitIfNotMatched: expectNot(sat(1)(init)[0].err, null),
  errorAtTerm: expectNot(sat(0)(term)[0].err, null),

  consumptionAtInitIfMathced: expectNot(sat(0)(init)[0].remaining.inp, init.inp),
  consumptionAtInitIfNotMathced: expectNot(sat(1)(init)[0].remaining.inp, init.inp),
  noConsumptionAtTerm: expect(sat(0)(term)[0].remaining.inp, term.inp),
};

local resultTest = {
  local out = 'OUT',
  local init = state.newState(0),
  local term = state.newState(0).setInp(null),

  singleAtInit: expect(std.length(primitive.result(out)(init)), 1),
  singleAtTerm: expect(std.length(primitive.result(out)(term)), 1),

  successAtInit: expect(primitive.result(out)(init)[0], init.success(out)),
  successAtTerm: expect(primitive.result(out)(term)[0], term.success(out)),

  noConsumptionAtInit: expect(primitive.result(out)(init)[0].remaining.inp, init.inp),
  noConsumptionAtTerm: expect(primitive.result(out)(term)[0].remaining.inp, term.inp),
};

local zeroTest = {
  local err = 'ERR',
  local init = state.newState(0),
  local term = state.newState(0).setInp(null),

  singleAtInit: expect(std.length(primitive.zero(err)(init)), 1),
  singleAtTerm: expect(std.length(primitive.zero(err)(term)), 1),

  failureAtInit: expect(primitive.zero(err)(init)[0], init.failure(err)),
  failureAtTerm: expect(primitive.zero(err)(term)[0], term.failure(err)),

  noConsumptionAtInit: expect(primitive.zero(err)(init)[0].remaining.inp, init.inp),
  noConsumptionAtTerm: expect(primitive.zero(err)(term)[0].remaining.inp, term.inp),
};

{
  itemTest: itemTest,
  resultTest: resultTest,
  zeroTest: zeroTest,
}
