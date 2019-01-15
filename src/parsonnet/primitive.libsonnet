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
      if state.reader().hasItem(state) then
        local x = state.reader().getItem(state);
        local xs = state.next();
        model.writer.new(model.result.new(x, xs))
      else
        debug.traceIfDebug(
          state,
          'item not found at %s' % state.reader().formatState(state),
          model.writer.new()
        ),

  // result  :: a -> Parser a
  // result v = \inp -> [(v,inp)]
  result(value)::
    function(state)
      model.writer.new(model.result.new(value, state)),

  // zero :: Parser a
  // zero  = \inp -> []
  zero::
    function(state)
      model.writer.new(),
}
