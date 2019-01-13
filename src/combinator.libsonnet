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
    local applyUntilFailure(a) =
      if a.isSuccess() then
        if a.remaining.hasInp() then
          function(state)
            [a] + self.many(parser)(state)
        else
          primitive.result(a.out)
      else
        function(state)
          [];
    self.bind(parser, applyUntilFailure),

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
      if util.result.pred.successes(a) then
        a
      else
        std.map(function(b) state.failure(b.err), a),
}
