#ifndef Common_h
#define Common_h

#import <simd/simd.h>

typedef struct {
  vector_float2 size;
  float height;
  uint maxTessellation;
} Terrain;

#endif /* Common_h */
