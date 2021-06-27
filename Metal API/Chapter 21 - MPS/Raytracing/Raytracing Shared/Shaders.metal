#include <metal_stdlib>
#include <simd/simd.h>
#import "ShaderTypes.h"

using namespace metal;

struct Vertex {
  float4 position [[position]];
  float2 uv;
};

constant float2 quadVertices[] = {
  float2(-1, -1),
  float2(-1,  1),
  float2( 1,  1),
  float2(-1, -1),
  float2( 1,  1),
  float2( 1, -1)
};

vertex Vertex vertexShader(unsigned short vid [[vertex_id]])
{
  float2 position = quadVertices[vid];
  Vertex out;
  out.position = float4(position, 0, 1);
  out.uv = position * 0.5 + 0.5;
  return out;
}

fragment float4 fragmentShader(Vertex in [[stage_in]],
                               texture2d<float> tex)
{
  constexpr sampler s(min_filter::nearest,
                      mag_filter::nearest,
                      mip_filter::none);
  float3 color = tex.sample(s, in.uv).xyz;
  return float4(color, 1.0);
}

kernel void accumulateKernel(constant Uniforms & uniforms,
                             texture2d<float> renderTex,
                             texture2d<float, access::read_write> t,
                             uint2 tid [[thread_position_in_grid]])
{
  if (tid.x < uniforms.width && tid.y < uniforms.height) {
    float3 color = renderTex.read(tid).xyz;
    if (uniforms.frameIndex > 0) {
      float3 prevColor = t.read(tid).xyz;
      prevColor *= uniforms.frameIndex;
      color += prevColor;
      color /= (uniforms.frameIndex + 1);
    }
    t.write(float4(color, 1.0), tid);
  }
}
