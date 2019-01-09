{
  factory:: {
    // Primitive

    bind(parser, func)::  // FIXME
      function(s)
        local state = parser(s);
        local aux(lstate, i) =
          if i < std.length(state) then
            lstate.merge(func(state[i]))
          else
            lstate;
        aux(state[0], 1),

    fail(msg)::
      function(input)
        input.result().addErr(msg),

    map(func, parser)::
      function(input)
        local result = parser(input);
        if result.hasErr() then
          result
        else
          input
          .result()
          .mergeOut(std.map(func, result.out))
          .setNext(result.next),

    return(val)::
      function(input)
        input.result().addOut(val),

    // Combinator

    and(lparser, rparser)::
      function(input)
        local lresult = lparser(input);
        local rresult = rparser(lresult.next);
        lresult.merge(rresult),

    many(parser)::
      function(s)
        local aux(lstate) =
          local rstate = parser(lstate);
          if rstate.isSuccess() then
            if rstate.hasNext() then
              aux(lstate.merge(rstate)) tailstrict
            else
              lstate.merge(rstate)
          else
            lstate.mergePos(rstate);
        aux(s),

    or(lparser, rparser)::
      function(s)
        local lstate = lparser(s);
        if lstate.isSuccess() then
          lstate
        else
          rparser(lstate),

    try(parser)::
      function(s)
        local state = parser(s);
        if state.isSuccess() then
          s.merge(state)
        else
          s,
  },

  local newResult = self.result.new,

  input:: {
    new(src, initPos, nextPos, getToken)::
      assert src != null : 'src must not be null';
      assert std.isFunction(initPos) : 'initPos must be a function, got %s' % std.type(initPos);
      assert std.isFunction(nextPos) : 'nextPos must be a function, got %s' % std.type(nextPos);
      assert std.isFunction(getToken) : 'getToken must be a function, got %s' % std.type(getToken);
      {
        pos: initPos(src),

        hasPos():: self.pos != null,
        hasToken():: self.token() != null,
        result():: newResult(self + { pos: nextPos(super.pos) }),
        token():: getToken(src, self.pos),
      },
  },

  result:: {
    new(initNext):: {
      out: [],
      err: [],
      next: initNext,

      addOut(val)::
        assert val != null : 'val must not be null';
        self + { out+: [val] },
      addErr(msg)::
        assert std.isString(msg) : 'msg must be a string, got %s' % std.type(msg);
        self + { err+: [msg] },
      setNext(next)::
        assert std.isObject(next) : 'next must be an object, got %s' % std.type(next);
        self + { next: next },

      merge(result)::
        assert std.isObject(result) : 'result must be an object, got %s' % std.type(result);
        self.mergeOut(result.out).mergeErr(result.err).mergeNext(result.next),
      mergeOut(out)::
        assert std.isArray(out) : 'out must be an array, got %s' % std.type(out);
        self + { out+: out },
      mergeErr(err)::
        assert std.isArray(err) : 'err must be an array, got %s' % std.type(err);
        self + { err+: err },

      firstOut():: if self.hasOut() then self.out[0] else null,
      firstErr():: if self.hasErr() then self.err[0] else null,
      hasOut():: std.length(self.out) > 0,
      hasErr():: std.length(self.err) > 0,
      lastOut():: if self.hasOut() then self.out[std.length(self.out) - 1] else null,
      lastErr():: if self.hasErr() then self.err[std.length(self.err) - 1] else null,
    },
  },

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
