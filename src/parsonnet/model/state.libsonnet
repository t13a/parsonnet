{
  new(reader)::
    {
      next():: reader.nextState(self),
      reader():: reader,
    },
}
