import MetalKit

class Submesh {
  var mtkSubmesh: MTKSubmesh
  
  init(mdlSubmesh: MDLSubmesh, mtkSubmesh: MTKSubmesh) {
    self.mtkSubmesh = mtkSubmesh
  }
}
