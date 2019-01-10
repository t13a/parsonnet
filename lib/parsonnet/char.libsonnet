local primitive = import 'primitive.libsonnet';

{
  local nextPosWithOffsetPos(input, offsetPos) =
    if hasToken(input, offsetPos) then
      input.pos + offsetPos
    else
      null,

  local getTokenWithLength(input, length) =
    if hasToken(input, length - 1) then
      input.src[input.pos:input.pos + length]
    else
      null,

  local hasToken(input, offsetPos=0) =
    input.pos != null &&
    input.pos + offsetPos >= 0 &&
    input.pos + offsetPos < std.length(input.src),

  anyChar::
    self.satisfy(function(token) true),

  char(char)::
    assert std.isString(char) : 'char must be a string, got %s' % std.type(char);
    assert std.length(char) == 1 : 'char length must be equal to 1, got %d' % std.length(char);
    self.satisfy(function(token) token == char),

  satisfy(testTokenFunc)::
    local nextPos(input) = nextPosWithOffsetPos(input, 1);
    local getToken(input) = getTokenWithLength(input, 1);
    primitive.item(nextPos, getToken, testTokenFunc),

  string(str)::
    assert std.isString(str) : 'str must be a string, got %s' % std.type(str);
    assert std.length(str) >= 1 : 'str length must be greater than or equal to 1, got %d' % std.length(str);
    local nextPos(input) = nextPosWithOffsetPos(input, std.length(str));
    local getToken(input) = getTokenWithLength(input, std.length(str));
    primitive.item(nextPos, getToken, function(token) token == str),
}
