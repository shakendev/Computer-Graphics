import Foundation

struct Lighting {
  // Lights
  let sunlight: Light = {
    var light = Lighting.buildDefaultLight()
    light.position = [0.4, 1.5, -2]
    return light
  }()
  let ambientLight: Light = {
    var light = Lighting.buildDefaultLight()
    light.color = [1, 1, 1]
    light.intensity = 0.1
    light.type = Ambientlight
    return light
  }()
  let fillLight: Light = {
    var light = Lighting.buildDefaultLight()
    light.position = [0, -0.1, 0.4]
    light.specularColor = [0, 0, 0]
    light.color = [0.4, 0.4, 0.4]
    return light
  }()
  
  let lights: [Light]
  let count: UInt32
  
  init() {
    lights = [sunlight, ambientLight, fillLight]
    count = UInt32(lights.count)
  }
  
  static func buildDefaultLight() -> Light {
    var light = Light()
    light.position = [0, 0, 0]
    light.color = [1, 1, 1]
    light.specularColor = [1, 1, 1]
    light.intensity = 0.6
    light.attenuation = float3(1, 0, 0)
    light.type = Sunlight
    return light
  }
}
