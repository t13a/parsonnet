{
  new(input):: {
    pos: self.input().initPos(),

    input():: input,
    next():: self { pos: self.input().nextPos(super.pos) },
  },
}
