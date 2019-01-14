local debug = import 'debug.libsonnet';
local model = import 'model.libsonnet';

{
  local primitive = self,
  local any(x) = true,

  factory(builder=primitive.builder):: {
    item:: builder(primitive.item),
    result(value):: builder(primitive.result(value)),
    zero:: builder(primitive.zero),
  },

  builder(initParser):: {
    parser:: initParser,
  },

  // item :: Parser Char
  // item  = \inp -> case inp of
  //                    []     -> []
  //                    (x:xs) -> [(x,xs)]
  item::
    function(state)
      if state.input().hasItem(state.pos) then
        local x = state.input().getItem(state.pos);
        local xs = state.next();
        model.output.new(model.result.new(x, xs))
      else
        debug.traceIfDebug(
          state,
          'item not found at %s' % state.input().formatPos(state.pos),
          model.output.new()
        ),

  // result  :: a -> Parser a
  // result v = \inp -> [(v,inp)]
  result(value)::
    function(state)
      model.output.new(model.result.new(value, state)),

  // zero :: Parser a
  // zero  = \inp -> []
  zero::
    function(state)
      model.output.new(),
}
