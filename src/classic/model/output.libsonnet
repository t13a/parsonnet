{
  new(value, state)::
    assert std.isObject(state) : 'state must be an object, got %s' % std.type(state);
    {
      value: value,
      state: state,
    },
}
