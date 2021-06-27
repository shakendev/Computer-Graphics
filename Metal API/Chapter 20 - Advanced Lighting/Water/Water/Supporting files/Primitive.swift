import MetalKit

class Primitive {
  class func cube(device: MTLDevice) -> MDLMesh {
    let allocator = MTKMeshBufferAllocator(device: device)
    let newCube = MDLMesh(boxWithExtent: [1,1,1],
                          segments: [1, 1, 1],
                          inwardNormals: false,
                          geometryType: .triangles,
                          allocator: allocator)
    return newCube
  }
  
  class func sphere(device: MTLDevice) -> MDLMesh {
    let allocator = MTKMeshBufferAllocator(device: device)
    let newSphere = MDLMesh(sphereWithExtent: [1,1,1],
                            segments: [10,10],
                            inwardNormals: false,
                            geometryType: .triangles,
                            allocator: allocator)
    return newSphere
  }
  
  class func plane(device: MTLDevice) -> MDLMesh {
    let allocator = MTKMeshBufferAllocator(device: device)
    let newPlane = MDLMesh.newPlane(withDimensions: [100, 100],
                                    segments: [1, 1],
                                    geometryType: .triangles,
                                    allocator: allocator)
    return newPlane
  }
}
