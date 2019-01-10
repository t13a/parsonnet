local util = import 'util.libsonnet';

local expect(a, b) = if a == b then true else error 'Expect equal to:\n%s\n%s' % [a, b];
local expectNot(a, b) = if a != b then true else error 'Expect not equal to:\n%s\n%s' % [a, b];

local accumTests = {
  accumFrom0: expect(util.enum(util.accum(), []), []),
  accumFrom1: expect(util.enum(util.accum(), [1]), [1]),
  accumFrom2: expect(util.enum(util.accum(), [1, 2]), [1, 2]),
  accumFrom3: expect(util.enum(util.accum(), [1, 2, 3]), [1, 2, 3]),
  accumReverseFrom0: expect(util.enum(util.accum(true), []), []),
  accumReverseFrom1: expect(util.enum(util.accum(true), [1]), [1]),
  accumReverseFrom2: expect(util.enum(util.accum(true), [1, 2]), [2, 1]),
  accumReverseFrom3: expect(util.enum(util.accum(true), [1, 2, 3]), [3, 2, 1]),
};

local enumTests = {
  local accum1(a) = a,
  local accum2(a) = function(b) [a, b],
  enum1From0: expect(util.enum(accum1, []), null),
  enum1From1: expect(util.enum(accum1, [1]), 1),
  enum1From2: expect(util.enum(accum1, [1, 2]), 1),
  enum2From0: expect(util.enum(accum2, []), [null, null]),
  enum2From1: expect(util.enum(accum2, [1]), [1, null]),
  enum2From2: expect(util.enum(accum2, [1, 2]), [1, 2]),
  enum2From3: expect(util.enum(accum2, [1, 2, 3]), [1, 2]),
};

local headTests = {
  valueFromValue: expect(util.head(1), 1),
  headValueFromArray: expect(util.head([1, 2, 3]), 1),
  nullFromNull: expect(util.head(null), null),
  nullFromEmptyArray: expect(util.head([]), null),
};

local mergeTests = {
  local left = 'LEFT',
  local right = 'RIGHT',

  nullAndNullIsNull: expect(util.merge(null, null), null),
  nullAndRightIsRight: expect(util.merge(null, right), right),
  nullAndRightArrayIsRightArray: expect(util.merge(null, [right]), [right]),

  leftAndNullIsLeft: expect(util.merge(left, null), left),
  leftAndRightIsJoinedArray: expect(util.merge(left, right), [left, right]),
  leftAndRightArrayIsJoinedArray: expect(util.merge(left, [right]), [left, right]),

  leftArrayAndNullIsLeftArray: expect(util.merge([left], null), [left]),
  leftArrayAndRightIsJoinedArray: expect(util.merge([left], right), [left, right]),
  leftArrayAndRightArrayIsJoinedArray: expect(util.merge([left], [right]), [left, right]),
};

local tailTests = {
  emptyArrayFromValue: expect(util.tail(1), []),
  emptyArrayFromArray1: expect(util.tail([1]), []),
  arrayFromArray2: expect(util.tail([1, 2]), [2]),
  arrayFromArray3: expect(util.tail([1, 2, 3]), [2, 3]),
  emptyArrayFromNull: expect(util.tail(null), []),
  emptyArrayFromEmptyArray: expect(util.tail([]), []),
};

{
  accumTests: accumTests,
  enumTests: enumTests,
  headTests: headTests,
  mergeTests: mergeTests,
  tailTests: tailTests,
}
