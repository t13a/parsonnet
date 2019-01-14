local times = std.parseInt(std.extVar('times'));

local arr = [n for n in std.range(1, times)];

[n * 2 for n in arr]
