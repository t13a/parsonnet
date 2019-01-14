local times = std.parseInt(std.extVar('times'));

local target(gen) = {
  gen: gen,
  derive()::
    local newgen = self.gen + 1;  // good
    self { gen: newgen },
};

local accum(t) =
  if t.gen < times then
    accum(t.derive()) tailstrict
  else
    t;

accum(target(1))
