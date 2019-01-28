local csv = import 'csv.libsonnet';
local parsonnet = import 'parsonnet.libsonnet';

local parser = csv.csvFile.parser;
local state = parsonnet.char.input.new(std.extVar('src')).initState();

parser(state)
