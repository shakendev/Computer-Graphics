import MetalKit

class Camera {
  var aspect: Float = 1
  var fov: Float = Float(60).degreesToRadians

  var projectionMatrix: float4x4 {
    return float4x4(projectionFov: fov,
                    near: Float(near),
                    far: Float(far),
                    aspect: aspect)
  }
  
  init() {}
  
  init(near: Float = Float(near), far: Float = Float(far), aspect: Float, fov: Float = 1.135) {
    self.aspect = aspect
    self.fov = fov
  }
  
  var minY: Float = 0.2

  var viewMatrix = float4x4.identity()
  var transform = Transform() {
    didSet {
      let translateMatrix = float4x4(translation: [-transform.position.x,
                                                   -transform.position.y,
                                                   -transform.position.z])
      let rotateMatrix = float4x4(rotation: transform.rotation)
      viewMatrix =  rotateMatrix * translateMatrix
    }
  }
}
