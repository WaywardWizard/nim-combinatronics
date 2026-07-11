# Permutations
Each permutation is generated with a swap. Once all permutations have been
generated we return to the original.

k: sequence length

k=1: A --> A (0 swaps)
  Base case, no swap, yield

k=2: AB --> AB (2 swaps)
  Fix first, recurse on tail with length k=1, swap first with last, recurse
  Swap first with last, recurse tail
  BA
  Swap first with last, recurse tail
  AB

  End result is the sequence is returned to its original order but right shifted

k=3: ABC --> ABC (6 swaps)
  Tail even. Swap first to last, recurse on tail.
  CBA
  CAB
  Tail even. Swap first to last, recurse on tail.
  BAC
  BCA
  Tail even. Swap first to last, recurse on tail.
  ACB
  ABC

  Tail recursion has two emissions. First element swapping occurs three times.
  Tail recursion applies one swap. Total six swaps.

  We could do it in 5 swaps, emit original, and use the first item
  ABC, ACB, BCA, BAC, CAB, CBA

  Drawback is that we dont return to original sequence so its harder to reason
  about. However this means less swaps which matters for our O(N!) algorithm.

  One approach is to recurse on the tail without any initial swaps. Then swap
  in the last with first ABC ACB BCA BAC CAB CBA. This completes with CBA, one
  further swap to the original ABC. For larger lengths

  | Length (k) | Start | Finish |
  | --  | -- | -- |
  | 3 | ABC | CBA |
  | 5 | ABCDE | EBCDA |

  This works, if we get first elements by starting with the first element, then
  swap in the second, third, fourth and so forth. For a sequence of length N
  where N is odd (k=3, k=5 etc), post recursion sequence will have its original
  order except with the first and last elements swapped. Because our first
  initial element is in place already we do not need to draw off N elements but
  N-1, thus the last element not being in the original order does not matter

  Our discussion below will assume we go with six swaps instead of five, to make
  tracking pre and post recursion easier.

