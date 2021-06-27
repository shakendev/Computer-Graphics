import MetalKit

class Model: Node {
  
  let meshes: [Mesh]
  var tiling: UInt32 = 1
  let samplerState: MTLSamplerState?
  static var vertexDescriptor: MDLVertexDescriptor = MDLVertexDescriptor.defaultVertexDescriptor

  init(name: String) {
    guard
      let assetUrl = Bundle.main.url(forResource: name, withExtension: nil) else {
        fatalError("Model: \(name) not found")
    }
    let allocator = MTKMeshBufferAllocator(device: Renderer.device)
    let asset = MDLAsset(url: assetUrl,
                         vertexDescriptor: MDLVertexDescriptor.defaultVertexDescriptor,
                         bufferAllocator: allocator)
    var mtkMeshes: [MTKMesh] = []
    let mdlMeshes = asset.childObjects(of: MDLMesh.self) as! [MDLMesh]
    _ = mdlMeshes.map { mdlMesh in
      mdlMesh.addTangentBasis(forTextureCoordinateAttributeNamed:
        MDLVertexAttributeTextureCoordinate,
                              tangentAttributeNamed: MDLVertexAttributeTangent,
                              bitangentAttributeNamed: MDLVertexAttributeBitangent)
      Model.vertexDescriptor = mdlMesh.vertexDescriptor
      mtkMeshes.append(try! MTKMesh(mesh: mdlMesh, device: Renderer.device))
    }

    meshes = zip(mdlMeshes, mtkMeshes).map {
      Mesh(mdlMesh: $0.0, mtkMesh: $0.1)
    }
    samplerState = Model.buildSamplerState()
    super.init()
    self.name = name
  }
  
  private static func buildSamplerState() -> MTLSamplerState? {
    let descriptor = MTLSamplerDescriptor()
    descriptor.sAddressMode = .repeat
    descriptor.tAddressMode = .repeat
    descriptor.mipFilter = .linear
    descriptor.maxAnisotropy = 8
    let samplerState =
      Renderer.device.makeSamplerState(descriptor: descriptor)
    return samplerState
  }
}



