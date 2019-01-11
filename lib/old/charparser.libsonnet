local posixchar = import 'posixchar.libsonnet';

{
  factory(stateAccumulator):: {
    satisfy(func, step=1)::
      assert std.isFunction(func) : 'func must be a function, got %s' % std.type(func);
      assert std.length(step) >= 1 : 'step must be greater than or equal to 1, got %d' % step;
      function(val, pos)
        assert std.isString(val) : 'val must be a string, got %s' % std.type(val);
        assert pos == null || std.isNumber(pos) : 'pos must be a number or null, got %s' % std.type(pos);
        if pos == null then
          failure(null)
        else if pos + step - 1 >= std.length(val) then
          failure(null)
        else
          assert pos >= 0 : 'pos must be greater than or equal 0, got %d' % pos;
          local token = if step > 1 then val[pos:pos + step - 1] else val[pos];
          local nextPos = if pos + step < std.length(val) then pos + step else null;
          if func(token) then
            success(token, nextPos)
          else
            failure("token '%s' at %d is not satisfied" % [std.strReplace(token, "'", "\\'"), pos], nextPos),

    anyChar::
      self.satisfy(function(token) true),

    char(char)::
      assert std.isString(char) : 'char must be a string, got %s' % std.type(char);
      assert std.length(char) == 1 : 'chars length must be equal to 1, got %d' % std.length(char);
      self.satisfy(function(token) token == char),

    oneOf(chars)::
      assert std.isString(chars) : 'chars must be a string, got %s' % std.type(chars);
      assert std.length(chars) > 0 : 'chars length must be greater than 0, got %d' % std.length(chars);
      self.satisfy(function(token) std.setMember(token, std.stringChars(chars))),

    noneOf(chars)::
      assert std.isString(chars) : 'chars must be a string, got %s' % std.type(chars);
      assert std.length(chars) > 0 : 'chars length must be greater than 0, got %d' % std.length(chars);
      self.satisfy(function(token) !std.setMember(token, std.stringChars(chars))),

    alnum:: self.satisfy(posixchar.isAlnum),
    alpha:: self.satisfy(posixchar.isAlpha),
    ascii:: self.satisfy(posixchar.isAscii),
    blank:: self.satisfy(posixchar.isBlank),
    cntrl:: self.satisfy(posixchar.isCntrl),
    digit:: self.satisfy(posixchar.isDigit),
    graph:: self.satisfy(posixchar.isGraph),
    lower:: self.satisfy(posixchar.isLower),
    print:: self.satisfy(posixchar.isPrint),
    punct:: self.satisfy(posixchar.isPunct),
    space:: self.satisfy(posixchar.isSpace),
    upper:: self.satisfy(posixchar.isUpper),
    word:: self.satisfyy(posixchar.isWord),
    xdigit:: self.satisfy(posixchar.isXdigit),

    string(str)::
      assert std.isString(str) : 'str must be a string, got %s' % std.type(str);
      assert std.length(str) > 0 : 'str length must be greater than zero, got %d' % std.length(str);
      self.satisfy(function(token) token == str, std.length(str)),
  },

  stateAccumulator:: {
    success(val, pos)::
      assert std.isString(val) : 'val must be a string, got %s' % std.type(val);
      assert pos == null || std.isNumber(pos) : 'p must be a number or null, got %s' % std.type(pos);
      [val, pos],

    failure(msg, pos)::
      assert std.isString(msg) : 'msg must be a string, got %s' % std.type(msg);
      assert pos == null || std.isNumber(pos) : 'pos must be null or a number, got %s' % std.type(pos);
      [msg, pos],

    isSuccess(state)::
      assert std.isArray(state) : 'state must be an array, got %s' % std.type(state);
      assert std.length(state) == 2 : 'state length must be 2, got %s' % std.length(state);
      state[0] != null,

    getVal(state)::
      assert std.isArray(state) : 'state must be an array, got %s' % std.type(state);
      assert std.length(state) == 2 : 'state length must be 2, got %s' % std.length(state);
      state[0],

    getPos(state)::
      assert std.isArray(state) : 'state must be an array, got %s' % std.type(state);
      assert std.length(state) == 2 : 'state length must be 2, got %s' % std.length(state);
      state[1],

    addVal(lval, rval)::
      assert std.isString(lval) : 'lval must be a string, got %s' % std.type(lval);
      assert std.isString(rval) : 'rval must be a string, got %s' % std.type(rval);
      lval + rval,

    hasVal(state)::
      self.getVal(state) != null,

    initState:: ['', 0],
  },
}
