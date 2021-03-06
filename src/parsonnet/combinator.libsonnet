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
        bind(p, f):: self.__map(combinator.bind(e(p), function(a) e(f(a)))),
        endBy(p, sep):: self.__map(combinator.endBy(e(p), e(sep))),
        many(p):: self.__map(combinator.many(e(p))),
        many1(p):: self.__map(combinator.many1(e(p))),
        optional(p):: self.__map(combinator.optional(e(p))),
        plus(p, q):: self.__map(combinator.plus(e(p), e(q))),
        sepBy(p, sep):: self.__map(combinator.sepBy(e(p), e(sep))),
        sepBy1(p, sep):: self.__map(combinator.sepBy1(e(p), e(sep))),
        seq(p, q):: self.__map(combinator.seq(e(p), e(q))),
      },
  },

  builder:: {
    new(initParser)::
      local e = util.extract;
      util.builder(initParser) +
      {
        bind(f):: self.__with(combinator.bind(self.parser, function(a) e(f(a)))),
        endBy(seq):: self.__with(combinator.endBy(self.parser, e(seq))),
        many:: self.__with(combinator.many(self.parser)),
        many1:: self.__with(combinator.many1(self.parser)),
        optional:: self.__with(combinator.optional(self.parser)),
        plus(q):: self.__with(combinator.plus(self.parser, e(q))),
        sepBy(seq):: self.__with(combinator.sepBy(self.parser, e(seq))),
        sepBy1(seq):: self.__with(combinator.sepBy1(self.parser, e(seq))),
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
        local vs = std.map(util.resultValue, bs);
        local s = util.last(bs).state;
        model.output.new(std.map(function(v) model.result.new(v, s), vs))
      else
        model.output.new(),

  endBy(parser, sepParser)::
    self.many(
      self.bind(
        parser,
        function(a)
          self.bind(
            sepParser,
            function(b)
              primitive.result(a.value)
          )
      )
    ),

  optional(parser)::
    assert std.isFunction(parser) :
           'parser must be an function, got %s' % std.type(parser);
    function(state)
      local a = parser(state);
      if util.isSuccess(a) then
        a
      else
        model.output.new([model.result.new([], state)]),

  // many  :: Parser a -> Parser [a]
  // many p = [x:xs | x <- p, xs <- many p] ++ [[]]
  many(parser)::
    assert std.isFunction(parser) :
           'parser must be an function, got %s' % std.type(parser);
    local accum(p, s, v=[]) =
      local b = p(s);
      if util.isSuccess(b) then
        if util.isConsumed(b.results[0]) then
          accum(
            p,
            util.last(b.results).state,
            v + std.map(util.resultValue, b.results)
          ) tailstrict
        else
          model.result.new(v, util.last(b.results).state)
      else
        model.result.new(v, s);
    function(state)
      model.output.new([accum(parser, state)]),

  many1(parser)::
    assert std.isFunction(parser) :
           'parser must be an function, got %s' % std.type(parser);
    self.bind(
      parser,
      function(a)
        self.bind(
          self.many(parser),
          function(b)
            if util.isConsumed(b) then
              primitive.result([a.value] + b.value)
            else
              primitive.result([a.value])
        )
    ),

  // plus :: Parser a -> Parser a -> Parser a
  // p 'plus' q = \inp -> (p inp ++ q inp)
  plus(parser1, parser2)::
    assert std.isFunction(parser1) :
           'parser1 must be an function, got %s' % std.type(parser1);
    assert std.isFunction(parser2) :
           'parser2 must be an function, got %s' % std.type(parser2);
    function(state)
      local a = parser1(state);
      local b = parser2(state);
      if util.isSuccess(a) then
        a
      else
        b,

  sepBy(parser, sepParser)::
    self.plus(self.sepBy1(parser, sepParser), primitive.result()),

  sepBy1(parser, sepParser)::
    self.bind(
      parser,
      function(a)
        self.bind(
          self.many(
            self.bind(
              sepParser,
              function(b)
                self.bind(
                  parser,
                  function(c)
                    primitive.result(c.value)
                )
            )
          ),
          function(b)
            if util.isConsumed(b) then
              primitive.result([a.value] + b.value)
            else
              primitive.result([a.value])
        )
    ),

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
            primitive.result([a.value, b.value])
        )
    ),
}
