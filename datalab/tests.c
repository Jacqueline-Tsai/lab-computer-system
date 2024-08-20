/* Testing Code */

#include <limits.h>
#include <math.h>

/* Routines used by floation point test code */

/* Convert from bit level representation to floating point number */
float u2f(unsigned u) {
    union {
        unsigned u;
        float f;
    } a;
    a.u = u;
    return a.f;
}

/* Convert from floating point number to bit-level representation */
unsigned f2u(float f) {
    union {
        unsigned u;
        float f;
    } a;
    a.f = f;
    return a.u;
}
//2
long test_implication(long x, long y)
{
  return !(x && (!y));
}
long test_dividePower2(long x, long n)
{
    long p2n = 1L<<n;
    return x/p2n;
}
long test_anyOddBit(long x) {
  int i;
  for (i = 1; i < 64; i+=2)
      if (x & (1L<<i))
          return 1L;
  return 0L;
}
long test_byteSwap(long x, long n, long m)
{
    unsigned long bytemask = 0L;
    unsigned long nmask, mmask;
    switch(n) {
    case 0:
        bytemask = 0xFFUL;
        break;
    case 1:
        bytemask = 0xFF00UL;
        break;
    case 2:
        bytemask = 0xFF0000UL;
        break;
    case 3:
        bytemask = 0xFF000000UL;
        break;
    case 4:
        bytemask = 0xFF00000000UL;
        break;
    case 5:
        bytemask = 0xFF0000000000UL;
        break;
    case 6:
        bytemask = 0xFF000000000000UL;
        break;
    case 7:
        bytemask = 0xFF00000000000000UL;
        break;
    }
    nmask = x & bytemask;
    nmask >>= 8*n;
    x &= (~bytemask);
    switch(m) {
    case 0:
        bytemask = 0xFFUL;
        break;
    case 1:
        bytemask = 0xFF00UL;
        break;
    case 2:
        bytemask = 0xFF0000UL;
        break;
    case 3:
        bytemask = 0xFF000000UL;
        break;
    case 4:
        bytemask = 0xFF00000000UL;
        break;
    case 5:
        bytemask = 0xFF0000000000UL;
        break;
    case 6:
        bytemask = 0xFF000000000000UL;
        break;
    case 7:
        bytemask = 0xFF00000000000000UL;
        break;
    }
    mmask = x & bytemask;
    mmask >>= 8*m;
    x &= (~bytemask);
    nmask <<= 8*m;
    mmask <<= 8*n;
    return x | nmask | mmask;
}
//3
long test_addOK(long x, long y)
{
    /* Use 128-bit arithmetic to check */
    __int128 lsum = (__int128) x + y;
    return (long) (lsum == (long) lsum);
}
long test_logicalShift(long x, long n) {
  unsigned long u = (unsigned long) x;
  unsigned long shifted = u >> n;
  return (long) shifted;
}
long test_conditional(long x, long y, long z)
{
  return x?y:z;
}
long test_remainderPower2(long x, long n)
{
    long p2n = 1L<<n;
    return x%p2n;
}
//4
long test_isNonZero(long x)
{
  return x!=0;
}
long test_trueFiveEighths(long x)
{
  return (long) (((__int128) x * 5)/8);
}
long test_isPalindrome(long x) {
    long result = 1L;
    int i;
    long mask = 0xFFFFFFFFL;
    long xlo = x & mask;
    long xhi = (x >> 32) & mask;
    for (i = 0; i < 32; i++) {
        int flipi = 31-i;
        long bhigh = (xhi >> i) & 0x1L;
        long blow = (xlo >> flipi) & 0x1L;
        result = result && (long) (bhigh == blow);
    }
    return result;
}
