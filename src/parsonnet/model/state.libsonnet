{
  new(reader)::
    assert std.isObject(reader) : 'reader must be an object, got %s' % std.type(reader);
    {
      next():: reader.nextState(self),
      reader():: reader,
    },
}
