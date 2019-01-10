local state = import 'state.libsonnet';

local expect(a, b) = if a == b then true else error 'Expect equal to:\n%s\n%s' % [a, b];
local expectNot(a, b) = if a != b then true else error 'Expect not equal to:\n%s\n%s' % [a, b];

local newStateTests = {
  local src = 'SRC',
  local out = 'OUT',
  local err = 'ERR',
  local new(pos) = state.newState(src, pos),

  zeroIsZero: expect(new(0), new(0)),
  oneIsNotZero: expectNot(new(1), new(0)),

  zeroSuccessHasOut: expect(new(0).result.success(out).out, out),
  zeroFailureHasErr: expect(new(0).result.failure(err).err, err),

  zeroSuccessStateIsZero: expect(new(0).result.success(out).state(), new(0)),
  zeroFailureStateIsZero: expect(new(0).result.failure(err).state(), new(0)),

  zeroConsumeZeroIsZero: expect(new(0).consume(0), new(0)),
  zeroConsumeOneIsOne: expect(new(0).consume(1), new(1)),

  zeroConsumeOneSuccessStateIsOne: expect(new(0).consume(1).result.success(out).state(), new(1)),
  zeroConsumeOneFailureStateIsOne: expect(new(0).consume(1).result.failure(err).state(), new(1)),
};

{
  newStateTests: newStateTests,
}
