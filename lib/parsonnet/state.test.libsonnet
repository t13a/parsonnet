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

local firstTests = {
  valueFromValue: expect(state.first(1), 1),
  firstValueFromArray: expect(state.first([1, 2, 3]), 1),
  nullFromNull: expect(state.first(null), null),
  nullFromEmptyArray: expect(state.first([]), null),
};

local lastTests = {
  valueFromValue: expect(state.last(1), 1),
  lastValueFromArray: expect(state.last([1, 2, 3]), 3),
  nullFromNull: expect(state.last(null), null),
  nullFromEmptyArray: expect(state.last([]), null),
};

local mergeTests = {
  local left = 'LEFT',
  local right = 'RIGHT',

  nullAndNullIsNull: expect(state.merge(null, null), null),
  nullAndRightIsRight: expect(state.merge(null, right), right),
  nullAndRightArrayIsRightArray: expect(state.merge(null, [right]), [right]),

  leftAndNullIsLeft: expect(state.merge(left, null), left),
  leftAndRightIsJoinedArray: expect(state.merge(left, right), [left, right]),
  leftAndRightArrayIsJoinedArray: expect(state.merge(left, [right]), [left, right]),

  leftArrayAndNullIsLeftArray: expect(state.merge([left], null), [left]),
  leftArrayAndRightIsJoinedArray: expect(state.merge([left], right), [left, right]),
  leftArrayAndRightArrayIsJoinedArray: expect(state.merge([left], [right]), [left, right]),
};

{
  newStateTests: newStateTests,
  firstTests: firstTests,
  lastTests: lastTests,
  mergeTests: mergeTests,
}
