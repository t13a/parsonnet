local combinator = import 'parsonnet/combinator.libsonnet';
local primitive = import 'parsonnet/primitive.libsonnet';
local state = import 'parsonnet/state.libsonnet';

local expect(a, b) = if a == b then true else error 'Expect equal to:\n%s\n%s' % [a, b];
local expectNot(a, b) = if a != b then true else error 'Expect not equal to:\n%s\n%s' % [a, b];

local outArray(results) = std.map(function(a) a.out, results);
local errArray(results) = std.map(function(a) a.err, results);
local inpArray(results) = std.map(function(a) a.remaining.inp, results);

local remainingInp(inp) = if inp != null && inp < 9 then inp + 1 else null;
local getToken(inp) = inp;
local hasToken(inp) = inp != null;
local any = primitive.item(remainingInp, getToken, hasToken, function(token) true);
local sat(from, to=from) = primitive.item(remainingInp, getToken, hasToken, function(token) token >= from && token <= to);

local init = state.newState(0);
local term = state.newState(0).setInp(null);

local b = combinator.newBuilder;

local bindTest = {
  single: {
    local func1(a) = primitive.result(a.out + 1),

    outputIfMatched1: expect(outArray(b(sat(0)).bind(func1).parser(init)), [1]),
    outputIfMatched2: expect(outArray(b(sat(0)).bind(func1).bind(func1).parser(init)), [2]),
  },
  multiple: {
    local func1(a) =
      function(state)
        primitive.result(a.out + 1)(state) +
        primitive.result(a.out + 1)(state),

    outputIfMatched1: expect(outArray(b(sat(0)).bind(func1).parser(init)), [1, 1]),
    outputIfMatched2: expect(outArray(b(sat(0)).bind(func1).bind(func1).parser(init)), [2, 2, 2, 2]),
  },
};

local manyTest = {
  single: {
    output1: expect(outArray(b(any).many().parser(init)), [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]),
    output2: expect(outArray(b(sat(0, 4)).many().parser(init)), [0, 1, 2, 3, 4]),
    output3: expect(outArray(b(sat(5, 9)).many().parser(init)), []),
  },
  multiple: {
  },
};

local seqTest = {
  single: {
    outputIfMatched1: expect(outArray(b(sat(0)).seq(sat(1)).parser(init)), [0, 1]),
    outputIfMatched2: expect(outArray(b(sat(0)).seq(sat(1)).seq(sat(2)).parser(init)), [0, 1, 2]),

    errorIfNotMatched1: expect(std.length(b(sat(1)).seq(sat(2)).parser(init)), 1),
    errorIfNotMatched2: expect(std.length(b(sat(1)).seq(sat(2).seq(sat(3))).parser(init)), 1),

    consumptionIfMatched: expect(inpArray(combinator.seq(sat(0), sat(1))(init)), [1, 2]),
    consumptionIfNotMatched1: expect(inpArray(combinator.seq(sat(1), sat(2))(init)), [1]),
    consumptionIfNotMatched2: expect(inpArray(combinator.seq(sat(0), sat(2))(init)), [1]),
  },
  multiple: {
    // TODO
  },
};

local tryTest = {
  single: {
    successIfMatched: expect(combinator.try(sat(0))(init)[0].out, 0),
    failureIfNotMatched: expectNot(combinator.try(sat(1))(init)[0].err, null),

    consumptionIfMatched: expect(combinator.try(sat(0))(init)[0].remaining.inp, 1),
    noConsumptionIfNotMatched: expect(combinator.try(sat(1))(init)[0].remaining.inp, 0),
  },
  multiple: {
    // TODO
  },
};

{
  bindTest: bindTest,
  manyTest: manyTest,
  seqTest: seqTest,
  tryTest: tryTest,
}