k=4: ABCD --> DABC (
  Tail recursion will have six emissions, and return to its original
  Four entries to use as starting element. Pick entrys as follows;
    swap(0,0), recurse: (ABCD -> ABCD), note ABCD emitted at the end of recursion
    swap(0,1), recurse: (BACD -> BACD)
    swap(0,2), recurse: (CABD -> CABD)
    swap(0,3), recurse: (DABC -> DABC)

  Note that no emission occurs after the positioning of the first element. Note
  that the sequence now has all elements shifted right one place

k=5: ABCDE --> ABCDE
  Tail recursion will have 24 emissions, and right shift all elements. We can
  draw the last element each recursion to get a new element we have not used in
  position zero.
    swap(0,^1), recurse: (ABCDE -> AEBCD), note ABCDE emitted as part of recurse
    swap(0,^1), recurse: (DEBCA -> DAEBC)
    swap(0,^1), recurse: (CAEBD -> CDAEB)
    swap(0,^1), recurse: (BDAEC -> BCDAE)
    swap(0,^1), recurse: (ECDAB -> EBCDA)

  And we can get the original by swapping the first to last EBCDA -> ABCDE

k=6: ABCDEF --> FABCDE
  The tail will have k=5, we need to draw the first element from the sequence
  left to right
    swap(0,0), recurse: (ABCDEF, ABCDEF)
    swap(0,1), recurse: (BACDEF, BACDEF)
    swap(0,2), recurse: (CABDEF, CABDEF)
    swap(0,3), recurse: (DABCEF, DABCEF)
    swap(0,4), recurse: (EABCDF, EABCDF)
    swap(0,5), recurse: (FABCDE, FABCDE)

ABC
---
ACB   CBA
BCA   CAB
BAC   BAC
CAB   BCA
CBA   ACB
ABC   ABC


## Algorithm
Base case of length 1, yield as is. Of length 2, yield, swap first and last,
yield.

For length 3, ABC, once operated on will finish as CBA. Original order is
preserved, but the first and last elements are swapped. Permutations are;
ABC ACB BCA BAC CAB CBA

The tail is length two, an even length, so we can draw the first element from
the last place post tail recursion. Tail recursion operates on the trailing two
elements.

For length 4, ABCD, the tail is length 3. The tail, when recursed on, will finish
with the original order but first and last elements swapped. To get all elements
in the 0th position, recurse for element currently in 0th, then swap 0,1, recurse
0,2 recurse, 0,3 recurse.

### k=1 Base Case
A

### k=2 Right shift, single swap
AB
BA

### k=3 Swap first with last, tail right shifts on recursion
ABC ACB BCA BAC CAB CBA

### k=4 Right shift, tail has swap(1,^1) on recursion
We swap(0,0), swap(0,1), ... swap(0,3) for our first element
ABCD ADCB DACB DBCA CBDA CADB BADC BCDA

### k=5 Swap first with last, tail has right shift on recursion
ABCDE ACDEB BCDEA BDEAC CDEAB CEABD DEABC DABCE EABCD EBCDA

### k=6 Recurse, swap(0,1), recurse, swap(0,2), recurse .., swap(0,^1), recurse
ABCDEF AFCDEB   FACDEB FBCDEA   CBFDEA CAFDEB   DAFCEB DBFCEA   EBFCDA EAFCDB
BAFCDE BEFCDA

123456 -> 256341
rec1             rec2      rec3      rec4      rec5      rec6      rec7
ABCDEF -> BEFCDA -> EDAFCB -> DCBAFE -> CFEBAD -> FADEBC -> ABCDEF -> BEFCDA
For a sequence of length 7, we recurs on the tail seven times, 

For an even length sequence with an odd length tail recursion will swap, for an
zero indexed array, elements at indices 1,^1 per recursion. The algorithm recurses,
draws index 1, recurses, draws index 2.... draw index ^1,  recurse. Here N 
recursions are required. After the first recursion and draw the originally 0th is
at index 1, and originally ^1th is at index 0, and 1 is at index ^1:  ABCDEF,
recurse AFCDEB draw FACDEB. The final draw should be the original element at 
index 1.

After the first recursion and draw, There are N-1 recursions for algorithm completion, and N-2 until the remaining until the final draw, from position ^1. An even  number, since each recursion does swap(1,^1), this leaves the originally 1 at ^1  where we need it - the originally 0 at 1. In this way the algorithm works without fully returning odd length tails to their original on recursion.

Note that recursion on an even length array does not bring it back to its original sequence, and does not right shift it. However, drawing the first element in the way given does produce a unique first element every draw.


# Combinations
Combinations of a set *S* are order independant subsets *C* of *S*. C* sizes can range from 0 .. card(*S*)

Input {A, B, C, D, E, F}
case 0 -> {}
case 1 -> {A}, {B], {C}, ...
case 2 -> 
  fix A, AB, AC, AD, AE, AF
  fix B, BC, BD, BE, BF
  fix C, CD, CE, CF
  fix D, DE, DF
  fix E, EF
case 3 -> N-1 fixings, 
  fix A, generate combinations for {B, C, ....} of length two
         ABC, ABD, ABE, ABF,  ACD, ACE, ACF,   ADE, ADF, AEF
  fix B, generate combinations for {C, ....} of length two. Exclude with A, B
         BCD, BCE, BCF,       BDE, BDF,        BEF
  fix C, " " " " {D, ....}. Exclude A, B, C
         CDE, CDF,            CEF
  fix D, DEF
case 4
  ABCD, ABCE, ABCF, ABDE, ABDF, ABEF, ACDE, ACDF, ACEF, ADEF
  BCDE, BCDF, BCEF, BDEF
  CDEF
case 5
  ABCDE, ABCDF, ABCEF, ABDEF, ACDEF
  BCDEF
case 6
  ABCDEF

## Algorithm
Assume zero based indexing

P(E, n): Combinations of size n made of elements of E.
P(E, 0) = yield {}
P(E, n+1) = for k in 0..len(E)-(n)-1:
              for all x in P(E[k+1..], n)}:
                yield {E[k]} union x
                
Note that all possible combinations including the kth element are found before
fixing the k+1th element. Therefore the subcombinations the k+1th element is
combined with do not need to include any elements before the fixed one
