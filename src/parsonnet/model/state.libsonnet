{
  new(input)::
    assert std.isObject(input) : 'input must be an object, got %s' % std.type(input);
    {
      next():: input.nextState(self),
      input():: input,
    },
}
