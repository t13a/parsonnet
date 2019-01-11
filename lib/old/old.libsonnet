{
  oldCombinator:: {
    local stateAccumulator = null,
    local success(val, pos) = stateAccumulator.success(val, pos),
    local failure(pos) = stateAccumulator.failure(pos),
    local isSuccess(state) = stateAccumulator.isSuccess(state),
    local val(state) = stateAccumulator.getVal(state),
    local pos(state) = stateAccumulator.getPos(state),
    local add(lval, rval) = stateAccumulator.addVal(lval, rval),
    local hasPos(state) = stateAccumulator.hasPos(state),
    local initPos = stateAccumulator.initState,

    and(parsers)::
      assert std.isArray(parsers) : 'parsers must be an array, got %s' % std.type(parsers);
      assert std.length(parsers) > 0 : 'parsers length must be greater than 0, got %d' % std.length(parsers);
      function(v, p)
        local aux(lr, i=0) =
          local rr = parsers[i](v, pos(lr));
          if isSuccess(rr) then
            local sv = add(val(lr), val(rr));
            if i + 1 < std.length(parsers) then
              aux(success(sv, pos(rr)), i + 1) tailstrict
            else
              success(sv, pos(rr))
          else
            failure();
        aux(success(null, p)),

    left(lparser, rparser)::
      assert std.isFunction(lparser) : 'lparser must be a function, got %s' % std.type(lparser);
      assert std.isFunction(rparser) : 'rparser must be a function, got %s' % std.type(rparser);
      function(v, p)
        local lr = lparser(v, p);
        local rr = rparser(v, pos(lr));
        if isSuccess(lr) && isSuccess(rr) then
          success(val(lr), pos(rr))
        else
          failure(),

    many(parser)::
      assert std.isFunction(parser) : 'parser must be a number, got %s' % std.type(parser);
      function(v, p)
        local aux(lr) =
          local rr = parser(v, pos(lr));
          if isSuccess(rr) then
            local r = success(add(val(lr), val(rr)), pos(rr));
            if hasPos(r) then
              aux(r) tailstrict
            else
              r
          else
            lr;
        aux(success(null, p)),

    not(parser)::
      assert std.isFunction(parser) : 'parser must be a number, got %s' % std.type(parser);
      function(v, p)
        local r = parser(v, p);
        if isSuccess(r) then
          failure()
        else
          success(null, p),

    or(parsers)::
      assert std.isArray(parsers) : 'parsers must be an array, got %s' % std.type(parsers);
      assert std.length(parsers) > 0 : 'parsers length must be greater than 0, got %d' % std.length(parsers);
      function(v, p)
        local aux(i=0) =
          local r = parsers[i](v, p);
          if isSuccess(r) then
            r
          else if i + 1 < std.length(parsers) then
            aux(i + 1) tailstrict
          else
            failure();
        aux(),

    repeat(parser, from, to=from)::
      assert std.isFunction(parser) : 'parser must be a number, got %s' % std.type(parser);
      assert std.isNumber(from) : 'from must be a number, got %s' % std.type(from);
      assert std.isNumber(to) : 'to must be a number, got %s' % std.type(to);
      assert from > 0 : 'from must be greater than 0, got %d' % from;
      assert to > 0 : 'to must be greater than 0, got %d' % to;
      assert from <= to : 'from must be lesser than or equal to, got %d, %d' % [from, to];
      function(v, p)
        local aux(lr, c) =
          local rr = parser(v, pos(lr));
          if isSuccess(rr) then
            local r = success(add(val(lr), val(rr)), pos(rr));
            if hasPos(r) && c < to then
              aux(r, c + 1) tailstrict
            else if c >= from then
              r
            else
              failure()
          else if c >= from then
            success(val(lr), pos(rr))  // FIXME should return lr?
          else
            failure();
        aux(success(null, p), 1),

    right(lparser, rparser)::
      assert std.isFunction(lparser) : 'lparser must be a number, got %s' % std.type(lparser);
      assert std.isFunction(rparser) : 'rparser must be a number, got %s' % std.type(rparser);
      function(v, p)
        local lr = lparser(v, p);
        local rr = rparser(v, pos(lr));
        if isSuccess(lr) && isSuccess(rr) then
          rr
        else
          failure(),

    // Positional

    end::
      function(v, p)
        if p == null then
          success(null, p)
        else
          failure(),

    start::
      function(v, p)
        if p == initPos then
          success(null, p)
        else
          failure(),
  },
}
