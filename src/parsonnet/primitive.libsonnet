{
  local any(x) = true,

  item(
    remainingInpFunc,
    getTokenFunc,
    hasTokenFunc,
    testTokenFunc=any,
    formatInpFunc=std.toString,
    formatTokenFunc=std.toString
  )::
    function(state)
      if state.hasInp() && hasTokenFunc(state.inp) then
        local token = getTokenFunc(state.inp);
        if testTokenFunc(token) then
          [
            state
            .setInp(remainingInpFunc(state.inp))
            .success(token),
          ]
        else
          [
            state
            .setInp(remainingInpFunc(state.inp))
            .failure(
              "unexpected token '%s' found at %s" % [
                std.strReplace(formatTokenFunc(token), "'", "\\'"),
                formatInpFunc(state.inp),
              ]
            ),
          ]
      else
        [
          state
          .setInp(remainingInpFunc(state.inp))
          .failure('token not found at %s' % formatInpFunc(state.inp)),
        ],

  result(out)::
    function(state)
      [
        state
        .success(out),
      ],

  zero(err)::
    function(state)
      [
        state
        .failure(err),
      ],
}
