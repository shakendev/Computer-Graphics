import MetalKit

extension Renderer {
  func zoomUsing(delta: CGFloat) {
    let sensitivity = Float(0.1)
    let result = camera.transform.position.y + Float(delta) * sensitivity
    if result > camera.minY {
      camera.transform.position.y = result
    }
  }
  
  func rotateUsing(translation: float2) {
    let sensitivity: Float = 0.01
    camera.transform.rotation.x += translation.y * sensitivity
    camera.transform.rotation.y -= translation.x * sensitivity
  }

}

extension Renderer {
  static func loadTexture(imageName: String) throws -> MTLTexture {
    let textureLoader = MTKTextureLoader(device: Renderer.device)
    let textureLoaderOptions: [MTKTextureLoader.Option: Any] =
      [.origin: MTKTextureLoader.Origin.bottomLeft,
       .SRGB: false,
       .generateMipmaps: NSNumber(booleanLiteral: false)]
    
    let fileExtension =
      URL(fileURLWithPath: imageName).pathExtension.isEmpty ?
        "png" : nil
    guard let url = Bundle.main.url(forResource: imageName,
                                    withExtension: fileExtension) else {
                                      fatalError("texture \(imageName) not found")
    }
    return try textureLoader.newTexture(URL: url,
                                        options: textureLoaderOptions)
  }

  func loadModel(name: String) -> MTKMesh {
    guard let assetURL = Bundle.main.url(forResource: name, withExtension: "obj")
      else { fatalError("Model not found") }
    
    let vertexDescriptor = MTLVertexDescriptor()
    
    var offset = 0
    vertexDescriptor.attributes[0].format = .float3
    vertexDescriptor.attributes[0].offset = 0
    vertexDescriptor.attributes[0].bufferIndex = 0
    offset += MemoryLayout<float3>.stride
    
    vertexDescriptor.attributes[1].format = .float3
    vertexDescriptor.attributes[1].offset = offset
    vertexDescriptor.attributes[1].bufferIndex = 0
    offset += MemoryLayout<float3>.stride
    
    vertexDescriptor.attributes[2].format = .float2
    vertexDescriptor.attributes[2].offset = offset
    vertexDescriptor.attributes[2].bufferIndex = 0
    offset += MemoryLayout<float3>.stride
    
    vertexDescriptor.layouts[0].stride = offset
    
    let descriptor = MTKModelIOVertexDescriptorFromMetal(vertexDescriptor)
    
    (descriptor.attributes[0] as! MDLVertexAttribute).name = MDLVertexAttributePosition
    (descriptor.attributes[1] as! MDLVertexAttribute).name = MDLVertexAttributeNormal
    (descriptor.attributes[2] as! MDLVertexAttribute).name = MDLVertexAttributeTextureCoordinate
    
    let bufferAllocator = MTKMeshBufferAllocator(device: Renderer.device)
    let asset = MDLAsset(url: assetURL,
                         vertexDescriptor: descriptor,
                         bufferAllocator: bufferAllocator)
    let mdlMesh = asset.object(at: 0) as! MDLMesh
    let mtkMesh: MTKMesh
    do {
      mtkMesh = try MTKMesh(mesh: mdlMesh, device: Renderer.device)
    } catch {
      fatalError(error.localizedDescription)
    }
    return mtkMesh
  }
  
  func loadSkyboxTexture() -> MTLTexture? {
    var texture: MTLTexture?
    let textureLoader = MTKTextureLoader(device: Renderer.device)
    if let mdlTexture = MDLTexture(cubeWithImagesNamed:
      ["posx.png", "negx.png", "posy.png", "negy.png", "posz.png", "negz.png"]) {
      do {
        texture = try textureLoader.newTexture(texture: mdlTexture, options: nil)
      } catch {
        print("no texture created")
      }
    } else {
      print("texture image not found")
    }
    return texture
  }
}

