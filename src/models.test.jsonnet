local state = import 'state.libsonnet';

local expect(a, b) = if a == b then true else error 'Expect equal to:\n%s\n%s' % [a, b];
local expectNot(a, b) = if a != b then true else error 'Expect not equal to:\n%s\n%s' % [a, b];

local newStateTest = {
  local new(inp) = state.newState(inp),

  hasInpTest: {
    case1: expect(new(0).hasInp(), true),
    case2: expect(new(0).setInp(1).hasInp(), true),
    case3: expect(new(0).setInp(null).hasInp(), false),
  },

  setInpTest: {
    case1: expect(new(0).inp, 0),
    case2: expect(new(0).setInp(1).inp, 1),
    case3: expect(new(0).setInp(1).setInp(2).inp, 2),
    case4: expect(new(0).setInp(null).inp, null),
    case5: expect(new(0).setInp(null).setInp(3).inp, 3),
  },

  successTest: {
    remainingTest: {
      case1: expect(new(0).success(0).remaining, new(0)),
      case2: expect(new(0).setInp(1).success(0).remaining, new(1)),
    },
  },

  failureTest: {
    remainingTest: {
      case1: expect(new(0).failure(0).remaining, new(0)),
      case2: expect(new(0).setInp(1).failure(0).remaining, new(1)),
    },
  },
};

{
  newStateTest: newStateTest,
}
