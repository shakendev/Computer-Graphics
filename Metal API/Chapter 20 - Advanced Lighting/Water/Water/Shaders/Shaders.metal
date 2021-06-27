#include <metal_stdlib>
using namespace metal;
#import "Common.h"

struct VertexIn {
  float4 position [[ attribute(0) ]];
  float3 normal [[ attribute(1) ]];
  float2 uv [[ attribute(2) ]];
};

struct VertexOut {
  float4 position [[ position ]];
  float3 worldNormal;
  float3 worldPosition;
  float2 uv;
  float clip_distance [[ clip_distance ]] [1];
};

struct FragmentIn {
  float4 position [[ position ]];
  float3 worldNormal;
  float3 worldPosition;
  float2 uv;
  float clip_distance;
};

vertex VertexOut vertex_main(const VertexIn vertex_in [[ stage_in ]],
                             constant Uniforms &uniforms [[ buffer(BufferIndexUniforms) ]]) {
  VertexOut vertex_out;
  float4x4 mvp = uniforms.projectionMatrix * uniforms.viewMatrix * uniforms.modelMatrix;
  vertex_out.position = mvp * vertex_in.position;
  vertex_out.worldNormal = uniforms.normalMatrix * vertex_in.normal;
  vertex_out.uv = vertex_in.uv;
  vertex_out.worldPosition = (uniforms.modelMatrix *
                              vertex_in.position).xyz;
  vertex_out.clip_distance[0] = dot(uniforms.modelMatrix *
                                    vertex_in.position,
                                    uniforms.clipPlane);
  return vertex_out;
}

fragment float4 fragment_main(FragmentIn vertex_in [[ stage_in ]],
                              texture2d<float> texture [[ texture(0) ]]) {
  constexpr sampler default_sampler(filter::linear, address::repeat);
  float4 color = texture.sample(default_sampler, vertex_in.uv);
  float3 normal = normalize(vertex_in.worldNormal);
  float3 lightDirection = normalize(sunlight);
  float diffuseIntensity = saturate(dot(lightDirection, normal));
  color *= diffuseIntensity;
  return color;
}


fragment float4 fragment_terrain(FragmentIn vertex_in [[ stage_in ]],
                                 texture2d<float> texture [[ texture(0) ]],
                                 texture2d<float> underwaterTexture [[ texture(1) ]]) {
  constexpr sampler default_sampler(filter::linear, address::repeat);
  float4 color;
  float4 grass = texture.sample(default_sampler, vertex_in.uv * tiling);
  color = grass;

  float4 underwater = underwaterTexture.sample(default_sampler,
                                               vertex_in.uv * tiling);
  float lower = -0.3;
  float upper = 0.2;
  float y = vertex_in.worldPosition.y;
  float waterHeight = (upper - y) / (upper - lower);
  vertex_in.worldPosition.y < lower ?
  (color = underwater) :
  (vertex_in.worldPosition.y > upper ?
   (color = grass) :
   (color = mix(grass, underwater, waterHeight))
   );
  
  float3 normal = normalize(vertex_in.worldNormal);
  float3 lightDirection = normalize(sunlight);
  float diffuseIntensity = saturate(dot(lightDirection, normal));
  color *= diffuseIntensity;
  return color;
}
