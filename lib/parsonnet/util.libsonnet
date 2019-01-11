{
  local util = self,

  arrayAccum(x)::
    local aux(y, a=[]) =
      if y != null then
        function(z)
          aux(z, a + [y])
      else
        a;
    aux(x, []),

  arrayEnum(x)::
    function(accumFunc)
      local aux(f, y) =
        local g = f(util.head(y));
        if std.isFunction(g) then
          aux(g, util.tail(y)) tailstrict
        else
          g;
      aux(accumFunc, x),

  head(x)::
    if x != null then
      if std.isArray(x) then
        if std.length(x) > 0 then
          x[0]
        else
          null
      else
        x
    else
      null,

  merge(left, right)::
    local l = util.pruneArray(left);
    local r = util.pruneArray(right);
    if l != null && r != null then
      (if std.isArray(l) then l else [l]) +
      (if std.isArray(r) then r else [r])
    else if l != null then
      l
    else if r != null then
      r
    else
      null,

  pruneArray(x)::
    if std.isArray(x) && std.length(x) == 0 then null else x,

  tail(x)::
    if x != null && std.isArray(x) && std.length(x) > 1 then
      x[1:std.length(x)]
    else
      [],
}
