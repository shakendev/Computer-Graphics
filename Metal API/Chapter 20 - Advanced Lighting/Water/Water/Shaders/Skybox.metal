#include <metal_stdlib>
using namespace metal;
#import "Common.h"

struct VertexIn {
  float4 position [[ attribute(0) ]];
};

struct VertexOut {
  float4 position [[ position ]];
  float4 uv;
  float clip_distance [[ clip_distance ]] [1];
};

struct FragmentIn {
  float4 position [[ position ]];
  float4 uv;
  float clip_distance;
};

vertex VertexOut vertex_skybox(const VertexIn vertex_in [[stage_in]],
                               constant Uniforms &uniforms [[ buffer(BufferIndexUniforms) ]]) {
  VertexOut vertex_out;
  float4x4 mvp = uniforms.projectionMatrix * uniforms.skyboxViewMatrix * uniforms.modelMatrix;
  vertex_out.position = (mvp * vertex_in.position).xyww;
  vertex_out.uv = vertex_in.position;
  vertex_out.clip_distance[0] = dot(uniforms.modelMatrix *
                                    vertex_in.position,
                                    uniforms.clipPlane);
  return vertex_out;
}

fragment half4 fragment_skybox(FragmentIn vertex_in [[stage_in]],
                               texturecube<half> cube_texture [[texture(0)]]) {
  constexpr sampler default_sampler;
  float3 uv = vertex_in.uv.xyz;
  half4 color = cube_texture.sample(default_sampler, uv);
  return color;
}
