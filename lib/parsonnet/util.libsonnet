{
  local util = self,

  accum(reverse=false)::
    function(x)
      local aux(y, a=[]) =
        if y != null then
          function(z)
            if reverse then
              aux(z, a + [y])
            else
              aux(z, [y] + a)
        else
          a;
      aux(x, []),

  enum(testFunc, accumFunc, val)::
    function(func)
      local aux(f, t) =
        local h = util.head(t);
        if testFunc(h) then
          local g = accumFunc(h);
          if std.isFunction(g) then
            aux(g, util.tail(t)) tailstrict
          else
            g
        else
          null;
      aux(func, val),

  head(val)::
    if val != null then
      if std.isArray(val) then
        if std.length(val) > 0 then
          val[0]
        else
          null
      else
        val
    else
      null,

  tail(val)::
    if val != null && std.isArray(val) && std.length(val) > 1 then
      val[1:std.length(val)]
    else
      [],

  merge(left, right)::
    local normalize(x) = if std.isArray(x) && std.length(x) == 0 then null else x;
    local l = normalize(left);
    local r = normalize(right);
    if l != null && r != null then
      (if std.isArray(l) then l else [l]) +
      (if std.isArray(r) then r else [r])
    else if l != null then
      l
    else if r != null then
      r
    else
      null,

}
