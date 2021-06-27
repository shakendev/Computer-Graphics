#ifndef Common_h
#define Common_h

#import <simd/simd.h>

typedef matrix_float4x4 float4x4;
typedef matrix_float3x3 float3x3;
typedef vector_float2 float2;
typedef vector_float3 float3;
typedef vector_float4 float4;

typedef struct {
  float4x4 modelMatrix;
  float4x4 viewMatrix;
  float4x4 projectionMatrix;
  float3x3 normalMatrix;
  float4x4 shadowMatrix;
} Uniforms;

typedef struct {
  uint lightCount;
  float3 cameraPosition;
} FragmentUniforms;

typedef enum {
  unused = 0,
  Sunlight = 1,
  Spotlight = 2,
  Pointlight = 3,
  Ambientlight = 4
} LightType;

typedef struct {
  float3 position;
  float3 color;
  float3 specularColor;
  float intensity;
  float3 attenuation;
  LightType type;
  float coneAngle;
  float3 coneDirection;
  float coneAttenuation;
} Light;

typedef struct {
  float3 emissionColor;
  float3 baseColor;
  float3 specularColor;
  float shininess;
} Material;

#endif /* Common_h */
