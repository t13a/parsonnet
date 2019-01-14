local model = import 'model.libsonnet';

{
  local primitive = self,
  local any(x) = true,

  factory(builder=primitive.builder):: {
    item(func=any):: builder(primitive.item(func)),
    result(out, err=[]):: builder(primitive.result(out, err)),
    zero(err=[]):: builder(primitive.zero(err)),
  },

  builder(initParser):: {
    apply:: initParser,
  }

  item(func=any)::
    function(state)
      if state.input().hasItem(state.pos) then
        local item = state.input().getItem(state.pos);
        if func(item) then
          model.success.new(model.output.new(item, state.next()))
        else
          model.failure.new(
            "unexpected item '%s' found at %s" % 
            [
              std.strReplace(state.input().formatItem(item), "'", "\\'"),
              state.input().formatPos(state.pos),
            ]
          )
      else
         model.failure.new('item not found at %s' % state.input().formatPos(state.pos)),

  apply(a, b)::
    null,

//   result(out, err=[])::
    // function(state)
      // model.success.new(out, err),
  result(value, err=[])::
    function(state)
      model.success.new(model.output.new(value, state), err),

  result(value, err=[])::
    function()
      value,

  result(value, err=[])::
    apply(
      function(state) model.success.new(model.output.new(value, state), err),
      function() value,
    ),

  zero(err=[])::
    function(state)
      model.failure.new(err),
}
