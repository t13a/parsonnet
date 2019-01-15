{
  local util = self,

  factory(mapFunc)::
    assert std.isFunction(mapFunc) :
           'mapFunc must be an mapFunction, got %s' % std.type(mapFunc);
    {
      __map(parser):: mapFunc(parser),
    },

  builder(initParser)::
    assert std.isFunction(initParser) :
           'initParser must be an function, got %s' % std.type(initParser);
    {
      parser:: initParser,

      __with(parser):: self { parser: util.extract(parser) },
    },

  extract(parser)::
    if std.isFunction(parser) then
      parser  // assume x is a parser
    else if std.isObject(parser) then
      parser.parser  // assume x is a builder
    else
      error 'parser could not be adapted, got %s,' % std.type(parser),

  // Array or string

  head(x)::
    assert std.isArray(x) || std.isString(x) :
           'x must be an array or a string, got %s' % std.type(x);
    assert std.length(x) > 0 :
           'x length must be greater than 0';
    x[0],

  init(x)::
    assert std.isArray(x) || std.isString(x) :
           'x must be an array or a string, got %s' % std.type(x);
    assert std.length(x) > 0 :
           'x length must be greater than 0';
    x[0:std.length(x) - 1],

  isEmpty(x)::
    assert std.isArray(x) || std.isString(x) :
           'x must be an array or a string, got %s' % std.type(x);
    std.length(x) == 0,

  last(x)::
    assert std.isArray(x) || std.isString(x) :
           'x must be an array or a string, got %s' % std.type(x);
    assert std.length(x) > 0 :
           'x length must be greater than 0';
    x[std.length(x) - 1],

  tail(x)::
    assert std.isArray(x) || std.isString(x) :
           'x must be an array or a string, got %s' % std.type(x);
    assert std.length(x) > 0 :
           'x length must be greater than 0';
    if std.length(x) > 1 then
      x[1:std.length(x)]
    else
      [],

  // Writer

  cok(writer):: self.isConsumed(writer) && self.isSuccess(writer),
  cerr(writer):: self.isConsumed(writer) && self.isFailure(writer),
  eok(writer):: self.isUnconsumed(writer) && self.isSuccess(writer),
  eerr(writer):: self.isUnconsumed(writer) && self.isFailure(writer),

  isConsumed(writer)::
    !self.isUnconsumed(writer),

  isUnconsumed(writer)::
    assert std.isObject(writer) : 'writer must be an object, got %s' % std.type(writer);
    std.length(writer.results) == 0
    || (
      std.length(writer.results) == 1
      && std.isArray(writer.results[0])
      && std.length(writer.results[0]) == 0
    ),

  isSuccess(writer)::
    assert std.isObject(writer) : 'writer must be an object, got %s' % std.type(writer);
    std.length(writer.results) > 0,

  isFailure(writer)::
    !self.isFailure(writer),

  writerResultValue(writer)::
    assert std.isObject(writer) : 'writer must be an object, got %s' % std.type(writer);
    assert std.length(writer) == 1 : 'writer length must be 1, got %s' % std.length(writer);
    writer[0].value,

  writerResultValues(writer)::
    assert std.isObject(writer) : 'writer must be an object, got %s' % std.type(writer);
    std.map(self.resultValue, writer.results),

  // Result

  resultValue(result)::
    assert std.isObject(result) : 'result must be an object, got %s' % std.type(result);
    result.value,
}
