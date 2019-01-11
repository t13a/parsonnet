{
  local combinator = self,

  newApplicative(parser):: {
    parser:: parser,

    and(parser):: self + { parser: combinator.and(super.parser, parser) },
    bind(func):: self + { parser: combinator.bind(super.parser, func) },
    or(parser):: self + { parser: combinator.or(super.parser, parser) },
    map(func):: self + { parser: combinator.map(super.parser, func) },
    many():: self + { parser: combinator.many(super.parser },
    try():: self + { parser: combinator.try(super.parser },
  },

  and(lparser, rparser)::
    function(state)
      local lresult = lparser(state);
      if lresult.err == null then
        local rresult = rparser(lresult);
        if rresult.err == null then
          state
          .result()
          .success([lresult, rresult])
          .consume(rresult.next.pos)
        else
          rresult
      else
        lresult,

  bind(parser, func)::
    local enumResult(result) =
      if std.isArray(result.out) then
        result.out
      else if result.out != null then
        [result.out]
      else
        [];
    function(state)
      std.flattenArrays([
        func(result.out)(result.next)
        for result in enumResult(parser(state))
        if result.out != null && result.err == null
      ]),

  or(lparser, rparser)::
    function(state)
      local lresult = lparser(state.input);
      if lresult.err == null then
        lresult
      else
        rparser(lresult.remaining().flush().input),

  many(parser)::
    function(state)
      local aux(s, results) =
        local r = parser(s);
        if r.err == null then
          if r.next.pos != null then
            aux(r.next, results + [r]) tailstrict
          else
            results + [r]
        else
          results;
      aux(state, []),

  map(parser, func)::
    function(state)
      local result = parser(state.input);
      if result.out != null && result.err == null then
        state
        .consume(result.remaining().input.pos)
        .result
        .success(func(result.out))
      else
        result,

  try(parser)::
    function(state)
      local result = parser(state.input);
      if result.err == null then
        result
      else
        state
        .result
        .failure(result.err),
}
