local combinator = import 'combinator.libsonnet';
local debug = import 'debug.libsonnet';
local model = import 'model.libsonnet';
local primitive = import 'primitive.libsonnet';
local util = import 'util.libsonnet';

{
  local char = self,

  reader:: {
    new(src)::
      assert std.isString(src) : 'src must be a string, got %s' % std.type(src);
      local hasPos(pos, offsetPos=0) =
        pos != null
        && pos + offsetPos >= 0
        && pos + offsetPos < std.length(src);
      model.reader.new() +
      {
        initState():: model.state.new(self) { pos: 0 },
        nextState(state)::
          // binding local variable on outside the object is
          // VERY important to save stack frames
          local nextPos = if hasPos(state.pos, 1) then state.pos + 1;
          state { pos: nextPos },

        hasItem(state):: hasPos(state.pos),
        getItem(state):: if hasPos(state.pos) then src[state.pos],
      },
  },

  factory(builder=primitive.builder):: {
    anyChar:: builder(char.anyChar),
    char(c):: builder(char.char(c)),
    oneOf(chars):: builder(char.oneOf(chars)),
    noneOf(chars):: builder(char.noneOf(chars)),
    sat(func):: builder(char.sat(func)),
    string(str):: builder(char.string(str)),

    // POSIX character classes

    alnum:: builder(char.alnum),
    alpha:: builder(char.alpha),
    ascii:: builder(char.ascii),
    blank:: builder(char.blank),
    cntrl:: builder(char.cntrl),
    digit:: builder(char.digit),
    graph:: builder(char.graph),
    lower:: builder(char.lower),
    print:: builder(char.print),
    punct:: builder(char.punct),
    space:: builder(char.space),
    upper:: builder(char.upper),
    word:: builder(char.word),
    xdigit:: builder(char.xdigit),
  },

  builder(initParser):: {
    parser:: initParser,
  },

  anyChar::
    self.sat(function(item) std.isString(item) && std.length(item) == 1),

  char(c)::
    assert std.isString(c) : 'c must be a string, got %s' % std.type(c);
    assert std.length(c) == 1 : 'c length must be equal to 1, got %d' % std.length(c);
    self.sat(function(item) item == c),

  oneOf(chars)::
    assert std.isString(chars) : 'chars must be a string, got %s' % std.type(chars);
    assert std.length(chars) > 0 : 'chars length must be greater than 0, got %d' % std.length(chars);
    self.sat(function(item) std.setMember(item, std.stringChars(chars))),

  noneOf(chars)::
    assert std.isString(chars) : 'chars must be a string, got %s' % std.type(chars);
    assert std.length(chars) > 0 : 'chars length must be greater than 0, got %d' % std.length(chars);
    self.sat(function(item) !std.setMember(item, std.stringChars(chars))),

  sat(func)::
    assert std.isFunction(func) : 'func must be a function, got %s' % std.type(func);
    function(state)
      local output = primitive.item(state);
      if util.isSuccess(output) then
        if func(util.outputValue(output)) then
          output
        else
          debug.traceIfDebug(
            state,
            "unexpected item '%s' found at %s" % [
              std.strReplace(state.reader().formatItem(util.outputValue(output)), "'", "\\'"),
              state.reader().formatState(state),
            ],
            model.output.new()
          )
      else
        output,

  string(str)::
    assert std.isString(str) : 'str must be a string, got %s' % std.type(str);
    assert std.length(str) >= 1 : 'str length must be greater than or equal to 1, got %d' % std.length(str);
    std.foldl(
      function(p, c) combinator.plus(p, self.char(c)),
      std.stringChars(util.tail(str)),
      self.char(util.head(str))
    ),

  // POSIX character classes

  alnum:: self.sat(self.isAlnum),
  alpha:: self.sat(self.isAlpha),
  ascii:: self.sat(self.isAscii),
  blank:: self.sat(self.isBlank),
  cntrl:: self.sat(self.isCntrl),
  digit:: self.sat(self.isDigit),
  graph:: self.sat(self.isGraph),
  lower:: self.sat(self.isLower),
  print:: self.sat(self.isPrint),
  punct:: self.sat(self.isPunct),
  space:: self.sat(self.isSpace),
  upper:: self.sat(self.isUpper),
  word:: self.sat(self.isWord),
  xdigit:: self.sat(self.isXdigit),

  local testCodepoint(func) = function(c) func(std.codepoint(c)),

  isAlnum(c):: testCodepoint(self.codepoint.isAlnum),
  isAlpha(c):: testCodepoint(self.codepoint.isAlpha),
  isAscii(c):: testCodepoint(self.codepoint.isAscii),
  isBlank(c):: testCodepoint(self.codepoint.isBlank),
  isCntrl(c):: testCodepoint(self.codepoint.isCntrl),
  isDigit(c):: testCodepoint(self.codepoint.isDigit),
  isGraph(c):: testCodepoint(self.codepoint.isGraph),
  isLower(c):: testCodepoint(self.codepoint.isLower),
  isPrint(c):: testCodepoint(self.codepoint.isPrint),
  isPunct(c):: testCodepoint(self.codepoint.isPunct),
  isSpace(c):: testCodepoint(self.codepoint.isSpace),
  isUpper(c):: testCodepoint(self.codepoint.isUpper),
  isWord(c):: testCodepoint(self.codepoint.isWord),
  isXdigit(c):: testCodepoint(self.codepoint.isXdigit),

  codepoint:: {
    isAlnum(cp):: self.isLower(cp)
                  || self.isUpper(cp)
                  || self.isDigit(cp),

    isAlpha(cp):: self.isLower(cp)
                  || self.isUpper(cp),

    isAscii(cp):: cp >= 0 && cp <= 127,

    isBlank(cp):: cp == 32
                  || cp == 9,

    isCntrl(cp):: cp >= 0 && cp <= 31
                  || cp == 127,

    isDigit(cp):: cp >= 48 && cp <= 57,

    isGraph(cp):: cp >= 33 && cp <= 126,

    isLower(cp):: cp >= 97 && cp <= 122,

    isPrint(cp):: cp >= 32 && cp <= 126,

    isPunct(cp):: cp == 33
                  || cp == 34
                  || cp == 35
                  || cp == 36
                  || cp == 37
                  || cp == 38
                  || cp == 39
                  || cp == 40
                  || cp == 41
                  || cp == 42
                  || cp == 43
                  || cp == 44
                  || cp == 45
                  || cp == 46
                  || cp == 47
                  || cp == 58
                  || cp == 59
                  || cp == 60
                  || cp == 61
                  || cp == 62
                  || cp == 63
                  || cp == 64
                  || cp == 91
                  || cp == 92
                  || cp == 93
                  || cp == 94
                  || cp == 95
                  || cp == 96
                  || cp == 123
                  || cp == 124
                  || cp == 125
                  || cp == 126,

    isSpace(cp):: cp == 32
                  || cp == 9
                  || cp == 13
                  || cp == 10
                  || cp == 11
                  || cp == 12,

    isUpper(cp):: cp >= 65 && cp <= 90,

    isWord(cp):: self.isUpper(cp)
                 || self.isLower(cp)
                 || self.isDigit(cp)
                 || cp == 95,

    isXdigit(cp):: cp >= 65 && cp <= 70
                   || cp >= 97 && cp <= 102
                   || self.isDigit(cp),
  },
}
