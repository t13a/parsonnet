local char = import 'char.libsonnet';
local state = import 'state.libsonnet';

local expect(a, b) = if a == b then true else error 'Expect equal to:\n%s\n%s' % [a, b];
local expectNot(a, b) = if a != b then true else error 'Expect not equal to:\n%s\n%s' % [a, b];

local anyCharTests = {
  local init = state.newState('ABC', 0),
  local term = state.newState('ABC', 0).consume(null),
  local empty = state.newState('', 0),

  outputAtInit: expect(char.anyChar(init).out, 'A'),
  noOutputAtTerm: expect(char.anyChar(term).out, null),
  noOutputIfEmpty: expect(char.anyChar(empty).out, null),
};

local satisfyTests = {
  local isA(token) = token == 'A',
  local isB(token) = token == 'B',

  local init = state.newState('ABC', 0),
  local term = state.newState('ABC', 0).consume(null),
  local empty = state.newState('', 0),

  outputIfMathced: expect(char.satisfy(isA)(init).out, 'A'),
  noOutputIfNotMatched: expect(char.satisfy(isB)(init).out, null),
  noOutputAtTerm: expect(char.satisfy(isA)(term).out, null),
  noOutputAtEmpty: expect(char.satisfy(isA)(empty).out, null),

  noErrorIfMatched: expect(char.satisfy(isA)(init).err, null),
  errorIfNotMatched: expectNot(char.satisfy(isB)(init).err, null),
  errorAtTerm: expectNot(char.satisfy(isA)(term).err, null),
  errorAtEmpty: expectNot(char.satisfy(isA)(empty).err, null),

  consumptionIfMatched: expect(char.satisfy(isA)(init).state().input.pos, 1),
  consumptionIfNotMatched: expect(char.satisfy(isB)(init).state().input.pos, 1),
  noConsumptionAtTerm: expect(char.satisfy(isA)(term).state().input.pos, term.input.pos),
  consumptionAtEmpty: expectNot(char.satisfy(isA)(empty).state().input.pos, empty.input.pos),
};

local stringTests = {
  local init = state.newState('ABC', 0),
  local term = state.newState('ABC', 0).consume(null),
  local empty = state.newState('', 0),

  outputIfMathced: expect(char.string('AB')(init).out, 'AB'),
  noOutputIfNotMatched: expect(char.string('BC')(init).out, null),
  noOutputAtTerm: expect(char.string('AB')(term).out, null),
  noOutputAtEmpty: expect(char.string('AB')(empty).out, null),

  noErrorIfMatched: expect(char.string('AB')(init).err, null),
  errorIfNotMatched: expectNot(char.string('BC')(init).err, null),
  errorAtTerm: expectNot(char.string('AB')(term).err, null),
  errorAtEmpty: expectNot(char.string('AB')(empty).err, null),

  consumptionIfMatched: expect(char.string('AB')(init).state().input.pos, std.length('AB')),
  consumptionIfNotMatched: expect(char.string('BC')(init).state().input.pos, std.length('BC')),
  noConsumptionAtTerm: expect(char.string('AB')(term).state().input.pos, term.input.pos),
  consumptionAtEmpty: expectNot(char.string('AB')(empty).state().input.pos, empty.input.pos),
};

{
  anyCharTests: anyCharTests,
  satisfyTests: satisfyTests,
  stringTests: stringTests,
}
