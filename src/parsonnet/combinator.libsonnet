local model = import 'model.libsonnet';
local primitive = import 'primitive.libsonnet';
local util = import 'util.libsonnet';

{
  local combinator = self,

  factory:: {
    new(mapFunc=combinator.builder)::
      local e = util.extract;
      util.factory(mapFunc) +
      {
        bind(p, f):: self.__map(combinator.bind(e(p), f)),
        many(p):: self.__map(combinator.many(e(p))),
        plus(p, q):: self.__map(combinator.plus(e(p), e(q))),
        seq(p, q):: self.__map(combinator.seq(e(p), e(q))),
      },
  },

  builder:: {
    new(initParser)::
      local e = util.extract;
      util.builder(initParser) +
      {
        bind(f):: self.__with(combinator.bind(self.parser, f)),
        many:: self.__with(combinator.many(self.parser)),
        plus(q):: self.__with(combinator.plus(self.parser, e(q))),
        seq(q):: self.__with(combinator.seq(self.parser, e(q))),
      },
  },

  // bind      :: Parser a -> (a -> Parser b) -> Parser b
  // p 'bind' f = \inp -> concat [f v inp' | (v,inp') <- p inp]
  bind(parser, func)::
    assert std.isFunction(parser) :
           'parser must be an function, got %s' % std.type(parser);
    assert std.isFunction(func) :
           'func must be an function, got %s' % std.type(func);
    function(state)
      local bs = std.flattenArrays(
        [
          func(a)(a.state).results
          for a in parser(state).results
        ]
      );
      if std.length(bs) > 0 then
        local v = std.map(util.resultValue, bs);
        local s = util.last(bs).state;
        model.writer.new([model.result.new(v, s)])
      else
        model.writer.new(),

  // many  :: Parser a -> Parser [a]
  // many p = [x:xs | x <- p, xs <- many p] ++ [[]]
  many(parser)::
    assert std.isFunction(parser) :
           'parser must be an function, got %s' % std.type(parser);
    local accum(p, s, v=[]) =
      local b = p(s);
      if util.isSuccess(b) then
        accum(
          p,
          util.last(b.results).state,
          v + std.map(util.resultValue, b.results)
        ) tailstrict
      else
        model.result.new(v, s);
    function(state)
      model.writer.new([accum(parser, state)]),

  // plus :: Parser a -> Parser a -> Parser a
  // p 'plus' q = \inp -> (p inp ++ q inp)
  plus(parser1, parser2)::
    assert std.isFunction(parser1) :
           'parser1 must be an function, got %s' % std.type(parser1);
    assert std.isFunction(parser2) :
           'parser2 must be an function, got %s' % std.type(parser2);
    function(state)
      parser1(state) + parser2(state),

  // seq      :: Parser a -> Parser b -> Parser (a,b)
  // p 'seq' q = \inp -> [((v,w),inp'') | (v,inp')  <- p inp
  //                                    , (w,inp'') <- q inp']
  seq(parser1, parser2)::
    assert std.isFunction(parser1) :
           'parser1 must be an function, got %s' % std.type(parser1);
    assert std.isFunction(parser2) :
           'parser2 must be an function, got %s' % std.type(parser2);
    self.bind(
      parser1,
      function(a)
        self.bind(
          parser2,
          function(b)
            primitive.pure([a, b])
        )
    ),
}
