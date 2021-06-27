import PlaygroundSupport
import MetalKit


guard let device = MTLCreateSystemDefaultDevice() else {
    fatalError("GPU isn't supported")
}

let frame = CGRect(x: 0.0, y: 0.0, width: 600.0, height: 600.0)
let view = MTKView(frame: frame, device: device)


view.clearColor = MTLClearColor(red: 1.0, green: 1.0, blue: 0.8, alpha: 1.0)



/*
 “Going through this code:
 The allocator manages the memory for the mesh data.
 Model I/O creates a sphere with the specified size and returns an MDLMesh with all the vertex information in data buffers.
 For Metal to be able to use the mesh, you convert it from a Model I/O mesh to a MetalKit mesh.”
 */

let allocator = MTKMeshBufferAllocator(device: device)

let mdlMesh = MDLMesh(sphereWithExtent: [0.2, 0.75, 0.2],
                      segments: [100, 100],
                      inwardNormals: false,
                      geometryType: .triangles,
                      allocator: allocator)

let mesh = try MTKMesh(mesh: mdlMesh, device: device)


guard let commandQueue = device.makeCommandQueue() else {
    fatalError("Couldn't create a command queue")
}


// Vertex and fragment shaders
let shader = """
#include <metal_stdlib>
using namespace metal;

struct VertexIn {
  float4 position [[ attribute(0) ]];
};

vertex float4 vertex_main(const VertexIn vertex_in [[ stage_in ]]) {
  return vertex_in.position;
}

fragment float4 fragment_main() {
  return float4(0, 0.4, 0.21, 1);
}
"""


let library = try device.makeLibrary(source: shader, options: nil)
let vertexFunction = library.makeFunction(name: "vertex_main")
let fragmentFunction = library.makeFunction(name: "fragment_main")


// Pipeline
let pipelineDescriptor = MTLRenderPipelineDescriptor()
pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
pipelineDescriptor.vertexFunction = vertexFunction
pipelineDescriptor.fragmentFunction = fragmentFunction

pipelineDescriptor.vertexDescriptor = MTKMetalVertexDescriptorFromModelIO(mesh.vertexDescriptor)


let pipelineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)


// 1
guard let commandBuffer = commandQueue.makeCommandBuffer(),
// 2
  let renderPassDescriptor = view.currentRenderPassDescriptor,
// 3
  let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else {
    fatalError()
}

renderEncoder.setRenderPipelineState(pipelineState)

renderEncoder.setVertexBuffer(mesh.vertexBuffers[0].buffer, offset: 0, index: 0)

guard let submesh = mesh.submeshes.first else {
    fatalError()
}

renderEncoder.drawIndexedPrimitives(type: .triangle,
                                    indexCount: submesh.indexCount,
                                    indexType: submesh.indexType,
                                    indexBuffer: submesh.indexBuffer.buffer,
                                    indexBufferOffset: 0)


renderEncoder.endEncoding()

guard let drawable = view.currentDrawable else {
    fatalError()
}

commandBuffer.present(drawable)
commandBuffer.commit()


PlaygroundPage.current.liveView = view
