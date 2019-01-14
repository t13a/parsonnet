local combinator = import 'combinator.libsonnet';
local models = import 'models.libsonnet';
local primitive = import 'primitive.libsonnet';
local utils = import 'utils.libsonnet';

{
  newReader(src)::
    assert std.isString(src) : 'src must be a string, got %s' % std.type(src);
    models.newReader() + {
      initPos():: 0,
      nextPos(pos):: if pos != null && self.hasInp(pos + 1) then pos + 1,
      hasInp(pos):: pos != null && pos >= 0 && pos < std.length(src),
      getInp(pos):: if self.hasInp(pos) then src[pos],
    },

  // Character

  sat(func)::
    assert std.isFunction(func) : 'func must be a function, got %s' % std.type(func);
    primitive.item(func),

  anyChar::
    self.sat(function(inp) true),

  char(char)::
    assert std.isString(char) : 'char must be a string, got %s' % std.type(char);
    assert std.length(char) == 1 : 'char length must be equal to 1, got %d' % std.length(char);
    self.sat(function(inp) inp == char),

  oneOf(chars)::
    assert std.isString(chars) : 'chars must be a string, got %s' % std.type(chars);
    assert std.length(chars) > 0 : 'chars length must be greater than 0, got %d' % std.length(chars);
    self.sat(function(inp) std.setMember(inp, std.stringChars(chars))),

  noneOf(chars)::
    assert std.isString(chars) : 'chars must be a string, got %s' % std.type(chars);
    assert std.length(chars) > 0 : 'chars length must be greater than 0, got %d' % std.length(chars);
    self.sat(function(inp) !std.setMember(inp, std.stringChars(chars))),

  // String

  string(str)::
    assert std.isString(str) : 'str must be a string, got %s' % std.type(str);
    assert std.length(str) >= 1 : 'str length must be greater than or equal to 1, got %d' % std.length(str);
    std.foldl(
      function(p, c) combinator.seq(p, self.char(c)),
      std.stringChars(utils.tail(str)),
      self.char(utils.head(str))
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
