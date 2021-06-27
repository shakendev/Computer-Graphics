import MetalKit

extension Renderer {
  func zoomUsing(delta: CGFloat, sensitivity: Float) {
    camera.position.z += Float(delta) * sensitivity
  }
  
  func rotateUsing(translation: float2) {
    let sensitivity: Float = 0.01
    camera.rotation.x += Float(translation.y) * sensitivity
    camera.rotation.y -= Float(translation.x) * sensitivity
  }
  
  func random(range: CountableClosedRange<Int>) -> Int {
    var offset = 0
    if range.lowerBound < 0 {
      offset = abs(range.lowerBound)
    }
    let min = UInt32(range.lowerBound + offset)
    let max = UInt32(range.upperBound + offset)
    return Int(min + arc4random_uniform(max-min)) - offset
  }
  
  func createPointLights(count: Int, min: float3, max: float3) {
    let colors: [float3] = [
      float3(1, 0, 0),
      float3(1, 1, 0),
      float3(1, 1, 1),
      float3(0, 1, 0),
      float3(0, 1, 1),
      float3(0, 0, 1),
      float3(0, 1, 1),
      float3(1, 0, 1) ]
    let newMin: float3 = [min.x*100, min.y*100, min.z*100]
    let newMax: float3 = [max.x*100, max.y*100, max.z*100]
    for _ in 0..<count {
      var light = buildDefaultLight()
      light.type = Pointlight
      let x = Float(random(range: Int(newMin.x)...Int(newMax.x))) * 0.01
      let y = Float(random(range: Int(newMin.y)...Int(newMax.y))) * 0.01
      let z = Float(random(range: Int(newMin.z)...Int(newMax.z))) * 0.01
      light.position = [x, y, z]
      light.color = colors[random(range: 0...colors.count)]
      light.intensity = 0.6
      light.attenuation = float3(1.5, 1, 1)
      lights.append(light)
    }
  }  
}
