import MetalKit

protocol Texturable {}

extension Texturable {
  static func loadTexture(imageName: String) throws -> MTLTexture? {
    let textureLoader = MTKTextureLoader(device: Renderer.device)
    
    let textureLoaderOptions: [MTKTextureLoader.Option: Any] =
      [.origin: MTKTextureLoader.Origin.bottomLeft,
       .SRGB: false,
       .generateMipmaps: NSNumber(booleanLiteral: true)]
    let fileExtension =
      URL(fileURLWithPath: imageName).pathExtension.isEmpty ?
        "png" : nil
    guard let url = Bundle.main.url(forResource: imageName,
                                    withExtension: fileExtension)
      else {
        let texture = try? textureLoader.newTexture(name: imageName,
                                        scaleFactor: 1.0,
                                        bundle: Bundle.main, options: nil)
        if texture != nil {
          print("loaded: \(imageName) from asset catalog")
        } else {
          print("Texture not found: \(imageName)")
        }
        return texture
    }
    
    let texture = try textureLoader.newTexture(URL: url,
                                               options: textureLoaderOptions)
    print("loaded texture: \(url.lastPathComponent)")
    return texture
  }
}
