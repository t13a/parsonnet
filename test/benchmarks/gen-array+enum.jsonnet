local util = import 'parsonnet/util.libsonnet';

local times = std.parseInt(std.extVar('times'));

local arr = [n for n in std.range(1, times)];

util.arrayEnum(arr)(util.arrayAccum)
