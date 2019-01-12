local primitive = import 'primitive.libsonnet';
local util = import 'util.libsonnet';

{
  local combinator = self,

  newBuilder(initParser):: {
    parser:: initParser,

    bind(func):: self { parser: combinator.bind(super.parser, func) },
    many():: self { parser: combinator.many(super.parser) },
    plus(parser):: self { parser: combinator.plus(super.parser, parser) },
    seq(parser):: self { parser: combinator.seq(super.parser, parser) },
    try():: self { parser: combinator.try(super.parser) },
  },

  bind(parser, func)::
    function(state)
      util.result.successesOrFailures(std.flattenArrays(
        [
          func(a)(a.remaining)
          for a in parser(state)
        ]
      )),

  many(parser)::
    self.bind(
      parser,
      function(a)
        if a.isSuccess() then
          if a.remaining.hasInp() then
            self.many(parser)  // tailstrict
          else
            primitive.result(a)
        else
          primitive.result()
    ),

  plus(lparser, rparser)::
    local applyIfFailure(a) =
      if a.isSuccess() then
        primitive.result(a.out)
      else
        rparser;
    self.bind(lparser, applyIfFailure),

  seq(lparser, rparser)::
    local applyIfSuccess(a) =
      if a.isSuccess() then
        function(state)
          [a] + rparser(state)
      else
        primitive.zero(a.err);
    self.bind(lparser, applyIfSuccess),

  try(parser)::
    function(state)
      local a = parser(state);
      local s = util.result.successes(a);
      local f = util.result.failures(a);
      if std.length(f) == 0 then
        s
      else
        std.map(function(ff) state.failure(ff.err), f),
}
