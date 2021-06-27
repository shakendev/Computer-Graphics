import MetalKit

class Model: Node {
  
  static var defaultVertexDescriptor: MDLVertexDescriptor = {
    let vertexDescriptor = MDLVertexDescriptor()
    vertexDescriptor.attributes[0] =
      MDLVertexAttribute(name: MDLVertexAttributePosition,
                         format: .float3,
                         offset: 0, bufferIndex: 0)
    vertexDescriptor.attributes[1] =
      MDLVertexAttribute(name: MDLVertexAttributeNormal,
                         format: .float3,
                         offset: 12, bufferIndex: 0)
    vertexDescriptor.layouts[0] = MDLVertexBufferLayout(stride: 24)
    return vertexDescriptor
  }()
  
  let vertexBuffer: MTLBuffer
  let mesh: MTKMesh
  let submeshes: [Submesh]
  
  init(name: String) {
    let assetURL = Bundle.main.url(forResource: name, withExtension: "obj")!
    let allocator = MTKMeshBufferAllocator(device: Renderer.device)
    let asset = MDLAsset(url: assetURL, vertexDescriptor: Model.defaultVertexDescriptor,
                         bufferAllocator: allocator)
    let mdlMesh = asset.object(at: 0) as! MDLMesh
    let mesh = try! MTKMesh(mesh: mdlMesh, device: Renderer.device)
    self.mesh = mesh
    vertexBuffer = mesh.vertexBuffers[0].buffer
    submeshes = mdlMesh.submeshes?.enumerated().compactMap {index, submesh in
      (submesh as? MDLSubmesh).map {
        Submesh(submesh: mesh.submeshes[index],
                mdlSubmesh: $0)
      }
    } ?? []
    
    super.init()
  }
}
