local times = std.parseInt(std.extVar('times'));

local arr = [n for n in std.range(1, times)];

local head(arr) = if std.length(arr) > 0 then arr[0] else null;

// bad: cause stack overflow, but why?
// local tail1(arr) = if std.length(arr) > 1 then arr[1:std.length(arr)] else [];

// good
local tail2(arr) =
  if std.length(arr) > 1 then
    local headIndex = 1;
    local lastIndex = std.length(arr) - 1;
    [v for v in arr if v != arr[0]]
  else
    [];

// bad
local tail3(arr) =
  if std.length(arr) > 1 then
    local headIndex = 1;
    local lastIndex = std.length(arr) - 1;
    local indexes = std.range(headIndex, lastIndex);
    [arr[i] for i in indexes]
  else
    [];

local mergeArray1(x, y) = x + y;  // bad

local mergeArray2(x, y) =  // bad
  local aux(i) =
    if i < std.length(x) then
      x[i]
    else
      y[i - std.length(x)];
  local sz = std.length(x) + std.length(y);
  std.makeArray(sz, aux);

local accum(a=[]) =
  function(x)
    if x != null then
      accum(mergeArray2(a, [x]))  // bad: stack overflow
    else
      a;

// bad: stack overflow
local enum(accumFunc, arr) =
  local x = head(arr);
  local a = accumFunc(x);
  if std.isFunction(a) then
    local xs = tail2(arr);
    enum(a, xs) tailstrict
  else
    a;

// bad: stack overflow, why???
local enum2(arr) =
  local x = head(arr);
  if x != null then
    local xs = tail2(arr);
    enum2(xs) tailstrict
  else
    x;

enum(accum(), arr)
// enum2(arr)



