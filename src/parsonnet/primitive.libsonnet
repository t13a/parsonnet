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
      if state.reader().hasItem(state) then
        model.writer.new([model.result.new(state.reader().getItem(state), state.next())])
      else
        debug.traceIfDebug(
          state,
          'item not found at %s' % state.reader().formatState(state),
          model.writer.new()
        ),

  pure(results=[])::
    function(state)
      model.writer.new(results),

  // result  :: a -> Parser a
  // result v = \inp -> [(v,inp)]
  result(value=[])::
    function(state)
      model.writer.new([model.result.new(value, state)]),

  // zero :: Parser a
  // zero  = \inp -> []
  zero::
    function(state)
      model.writer.new(),
}
