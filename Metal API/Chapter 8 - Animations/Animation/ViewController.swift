import MetalKit

class ViewController: LocalViewController {
  
  var renderer: Renderer?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    guard let metalView = view as? MTKView else {
      fatalError("metal view not set up in storyboard")
    }
    renderer = Renderer(metalView: metalView)
    addGestureRecognizers(to: metalView)
  }
}
