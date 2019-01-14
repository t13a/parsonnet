local state = import 'state.libsonnet';

{
  new():: {
    initState():: state.new(self),

    initPos(pos):: error 'not implemented yet',
    nextPos(pos):: error 'not implemented yet',

    hasItem(pos):: error 'not implemented yet',
    getItem(pos):: error 'not implemented yet',

    formatPos(pos):: std.toString(pos),
    formatItem(item):: std.toString(item),
  },
}
