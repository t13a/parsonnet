local model = import 'models.libsonnet';
local primitive = import 'primitive.libsonnet';

{
  local combinator = self,

  factory(builder=combinator.builder):: {
    bind(parser, func):: builder(combinator.bind(parser, func)),
    many(parser):: builder(combinator.many(parser)),
    plus(lparser, rparser):: builder(combinator.plus(lparser, rparser)),
    seq(lparser, rparser):: builder(combinator.seq(lparser, rparser)),
    try(parser):: builder(combinator.try(parser)),
  },

  builder(initParser):: {
    apply:: initParser,

    bind(func):: self { apply: combinator.bind(super.parser, func) },
    many():: self { apply: combinator.many(super.parser) },
    plus(parser):: self { apply: combinator.plus(super.parser, parser) },
    seq(parser):: self { apply: combinator.seq(super.parser, parser) },
    try():: self { apply: combinator.try(super.parser) },
  },

  bind(parser, func)::
    function(state)
      utils.result.successesOrFailures(std.flattenArrays(
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
      if utils.result.pred.successes(a) then
        a
      else
        std.map(function(b) models.newFailure(b.err), a),
}
