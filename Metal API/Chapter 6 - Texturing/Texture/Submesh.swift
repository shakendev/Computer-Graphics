import MetalKit

class Submesh {
  var mtkSubmesh: MTKSubmesh
  
  struct Textures {
    let baseColor: MTLTexture?
  }
  
  let textures: Textures
  
  init(mdlSubmesh: MDLSubmesh, mtkSubmesh: MTKSubmesh) {
    self.mtkSubmesh = mtkSubmesh
    textures = Textures(material: mdlSubmesh.material)
  }
}

extension Submesh: Texturable {}

private extension Submesh.Textures {
  init(material: MDLMaterial?) {
    func property(with semantic: MDLMaterialSemantic) -> MTLTexture? {
      guard let property = material?.property(with: semantic),
        property.type == .string,
        let filename = property.stringValue,
        let texture = try? Submesh.loadTexture(imageName: filename)
        else {
          return nil
      }
      return texture
    }
    baseColor = property(with: MDLMaterialSemantic.baseColor)
  }
}
