{
  debugState():: {
    debug:: true,
  },

  isDebug(state)::
    assert std.isObject(state) : 'state must be an object, got %s' % std.type(state);
    std.objectHasAll(state, 'debug')
    && std.isBoolean(state.debug)
    && state.debug,

  traceIfDebug(state, str, rest)::
    if self.isDebug(state) then
      std.trace(str, rest)
    else
      rest,
}
