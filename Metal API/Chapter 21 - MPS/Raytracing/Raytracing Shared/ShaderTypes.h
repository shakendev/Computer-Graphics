#ifndef ShaderTypes_h
#define ShaderTypes_h

#include <simd/simd.h>

struct Camera {
  vector_float3 position;
  vector_float3 right;
  vector_float3 up;
  vector_float3 forward;
};

struct AreaLight {
  vector_float3 position;
  vector_float3 forward;
  vector_float3 right;
  vector_float3 up;
  vector_float3 color;
};

struct Uniforms
{
  unsigned int width;
  unsigned int height;
  unsigned int blocksWide;
  unsigned int frameIndex;
  struct Camera camera;
  struct AreaLight light;
};

#endif /* ShaderTypes_h */

