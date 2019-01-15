{
  new(results=[])::
    assert std.isArray(results) || std.isString(results) :
           'results must be an array, got %s' % std.type(results);
    {
      results+: results,
    },
}
