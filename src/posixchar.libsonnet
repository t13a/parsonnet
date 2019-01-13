{
  local testCodepoint(func) = function(c) func(std.codepoint(c)),

  isAlnum(c):: testCodepoint(self.codepoint.isAlnum),
  isAlpha(c):: testCodepoint(self.codepoint.isAlpha),
  isAscii(c):: testCodepoint(self.codepoint.isAscii),
  isBlank(c):: testCodepoint(self.codepoint.isBlank),
  isCntrl(c):: testCodepoint(self.codepoint.isCntrl),
  isDigit(c):: testCodepoint(self.codepoint.isDigit),
  isGraph(c):: testCodepoint(self.codepoint.isGraph),
  isLower(c):: testCodepoint(self.codepoint.isLower),
  isPrint(c):: testCodepoint(self.codepoint.isPrint),
  isPunct(c):: testCodepoint(self.codepoint.isPunct),
  isSpace(c):: testCodepoint(self.codepoint.isSpace),
  isUpper(c):: testCodepoint(self.codepoint.isUpper),
  isWord(c):: testCodepoint(self.codepoint.isWord),
  isXdigit(c):: testCodepoint(self.codepoint.isXdigit),

  codepoint:: {
    isAlnum(cp):: self.isLower(cp)
                  || self.isUpper(cp)
                  || self.isDigit(cp),

    isAlpha(cp):: self.isLower(cp)
                  || self.isUpper(cp),

    isAscii(cp):: cp >= 0 && cp <= 127,

    isBlank(cp):: cp == 32
                  || cp == 9,

    isCntrl(cp):: cp >= 0 && cp <= 31
                  || cp == 127,

    isDigit(cp):: cp >= 48 && cp <= 57,

    isGraph(cp):: cp >= 33 && cp <= 126,

    isLower(cp):: cp >= 97 && cp <= 122,

    isPrint(cp):: cp >= 32 && cp <= 126,

    isPunct(cp):: cp == 33
                  || cp == 34
                  || cp == 35
                  || cp == 36
                  || cp == 37
                  || cp == 38
                  || cp == 39
                  || cp == 40
                  || cp == 41
                  || cp == 42
                  || cp == 43
                  || cp == 44
                  || cp == 45
                  || cp == 46
                  || cp == 47
                  || cp == 58
                  || cp == 59
                  || cp == 60
                  || cp == 61
                  || cp == 62
                  || cp == 63
                  || cp == 64
                  || cp == 91
                  || cp == 92
                  || cp == 93
                  || cp == 94
                  || cp == 95
                  || cp == 96
                  || cp == 123
                  || cp == 124
                  || cp == 125
                  || cp == 126,

    isSpace(cp):: cp == 32
                  || cp == 9
                  || cp == 13
                  || cp == 10
                  || cp == 11
                  || cp == 12,

    isUpper(cp):: cp >= 65 && cp <= 90,

    isWord(cp):: self.isUpper(cp)
                 || self.isLower(cp)
                 || self.isDigit(cp)
                 || cp == 95,

    isXdigit(cp):: cp >= 65 && cp <= 70
                   || cp >= 97 && cp <= 102
                   || self.isDigit(cp),
  },
}
