import simd

let vertices: [float3] = [
  [-1,  0,  1],
  [ 1,  0, -1],
  [-1,  0, -1],
  [-1,  0,  1],
  [ 1,  0, -1],
  [ 1,  0,  1]
]

let vertexBuffer = Renderer.device.makeBuffer(bytes: vertices,
                                              length: MemoryLayout<float3>.stride * vertices.count,
                                              options: [])

/**
 Create control points
 - Parameters:
     - patches: number of patches across and down
     - size: size of plane
 - Returns: an array of patch control points. Each group of four makes one patch.
**/
func createControlPoints(patches: (horizontal: Int, vertical: Int),
                         size: (width: Float, height: Float)) -> [float3] {
  
  var points: [float3] = []
  // per patch width and height
  let width = 1 / Float(patches.horizontal)
  let height = 1 / Float(patches.vertical)
  
  for j in 0..<patches.vertical {
    let row = Float(j)
    for i in 0..<patches.horizontal {
      let column = Float(i)
      let left = width * column
      let bottom = height * row
      let right = width * column + width
      let top = height * row + height
      
      points.append([left, 0, top])
      points.append([right, 0, top])
      points.append([right, 0, bottom])
      points.append([left, 0, bottom])
    }
  }
  // size and convert to Metal coordinates
  // eg. 6 across would be -3 to + 3
  points = points.map {
    [$0.x * size.width - size.width / 2,
     0,
     $0.z * size.height - size.height / 2]
  }
  return points
}
