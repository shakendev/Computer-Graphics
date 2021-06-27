import MetalKit

extension Renderer {
  func zoomUsing(delta: CGFloat, sensitivity: Float) {
    camera.position.z += Float(delta) * sensitivity
  }
  
  func rotateUsing(translation: float2) {
    let sensitivity: Float = 0.01
    camera.rotation.x += Float(translation.y) * sensitivity
    camera.rotation.y -= Float(translation.x) * sensitivity
  }
  
}
