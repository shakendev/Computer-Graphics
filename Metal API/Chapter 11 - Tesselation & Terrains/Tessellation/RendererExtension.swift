import MetalKit

extension Renderer {
  public func rotateUsing(translation: float2) {
    let sensitivity: Float = 0.01
    rotation.x += Float(translation.y) * sensitivity
    rotation.z -= Float(translation.x) * sensitivity
  }
  
  public func zoomUsing(delta: CGFloat, sensitivity: Float) {
    position.z += Float(delta) * sensitivity
  }
  
  static func loadTexture(imageName: String) throws -> MTLTexture {
    let textureLoader = MTKTextureLoader(device: Renderer.device)
    return try textureLoader.newTexture(name: imageName, scaleFactor: 1.0,
                                        bundle: Bundle.main, options: nil)
  }
}
