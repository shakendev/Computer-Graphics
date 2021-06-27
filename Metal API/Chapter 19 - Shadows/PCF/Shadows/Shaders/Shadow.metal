#include <metal_stdlib>
using namespace metal;

#import "../Utility/Common.h"

struct VertexIn {
  float4 position [[ attribute(0) ]];
};

vertex float4 vertex_depth(const VertexIn vertexIn [[ stage_in ]],
                           constant Uniforms &uniforms [[ buffer(1) ]]) {
  matrix_float4x4 mvp = uniforms.projectionMatrix * uniforms.viewMatrix * uniforms.modelMatrix;
  float4 position = mvp * vertexIn.position;
  return position;
}
