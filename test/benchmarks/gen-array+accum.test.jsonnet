local times = std.parseInt(std.extVar('times'));

local arr = [n for n in std.range(1, times)];

local accum(arr, i=0, o=[]) =
  if i < std.length(arr) then
    accum(arr, i + 1, o + [arr[i] * 2]) tailstrict
  else
    o;

accum(arr)
