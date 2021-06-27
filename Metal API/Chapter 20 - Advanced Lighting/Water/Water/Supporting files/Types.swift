import simd

struct Transform {
  var position: float3 = [0, 0, 0]
  var rotation: float3 = [0, 0, 0]
  var scale: float3 = [1, 1, 1]

  var matrix: float4x4 {
    let translateMatrix = float4x4(translation: position)
    let rotateMatrix = float4x4(rotation: rotation)
    let scaleMatrix = float4x4(scaling: scale)
    return rotateMatrix * scaleMatrix * translateMatrix
  }
  
  init() {}
}
