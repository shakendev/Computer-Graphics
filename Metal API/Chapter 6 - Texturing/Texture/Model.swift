import MetalKit

class Model: Node {
  
  let pipelineState: MTLRenderPipelineState
  let meshes: [Mesh]
  var tiling: UInt32 = 1
  let samplerState: MTLSamplerState?
  
  init(name: String) {
    guard
      let assetUrl = Bundle.main.url(forResource: name, withExtension: nil) else {
        fatalError("Model: \(name) not found")
    }
    let allocator = MTKMeshBufferAllocator(device: Renderer.device)
    let asset = MDLAsset(url: assetUrl,
                         vertexDescriptor: MDLVertexDescriptor.defaultVertexDescriptor,
                         bufferAllocator: allocator)
    let (mdlMeshes, mtkMeshes) = try! MTKMesh.newMeshes(asset: asset,
                                                        device: Renderer.device)
    meshes = zip(mdlMeshes, mtkMeshes).map {
      Mesh(mdlMesh: $0.0, mtkMesh: $0.1)
    }
    pipelineState = Model.buildPipelineState()
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
  
  private static func buildPipelineState() -> MTLRenderPipelineState {
    let library = Renderer.library
    let vertexFunction = library?.makeFunction(name: "vertex_main")
    let fragmentFunction = library?.makeFunction(name: "fragment_main")
    
    var pipelineState: MTLRenderPipelineState
    let pipelineDescriptor = MTLRenderPipelineDescriptor()
    pipelineDescriptor.vertexFunction = vertexFunction
    pipelineDescriptor.fragmentFunction = fragmentFunction
    let vertexDescriptor = MDLVertexDescriptor.defaultVertexDescriptor
    pipelineDescriptor.vertexDescriptor = MTKMetalVertexDescriptorFromModelIO(vertexDescriptor)
    pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
    pipelineDescriptor.depthAttachmentPixelFormat = .depth32Float
    do {
      pipelineState = try Renderer.device.makeRenderPipelineState(descriptor: pipelineDescriptor)
    } catch let error {
      fatalError(error.localizedDescription)
    }
    return pipelineState
  }
}



