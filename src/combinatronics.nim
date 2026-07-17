## .. importdoc:: algorithm.md
import sets, algorithm
var nswap: int
iterator permutor*(x: var seq, cursor: int = 0): lent seq {.closure.} =
  ## Generate all permutations of a sequence with one swap per mutation and return
  ## a view. 
  ## 
  ## The given sequence is mutated. Once the iterator completes the given
  ## sequence will be restored to its original permutation. If the iteration is
  ## interupted for example with break this will not be the case
  ## 
  ## Algorithm details: Permutations_
  ##
  ## This is N! complexity, and a recursion stack of depth N-1. OK as N is limited
  if cursor == 0:
    nswap = 0

  let
    N = len(x) - cursor # subsequence is the cursor element to end
    Neven = N mod 2 == 0
  case N
  of 1:
    yield x # A
  of 2: # AB, BC
    yield x # AB
    nswap += 1
    swap(x[cursor], x[cursor + 1])
    yield x # BA
  else: #recursion
    # Cycle permutations of tail, with seq[cursor] as the first element
    for _ in permutor(x, cursor + 1):
      yield x

    # Swap in next first element, recurse. Draw elements 1..(N-1) and recurse
    for first in 1 .. (N - 1): # element 0 processed above
      nswap += 1
      if Neven: # even length array, odd tail, remains in position on recurse
        # Odd tail is unchanging, get an unused element in first position
        swap(x[cursor], x[cursor + first])
      else: # odd length array, even tail, left shifts when recursed
        swap(x[cursor], x[^1])

      # recurse, left shifting even length tails, restoring odd
      for _ in permutor(x, cursor + 1):
        yield x

  # restore the original sequence
  if cursor == 0:
    defer:
      ## | Start | End | swap(0, cursor) | swap(0, N-1) |
      ## |------|-----|-----------------|--------------|
      ## | ABCD | BCDA | BADC | DABC |
      ## | ABCDEF |BEFCDA | BAFCDE | FABCDE |
      ## | ABCDEFG | BGHCDEFA | BAHCDEFG | HABCDEFG |
      ##
      ## Post the two swaps the sequence will need rotating left
      ##
      ## Note that rotating may be O(N), not ideal
      if Neven and N > 2: # right shift, counter left shift
        swap x[1], x[^1]
        swap x[0], x[2]
        x.rotateLeft 1
      else: # first last swap
        swap(x[0], x[^1])

iterator combinator*[T](x: openArray[T]): HashSet[T] =
  ## Generate all 2^N combinations of the given array
  ## 
  ## Algorithm details: Combinations_
  # key is the index of fixed element
  yield initHashSet[T]()

  var
    prevCache: seq[seq[HashSet[T]]]
    nextCache: seq[seq[HashSet[T]]]
    next: HashSet[T]

  for e in x: # one length case
    prevCache.add @[[e].toHashSet]
    yield prevCache[^1][^1]

  for npick in 2 .. x.len - 1: # two length to N-1 elements
    # fix an element
    for fixeex in 0 .. (x.len - npick):
      nextCache.add @[]
      for subcombinations in prevCache[fixeex + 1 .. prevCache.high]:
        for subcombination in subcombinations:
          next = subcombination
          next.incl x[fixeex]
          nextCache[^1].add next
          yield next
    prevCache = nextCache
    nextCache = @[]
