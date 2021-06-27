import MetalKit

class Submesh {
  var submesh: MTKSubmesh
  var material = Material()
  
  init(submesh: MTKSubmesh, mdlSubmesh: MDLSubmesh) {
    self.submesh = submesh
    material = createMaterialFrom(submesh: mdlSubmesh)
  }
  
  func createMaterialFrom(submesh: MDLSubmesh) -> Material {
    var material = Material()
    if let baseColor = submesh.material?.propertyNamed("baseColor"),
      baseColor.type == .float3 {
      material.baseColor = [Float(baseColor.float3Value.x),
                            Float(baseColor.float3Value.y),
                            Float(baseColor.float3Value.z)]
    }
    if let specular = submesh.material?.propertyNamed("specular") {
      if specular.type == .float3 {
        material.specularColor = float3(Float(specular.float4Value.x),
                                        Float(specular.float4Value.y),
                                        Float(specular.float4Value.z))
      }
    }
    if let shininess = submesh.material?.propertyNamed("specularExponent") {
      if shininess.type == .float {
        material.shininess = shininess.floatValue
      }
    }
    if let emission = submesh.material?.propertyNamed("emission") {
      if emission.type == .float3 {
        material.emissionColor = emission.float3Value
      }
    }
    return material
  }
}
