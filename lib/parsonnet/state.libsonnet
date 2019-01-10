{
  newState(src, initPos)::
    assert src != null : 'src must not be null';
    assert initPos != null : 'initPos must not be null';
    local firstFunc = self.first;
    local lastFunc = self.last;
    local mergeFunc = self.merge;
    {
      local state = self,

      input: {
        src: src,
        pos: initPos,
      },

      result: {
        out: null,
        err: null,

        success(out)::
          assert out != null : 'out must not be null';
          self { out: mergeFunc(super.out, out) },

        failure(err)::
          assert err != null : 'err must not be null';
          self { err: mergeFunc(super.err, err) },

        firstOut():: firstFunc(self.out),
        firstErr():: firstFunc(self.err),
        lastOut():: lastFunc(self.out),
        lastErr():: lastFunc(self.err),

        state():: state,
      },

      consume(pos):: self { input+: { pos: pos } },
    },

  first(val)::
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

  last(val)::
    if val != null then
      if std.isArray(val) then
        if std.length(val) > 0 then
          val[std.length(val) - 1]
        else
          null
      else
        val
    else
      null,

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
