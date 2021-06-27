import MetalKit

// ball animations
let ballPositionXArray: [Float] = [-1.0, -0.9, -0.8, -0.7, -0.6, -0.5, -0.4, -0.3, -0.2, -0.1,
                                   0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9,
                                   1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0,
                                   1.0, 0.9, 0.8, 0.7, 0.6, 0.5, 0.4, 0.3, 0.2, 0.1,
                                   0.0, -0.1, -0.2, -0.3, -0.4, -0.5, -0.6, -0.7, -0.8, -0.9,
                                   -1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0]


 func generateBallTranslations() -> [Keyframe] {
   return [
     Keyframe(time: 0,    value: [-1, 0, 0]),
     Keyframe(time: 0.17, value: [ 0, 1, 0]),
     Keyframe(time: 0.35, value: [ 1, 0, 0]),
     Keyframe(time: 1.0,  value: [ 1, 0, 0]),
     Keyframe(time: 1.17, value: [ 0, 1, 0]),
     Keyframe(time: 1.35, value: [-1, 0, 0]),
     Keyframe(time: 2,    value: [-1, 0, 0])
   ]
 }


func generateBallRotations() -> [KeyQuaternion] {
  return [
    KeyQuaternion(time: 0,    value: simd_quatf(ix: 0, iy: 0, iz: 0, r: 1)),
    KeyQuaternion(time: 0.08, value: simd_quatf(angle: .pi/2, axis: [0, 0, -1])),
    KeyQuaternion(time: 0.17, value: simd_quatf(angle: .pi, axis: [0, 0, -1])),
    KeyQuaternion(time: 0.26, value: simd_quatf(angle: .pi + .pi/2, axis: [0, 0, -1])),
    KeyQuaternion(time: 0.35, value: simd_quatf(angle: 0, axis: [0, 0, -1])),
    KeyQuaternion(time: 1.0,  value: simd_quatf(angle: 0, axis: [0, 0, -1])),
    KeyQuaternion(time: 1.08, value: simd_quatf(angle: .pi + .pi/2, axis: [0, 0, -1])),
    KeyQuaternion(time: 1.17, value: simd_quatf(angle: .pi, axis: [0, 0, -1])),
    KeyQuaternion(time: 1.26, value: simd_quatf(angle: .pi/2, axis: [0, 0, -1])),
    KeyQuaternion(time: 1.35, value: simd_quatf(ix: 0, iy: 0, iz: 0, r: 1)),
    KeyQuaternion(time: 2,    value: simd_quatf(ix: 0, iy: 0, iz: 0, r: 1))
  ]
}

