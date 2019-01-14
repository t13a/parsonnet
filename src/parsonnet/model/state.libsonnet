{
  new(input)::
    local initPos = input.initPos();
    {
      pos: initPos,

      input():: input,
      next()::
        local nextPos = self.input().nextPos(self.pos);
        self { pos: nextPos },
    },
}
