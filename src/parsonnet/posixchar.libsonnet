{
  local isChar(func) = function(char) func(std.codepoint(char)),

  isAlnum(c):: isChar(codepoint.isAlnum),
  isAlpha(c):: isChar(codepoint.isAlpha),
  isAscii(c):: isChar(codepoint.isAscii),
  isBlank(c):: isChar(codepoint.isBlank),
  isCntrl(c):: isChar(codepoint.isCntrl),
  isDigit(c):: isChar(codepoint.isDigit),
  isGraph(c):: isChar(codepoint.isGraph),
  isLower(c):: isChar(codepoint.isLower),
  isPrint(c):: isChar(codepoint.isPrint),
  isPunct(c):: isChar(codepoint.isPunct),
  isSpace(c):: isChar(codepoint.isSpace),
  isUpper(c):: isChar(codepoint.isUpper),
  isWord(c):: isChar(codepoint.isWord),
  isXdigit(c):: isChar(codepoint.isXdigit),

  codepoint:: {

    // Prime

    isAscii(cp):: cp >= 0 && cp <= 127,
    isBlank(cp):: cp == 32 ||
                  cp == 9,
    isCntrl(cp):: cp >= 0 && cp <= 31 ||
                  cp == 127,
    isDigit(cp):: cp >= 48 && cp <= 57,
    isGraph(cp):: cp >= 33 && cp <= 126,
    isLower(cp):: cp >= 97 && cp <= 122,
    isPunct(cp):: cp == 33 ||
                  cp == 34 ||
                  cp == 35 ||
                  cp == 36 ||
                  cp == 37 ||
                  cp == 38 ||
                  cp == 39 ||
                  cp == 40 ||
                  cp == 41 ||
                  cp == 42 ||
                  cp == 43 ||
                  cp == 44 ||
                  cp == 45 ||
                  cp == 46 ||
                  cp == 47 ||
                  cp == 58 ||
                  cp == 59 ||
                  cp == 60 ||
                  cp == 61 ||
                  cp == 62 ||
                  cp == 63 ||
                  cp == 64 ||
                  cp == 91 ||
                  cp == 92 ||
                  cp == 93 ||
                  cp == 94 ||
                  cp == 95 ||
                  cp == 96 ||
                  cp == 123 ||
                  cp == 124 ||
                  cp == 125 ||
                  cp == 126,
    isPrint(cp):: cp >= 32 && cp <= 126,
    isSpace(cp):: cp == 32 ||
                  cp == 9 ||
                  cp == 13 ||
                  cp == 10 ||
                  cp == 11 ||
                  cp == 12,
    isUpper(cp):: cp >= 65 && cp <= 90,

    // Complex

    isAlnum(cp):: isLower(cp) || isUpper(cp) || isDigit(cp),
    isAlpha(cp):: isLower(cp) || isUpper(cp),
    isWord(cp):: isUpper(cp) || isLower(cp) || isDigit(cp) || cp == 95,
    isXdigit(cp):: cp >= 65 && cp <= 70 ||
                   cp >= 97 && cp <= 102 ||
                   isDigit(cp),
  },
}
