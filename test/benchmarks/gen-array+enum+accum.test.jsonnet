local times = std.parseInt(std.extVar('times'));

local arr = [n for n in std.range(1, times)];

local accum(x) =
  local aux(y, a=[]) =
    if y != null then
      function(z)
        aux(z, a + [y])
    else
      a;
  aux(x, []);

local enum(x) =
  function(accumFunc)
    local aux(f, y) =
      local g = f(y[0]);
      if std.isFunction(g) then
        aux(g, y[1:std.length(y)]) tailstrict
      else
        g;
    aux(accumFunc, x);

enum(arr)(accum)
