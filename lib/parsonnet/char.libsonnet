local primitive = import 'primitive.libsonnet';

{
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

  anyChar::
    self.sat(function(token) true),

  char(char)::
    assert std.isString(char) : 'char must be a string, got %s' % std.type(char);
    assert std.length(char) == 1 : 'char length must be equal to 1, got %d' % std.length(char);
    self.sat(function(token) token == char),

  sat(testTokenFunc)::
    local nextPos(input) = nextPosWithOffsetPos(input, 1);
    local getToken(input) = getTokenWithLength(input, 1);
    local hasToken(input) = hasTokenWithOffsetPos(input, 0);
    primitive.item(nextPos, getToken, hasToken, testTokenFunc),

  string(str)::
    assert std.isString(str) : 'str must be a string, got %s' % std.type(str);
    assert std.length(str) >= 1 : 'str length must be greater than or equal to 1, got %d' % std.length(str);
    local nextPos(input) = nextPosWithOffsetPos(input, std.length(str));
    local getToken(input) = getTokenWithLength(input, std.length(str));
    local hasToken(input) = hasTokenWithOffsetPos(input, std.length(str) - 1);
    primitive.item(nextPos, getToken, hasToken, function(token) token == str),
}
