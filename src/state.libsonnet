{
  newState(initInp):: {
    local state = self,

    inp: initInp,

    hasInp():: self.inp != null,
    setInp(inp):: self { inp: inp },

    success(out):: {
      out: out,
      remaining: state,

      isSuccess():: true,
    },

    failure(err):: {
      err: err,
      remaining: state,

      isSuccess():: false,
    },
  },
}
