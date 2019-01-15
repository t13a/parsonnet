local debug = import 'debug.libsonnet';
local model = import 'model.libsonnet';

{
  local primitive = self,
  local any(x) = true,

  factory:: {
    new(builder=primitive.builder):: {
      item:: builder(primitive.item),
      pure(results=[]):: builder(primitive.pure(results)),
      result(value=[]):: builder(primitive.result(value)),
      zero:: builder(primitive.zero),
    },
  },

  builder:: {
    new(initParser):: {
      parser:: initParser,
    },
  },

  // item :: Parser Char
  // item  = \inp -> case inp of
  //                    []     -> []
  //                    (x:xs) -> [(x,xs)]
  item::
    function(state)
      if state.input().hasItem(state) then
        model.output.new([model.result.new(state.input().getItem(state), state.next())])
      else
        debug.traceIfDebug(
          state,
          'item not found at %s' % state.input().formatState(state),
          model.output.new()
        ),

  pure(results=[])::
    function(state)
      model.output.new(results),

  // result  :: a -> Parser a
  // result v = \inp -> [(v,inp)]
  result(value=[])::
    function(state)
      model.output.new([model.result.new(value, state)]),

  // zero :: Parser a
  // zero  = \inp -> []
  zero::
    function(state)
      model.output.new(),
}
