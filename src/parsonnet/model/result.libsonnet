{
  new(value, state)::
    assert value != null : 'value must not be null';
    assert std.isObject(state) : 'state must be an object, got %s' % std.type(state);
    {
      value: value,
      state: state,
    },
}
