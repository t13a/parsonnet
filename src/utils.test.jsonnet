local state = import 'state.libsonnet';
local utils = import 'utils.libsonnet';

local expect(a, b) = if a == b then true else error 'Expect equal to:\n%s\n%s' % [a, b];
local expectNot(a, b) = if a != b then true else error 'Expect not equal to:\n%s\n%s' % [a, b];

local headTest = {
  case1: expect(utils.head([1, 2, 3]), 1),
  case2: expect(utils.head([]), null),
};

local tailTest = {
  case1: expect(utils.tail([1]), []),
  case2: expect(utils.tail([1, 2]), [2]),
  case3: expect(utils.tail([1, 2, 3]), [2, 3]),
  case4: expect(utils.tail([]), []),
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
    case1: expect(utils.result.failures(e), e),
    case2: expect(utils.result.failures(s), e),
    case3: expect(utils.result.failures(f), f),
    case4: expect(utils.result.failures(sf), f),
  },

  failuresOrSuccessesTest: {
    case1: expect(utils.result.failuresOrSuccesses(e), e),
    case2: expect(utils.result.failuresOrSuccesses(s), s),
    case3: expect(utils.result.failuresOrSuccesses(f), f),
    case4: expect(utils.result.failuresOrSuccesses(sf), f),
  },

  successesTest: {
    case1: expect(utils.result.successes(e), e),
    case2: expect(utils.result.successes(s), s),
    case3: expect(utils.result.successes(f), e),
    case4: expect(utils.result.successes(sf), s),
  },

  successesOrFailuresTest: {
    case1: expect(utils.result.successesOrFailures(e), e),
    case2: expect(utils.result.successesOrFailures(s), s),
    case3: expect(utils.result.successesOrFailures(f), f),
    case4: expect(utils.result.successesOrFailures(sf), s),
  },
};

{
  headTest: headTest,
  tailTest: tailTest,
  // resultTest: resultTest,
}
