{
  local any(x) = true,

  item(
    nextPosFunc,
    getTokenFunc,
    testTokenFunc=any,
    formatTokenFunc=std.toString,
    formatPosFunc=std.toString
  )::
    function(state)
      local token = getTokenFunc(state.input);
      if token != null then
        if testTokenFunc(token) then
          state
          .consume(nextPosFunc(state.input))
          .return
          .success(token)
        else
          state
          .consume(nextPosFunc(state.input))
          .return
          .failure(
            "unexpected token '%s' found at %s" % [
              std.strReplace(formatTokenFunc(token), "'", "\\'"),
              formatPosFunc(state.input),
            ]
          )
      else
        state
        .consume(nextPosFunc(state.input))
        .return
        .failure('token not found at %s' % formatPosFunc(state.input.pos)),

  result(out)::
    function(state)
      state
      .return
      .success(out),

  zero(err)::
    function(state)
      state
      .return
      .failure(err),
}
