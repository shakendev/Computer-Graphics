#ifndef Common_h
#define Common_h
#import <simd/simd.h>

#define sunlight vector_float3(-2, 4, 4)
#define near 0.1
#define far 100.0
#define tiling 12.0

typedef struct {
  matrix_float4x4 modelMatrix;
  matrix_float4x4 viewMatrix;
  matrix_float4x4 projectionMatrix;
  matrix_float3x3 normalMatrix;
  matrix_float4x4 skyboxViewMatrix;
  vector_float4 clipPlane;
  vector_float3 cameraPosition;
} Uniforms;

typedef enum {
  BufferIndexVertices = 0,
  BufferIndexUniforms = 11
} BufferIndices;

#endif /* Common_h */
