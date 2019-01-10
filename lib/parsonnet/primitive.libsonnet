{
  fail(err)::
    function(state)
      state
      .result
      .failure(err),

  return(out)::
    function(state)
      state
      .result
      .success(out),

  token(
    nextPosFunc,
    getTokenFunc,
    testTokenFunc,
    formatTokenFunc=std.toString,
    formatPosFunc=std.toString
  )::
    function(state)
      local token = getTokenFunc(state.input.src, state.input.pos);
      if token != null then
        if testTokenFunc(token) then
          state
          .consume(nextPosFunc(state.input.src, state.input.pos, token))
          .result
          .success(token)
        else
          state
          .consume(nextPosFunc(state.input.src, state.input.pos, token))
          .result
          .failure(
            "unexpected token '%s' found at %s" % [
              std.strReplace(formatTokenFunc(token), "'", "\\'"),
              formatPosFunc(state.input.pos),
            ]
          )
      else
        state
        .consume(nextPosFunc(state.input.src, state.input.pos, null))
        .result
        .failure('token not found at %s' % formatPosFunc(state.input.pos)),
}
