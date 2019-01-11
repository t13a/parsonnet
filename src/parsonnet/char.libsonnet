local posixchar = import 'posixchar.libsonnet';
local primitive = import 'primitive.libsonnet';
local state = import 'state.libsonnet';

{
  newState(src)::
    assert std.isString(src) : 'src must be a string, got %s' % std.type(src);
    state.newState(src, 0),

  local nextPosWithOffsetPos(input, offsetPos) =
    if hasTokenWithOffsetPos(input, offsetPos) then
      input.pos + offsetPos
    else
      null,

  local getTokenWithLength(input, length) =
    if hasTokenWithOffsetPos(input, length - 1) then
      input.src[input.pos:input.pos + length]
    else
      null,

  local hasTokenWithOffsetPos(input, offsetPos=0) =
    input.pos != null &&
    input.pos + offsetPos >= 0 &&
    input.pos + offsetPos < std.length(input.src),

  // Character

  sat(func)::
    assert std.isFunction(func) : 'func must be a function, got %s' % std.type(func);
    local nextPos(input) = nextPosWithOffsetPos(input, 1);
    local getToken(input) = getTokenWithLength(input, 1);
    local hasToken(input) = hasTokenWithOffsetPos(input, 0);
    primitive.item(nextPos, getToken, hasToken, func),

  anyChar::
    self.sat(function(token) true),

  char(char)::
    assert std.isString(char) : 'char must be a string, got %s' % std.type(char);
    assert std.length(char) == 1 : 'char length must be equal to 1, got %d' % std.length(char);
    self.sat(function(token) token == char),

  oneOf(chars)::
    assert std.isString(chars) : 'chars must be a string, got %s' % std.type(chars);
    assert std.length(chars) > 0 : 'chars length must be greater than 0, got %d' % std.length(chars);
    self.sat(function(token) std.setMember(token, std.stringChars(chars))),

  noneOf(chars)::
    assert std.isString(chars) : 'chars must be a string, got %s' % std.type(chars);
    assert std.length(chars) > 0 : 'chars length must be greater than 0, got %d' % std.length(chars);
    self.sat(function(token) !std.setMember(token, std.stringChars(chars))),

  // String

  string(str)::
    assert std.isString(str) : 'str must be a string, got %s' % std.type(str);
    assert std.length(str) >= 1 : 'str length must be greater than or equal to 1, got %d' % std.length(str);
    local nextPos(input) = nextPosWithOffsetPos(input, std.length(str));
    local getToken(input) = getTokenWithLength(input, std.length(str));
    local hasToken(input) = hasTokenWithOffsetPos(input, std.length(str) - 1);
    primitive.item(nextPos, getToken, hasToken, function(token) token == str),

  // POSIX character classes

  alnum:: self.sat(posixchar.isAlnum),
  alpha:: self.sat(posixchar.isAlpha),
  ascii:: self.sat(posixchar.isAscii),
  blank:: self.sat(posixchar.isBlank),
  cntrl:: self.sat(posixchar.isCntrl),
  digit:: self.sat(posixchar.isDigit),
  graph:: self.sat(posixchar.isGraph),
  lower:: self.sat(posixchar.isLower),
  print:: self.sat(posixchar.isPrint),
  punct:: self.sat(posixchar.isPunct),
  space:: self.sat(posixchar.isSpace),
  upper:: self.sat(posixchar.isUpper),
  word:: self.sat(posixchar.isWord),
  xdigit:: self.sat(posixchar.isXdigit),
}
