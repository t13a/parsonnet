local state = import 'state.libsonnet';
local util = import 'util.libsonnet';

local expect(a, b) = if a == b then true else error 'Expect equal to:\n%s\n%s' % [a, b];
local expectNot(a, b) = if a != b then true else error 'Expect not equal to:\n%s\n%s' % [a, b];

local headTest = {
  case1: expect(util.head([1, 2, 3]), 1),
  case2: expect(util.head([]), null),
};

local tailTest = {
  case1: expect(util.tail([1]), []),
  case2: expect(util.tail([1, 2]), [2]),
  case3: expect(util.tail([1, 2, 3]), [2, 3]),
  case4: expect(util.tail([]), []),
};

local resultTest = {
  local e = [],
  local s = [
    state.newState(0).success(1),
    state.newState(0).success(2),
    state.newState(0).success(3),
  ],
  local f = [
    state.newState(0).failure(4),
    state.newState(0).failure(5),
    state.newState(0).failure(6),
  ],
  local sf = s + f,

  failuresTest: {
    case1: expect(util.result.failures(e), e),
    case2: expect(util.result.failures(s), e),
    case3: expect(util.result.failures(f), f),
    case4: expect(util.result.failures(sf), f),
  },

  failuresOrSuccessesTest: {
    case1: expect(util.result.failuresOrSuccesses(e), e),
    case2: expect(util.result.failuresOrSuccesses(s), s),
    case3: expect(util.result.failuresOrSuccesses(f), f),
    case4: expect(util.result.failuresOrSuccesses(sf), f),
  },

  successesTest: {
    case1: expect(util.result.successes(e), e),
    case2: expect(util.result.successes(s), s),
    case3: expect(util.result.successes(f), e),
    case4: expect(util.result.successes(sf), s),
  },

  successesOrFailuresTest: {
    case1: expect(util.result.successesOrFailures(e), e),
    case2: expect(util.result.successesOrFailures(s), s),
    case3: expect(util.result.successesOrFailures(f), f),
    case4: expect(util.result.successesOrFailures(sf), s),
  },
};

{
  headTest: headTest,
  tailTest: tailTest,
  // resultTest: resultTest,
}
