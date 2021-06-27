import Foundation

struct Lighting {
  // Lights
  let sunlight: Light = {
    var light = Lighting.buildDefaultLight()
    light.position = [-1.4, 1, -2]
    return light
  }()
  let lights: [Light]
  let count: UInt32
  
  init() {
    lights = [sunlight]
    count = UInt32(lights.count)
  }
  
  static func buildDefaultLight() -> Light {
    var light = Light()
    light.position = [0, 0, 0]
    light.color = [1, 1, 1]
    light.specularColor = [1, 1, 1]
    light.intensity = 1
    light.attenuation = float3(1, 0, 0)
    light.type = Sunlight
    return light
  }
}
