local primitive = import 'primitive.libsonnet';

{
  local hasPos(src, pos) = pos >= 0 && pos < std.length(src),

  anyChar::
    self.satisfy(function(token) true),

  char(str)::
    self.satisfy(function(token) token == str),

  satisfy(testTokenFunc)::
    local nextPos(src, pos, token) = if pos != null && hasPos(src, pos + 1) then pos + 1;
    local getToken(src, pos) = if pos != null && hasPos(src, pos) then src[pos];
    primitive.item(nextPos, getToken, testTokenFunc),

  string(str)::
    local sz = std.length(str);
    local nextPos(src, pos, token) = if pos != null && hasPos(src, pos + sz) then pos + sz;
    local getToken(src, pos) = if pos != null && hasPos(src, pos + sz - 1) then src[pos:pos + sz];
    primitive.item(nextPos, getToken, function(token) token == str),
}
