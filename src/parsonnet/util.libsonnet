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

  // Output

  cok(output):: self.isConsumed(output) && self.isSuccess(output),
  cerr(output):: self.isConsumed(output) && self.isFailure(output),
  eok(output):: self.isUnconsumed(output) && self.isSuccess(output),
  eerr(output):: self.isUnconsumed(output) && self.isFailure(output),

  isConsumed(output)::
    !self.isUnconsumed(output),

  isUnconsumed(output)::
    assert std.isObject(output) : 'output must be an object, got %s' % std.type(output);
    std.length(output.results) == 0
    || (
      std.length(output.results) == 1
      && std.isArray(output.results[0])
      && std.length(output.results[0]) == 0
    ),

  isSuccess(output)::
    assert std.isObject(output) : 'output must be an object, got %s' % std.type(output);
    std.length(output.results) > 0,

  isFailure(output)::
    !self.isFailure(output),

  outputResultValue(output)::
    assert std.isObject(output) : 'output must be an object, got %s' % std.type(output);
    assert std.length(output) == 1 : 'output length must be 1, got %s' % std.length(output);
    output[0].value,

  outputResultValues(output)::
    assert std.isObject(output) : 'output must be an object, got %s' % std.type(output);
    std.map(self.resultValue, output.results),

  // Result

  resultValue(result)::
    assert std.isObject(result) : 'result must be an object, got %s' % std.type(result);
    result.value,
}
