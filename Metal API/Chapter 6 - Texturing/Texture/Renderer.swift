import MetalKit

class Renderer: NSObject {
  static var device: MTLDevice!
  static var commandQueue: MTLCommandQueue!
  static var library: MTLLibrary!

  var uniforms = Uniforms()
  var fragmentUniforms = FragmentUniforms()
  let depthStencilState: MTLDepthStencilState
  let lighting = Lighting()

  lazy var camera: Camera = {
    let camera = ArcballCamera()
    camera.distance = 4.3
    camera.target = [0, 1.2, 0]
    camera.rotation.x = Float(-10).degreesToRadians
    return camera
  }()

  // Array of Models allows for rendering multiple models
  var models: [Model] = []
  
  init(metalView: MTKView) {
    guard
      let device = MTLCreateSystemDefaultDevice(),
      let commandQueue = device.makeCommandQueue() else {
        fatalError("GPU not available")
    }
    Renderer.device = device
    Renderer.commandQueue = commandQueue
    Renderer.library = device.makeDefaultLibrary()
    metalView.device = device
    metalView.depthStencilPixelFormat = .depth32Float
    
    depthStencilState = Renderer.buildDepthStencilState()!
    super.init()
    metalView.clearColor = MTLClearColor(red: 0.7, green: 0.9,
                                         blue: 1.0, alpha: 1)
    metalView.delegate = self
    mtkView(metalView, drawableSizeWillChange: metalView.bounds.size)

    // models
    let house = Model(name: "lowpoly-house.obj")
    house.position = [0, 0, 0]
    house.rotation = [0, Float(45).degreesToRadians, 0]
    models.append(house)
    let ground = Model(name: "plane.obj")
    ground.scale = [40, 40, 40]
    ground.tiling = 16
    models.append(ground)
    
    fragmentUniforms.lightCount = lighting.count
  }
  

  static func buildDepthStencilState() -> MTLDepthStencilState? {
    // 1
    let descriptor = MTLDepthStencilDescriptor()
    // 2
    descriptor.depthCompareFunction = .less
    // 3
    descriptor.isDepthWriteEnabled = true
    return
      Renderer.device.makeDepthStencilState(descriptor: descriptor)
  }
}

extension Renderer: MTKViewDelegate {
  func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
    camera.aspect = Float(view.bounds.width)/Float(view.bounds.height)
  }
  
  func draw(in view: MTKView) {
    guard
      let descriptor = view.currentRenderPassDescriptor,
      let commandBuffer = Renderer.commandQueue.makeCommandBuffer(),
      let renderEncoder =
      commandBuffer.makeRenderCommandEncoder(descriptor: descriptor) else {
        return
    }
    
    renderEncoder.setDepthStencilState(depthStencilState)

    uniforms.projectionMatrix = camera.projectionMatrix
    uniforms.viewMatrix = camera.viewMatrix
    fragmentUniforms.cameraPosition = camera.position
    
    var lights = lighting.lights
    renderEncoder.setFragmentBytes(&lights,
                                   length: MemoryLayout<Light>.stride * lights.count,
                                   index: Int(BufferIndexLights.rawValue))

    
    // render all the models in the array
    for model in models {
      
      // add tiling here
      fragmentUniforms.tiling = model.tiling
      renderEncoder.setFragmentBytes(&fragmentUniforms,
                                     length: MemoryLayout<FragmentUniforms>.stride,
                                     index: Int(BufferIndexFragmentUniforms.rawValue))
      
      renderEncoder.setFragmentSamplerState(model.samplerState, index: 0)
      
      uniforms.modelMatrix = model.modelMatrix
      uniforms.normalMatrix = uniforms.modelMatrix.upperLeft
      
      renderEncoder.setVertexBytes(&uniforms,
                                   length: MemoryLayout<Uniforms>.stride,
                                   index: Int(BufferIndexUniforms.rawValue))
      
      renderEncoder.setRenderPipelineState(model.pipelineState)

      for mesh in model.meshes {
        let vertexBuffer = mesh.mtkMesh.vertexBuffers[0].buffer
        renderEncoder.setVertexBuffer(vertexBuffer, offset: 0,
                                      index: 0)

        for submesh in mesh.submeshes {
          
          // set the fragment texture here
          renderEncoder.setFragmentTexture(submesh.textures.baseColor,
                                           index: Int(BaseColorTexture.rawValue))
          
          let mtkSubmesh = submesh.mtkSubmesh
          renderEncoder.drawIndexedPrimitives(type: .triangle,
                                              indexCount: mtkSubmesh.indexCount,
                                              indexType: mtkSubmesh.indexType,
                                              indexBuffer: mtkSubmesh.indexBuffer.buffer,
                                              indexBufferOffset: mtkSubmesh.indexBuffer.offset)
        }
      }
    }

    renderEncoder.endEncoding()
    guard let drawable = view.currentDrawable else {
      return
    }
    commandBuffer.present(drawable)
    commandBuffer.commit()
  }
}
