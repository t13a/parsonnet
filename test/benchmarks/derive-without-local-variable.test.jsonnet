local times = std.parseInt(std.extVar('times'));

local target(gen) = {
  gen: gen,
  derive()::
    self { gen: super.gen + 1 /* bad: cause stack overflow */ },
};

local accum(t) =
  if t.gen < times then
    accum(t.derive()) tailstrict
  else
    t;

accum(target(1))
