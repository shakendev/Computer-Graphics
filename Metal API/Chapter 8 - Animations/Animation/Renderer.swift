import MetalKit

class Renderer: NSObject {
  static var device: MTLDevice!
  static var commandQueue: MTLCommandQueue!
  static var library: MTLLibrary!
  static var colorPixelFormat: MTLPixelFormat!
  static var fps: Int!

  var uniforms = Uniforms()
  var fragmentUniforms = FragmentUniforms()
  let depthStencilState: MTLDepthStencilState
  let lighting = Lighting()

  lazy var camera: Camera = {
    let camera = ArcballCamera()
    camera.distance = 3
    camera.target = [0, 1.3, 0]
    camera.rotation.x = Float(-15).degreesToRadians
    return camera
  }()

  // Array of Models allows for rendering multiple models
  var models: [Model] = []

  var currentTime: Float = 0
  var ballVelocity: Float = 0
  
  init(metalView: MTKView) {
    guard
      let device = MTLCreateSystemDefaultDevice(),
      let commandQueue = device.makeCommandQueue() else {
        fatalError("GPU not available")
    }
    Renderer.device = device
    Renderer.commandQueue = commandQueue
    Renderer.library = device.makeDefaultLibrary()
    Renderer.colorPixelFormat = metalView.colorPixelFormat
    Renderer.fps = metalView.preferredFramesPerSecond
    
    metalView.device = device
    metalView.depthStencilPixelFormat = .depth32Float
    
    depthStencilState = Renderer.buildDepthStencilState()!
    super.init()
    metalView.clearColor = MTLClearColor(red: 0.49, green: 0.62,
                                         blue: 0.75, alpha: 1)
    metalView.delegate = self
    mtkView(metalView, drawableSizeWillChange: metalView.bounds.size)

    // models
    let skeleton = Model(name: "skeletonWave.usda")
    skeleton.rotation = [.pi / 2, .pi, 0]
    skeleton.scale = [100, 100, 100]
    models.append(skeleton)
    let ground = Model(name: "ground.obj")
    ground.scale = [100, 100, 100]
    models.append(ground)
    
    fragmentUniforms.lightCount = lighting.count
  }
  

  static func buildDepthStencilState() -> MTLDepthStencilState? {
    let descriptor = MTLDepthStencilDescriptor()
    descriptor.depthCompareFunction = .less
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
    
    let deltaTime = 1 / Float(Renderer.fps)
    for model in models {
      model.update(deltaTime: deltaTime)
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
      renderEncoder.pushDebugGroup(model.name)
      model.render(renderEncoder: renderEncoder,
                   uniforms: uniforms,
                   fragmentUniforms: fragmentUniforms)
      renderEncoder.popDebugGroup()
    }

    renderEncoder.endEncoding()
    guard let drawable = view.currentDrawable else {
      return
    }
    commandBuffer.present(drawable)
    commandBuffer.commit()
    commandBuffer.waitUntilCompleted()
  }
}
