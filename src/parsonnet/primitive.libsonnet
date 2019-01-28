local debug = import 'debug.libsonnet';
local model = import 'model.libsonnet';
local util = import 'util.libsonnet';

{
  local primitive = self,
  local any(x) = true,

  factory:: {
    new(mapFunc=primitive.builder)::
      local e = util.extract;
      util.factory(mapFunc) +
      {
        fail(msg):: self.__map(primitive.fail(msg)),
        item:: self.__map(primitive.item),
        pure(results=[]):: self.__map(primitive.pure(results)),
        result(value=[]):: self.__map(primitive.result(value)),
        zero:: self.__map(primitive.zero),
      },
  },

  builder:: {
    new(initParser):: util.builder(initParser),
  },

  fail(msg)::
    assert std.isString(msg) :
           'msg must be a string, got %s' % std.type(msg);
    function(state)
      debug.traceIfDebug(state, msg, model.output.new()),

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
