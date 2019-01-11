local util = import 'util.libsonnet';

{
  newState(src, initPos)::
    assert src != null : 'src must not be null';
    assert initPos != null : 'initPos must not be null';
    {
      local state = self,

      input: {
        src: src,
        pos: initPos,
      },

      return: {
        out: null,
        err: null,

        success(out)::
          assert out != null : 'out must not be null';
          self { out: util.merge(super.out, out) },

        failure(err)::
          assert err != null : 'err must not be null';
          self { err: util.merge(super.err, err) },

        remaining():: state,
      },

      consume(pos)::
        if self.input.pos != pos then
          self { input+: { pos: pos } }
        else
          self,
    },
}
