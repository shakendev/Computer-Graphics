import Cocoa
import simd


extension ViewController {
  func addGestureRecognizer(to view: NSView) {
    let pan = NSPanGestureRecognizer(target: self,
                                     action: #selector(handlePan(gesture:)))
    view.addGestureRecognizer(pan)
    let click = NSClickGestureRecognizer(target: self,
                                         action: #selector(handleClick(gesture:)))
    view.addGestureRecognizer(click)
  }
  
  @objc func handlePan(gesture: NSPanGestureRecognizer) {
    let translation = float2(Float(gesture.translation(in: gesture.view).x),
                             Float(gesture.translation(in: gesture.view).y))
    
    renderer?.rotateUsing(translation: translation)
    gesture.setTranslation(.zero, in: gesture.view)
  }
  
  override func scrollWheel(with event: NSEvent) {
    let sensitivity: Float = 0.1
    renderer?.zoomUsing(delta: event.deltaY,
                        sensitivity: sensitivity)
  }
  
  @objc public func handleClick(gesture: NSClickGestureRecognizer) {
    guard let renderer = renderer else { return }
    renderer.wireframe = !renderer.wireframe
  }
}

