import unittest, sets, strutils, math, sequtils
import combinatronics

suite "Combinatronics":
  var aset: HashSet[string]
  setup:
    aset.clear()
  test "Complete permutation cycle restores original":
    # Odd length needs first and last element swapped.
    # Even length gets jumblod
    var word = "ABCDEFGHI"
    for ix in 0 .. (word.len - 1):
      var data = word[0 .. ix].toSeq
      let pre = data.join
      for _ in permutor(data):
        discard
      let post = data.join
      check pre == post

  test "Permutations":
    var word = "permutions"
    for ix in 0 .. len(word) - 1:
      var data = word[0 .. ix].toSeq
      for _ in permutor(data):
        aset.incl data.join(",")
      var nperm = fac data.len
      # echo "Word: $#\nPermutations: $#\nCount: $#\n" % [$data,$aset.card, $nperm]
      check aset.card == nperm
      aset.clear()

  test "Combinations":
    #                        0  1  15 (10,6,3)          14
    # Length of combinations 0, 6, (5+4+3+2+1), (5, 4, 3, 2), ()
    var combinations: HashSet[string]
    for e in ["A", "B", "C", "D", "E", "F"].combinator:
      combinations.incl e.toSeq.join("")
    check combinations.card == (2 ^ 6 - 1)
