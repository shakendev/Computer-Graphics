import UIKit

extension ViewController {
  static var previousScale: CGFloat = 1

  func addGestureRecognizer(to view: UIView) {
    let pan = UIPanGestureRecognizer(target: self,
                                     action: #selector(handlePan(gesture:)))
    view.addGestureRecognizer(pan)
    
    let pinch = UIPinchGestureRecognizer(target: self,
                                         action: #selector(handlePinch(gesture:)))
    view.addGestureRecognizer(pinch)
  }
  
  @objc func handlePan(gesture: UIPanGestureRecognizer) {
    let translation = float2(Float(gesture.translation(in: gesture.view).x),
                             Float(gesture.translation(in: gesture.view).y))
    renderer?.rotateUsing(translation: translation)
    gesture.setTranslation(.zero, in: gesture.view)
  }
  
  @objc func handlePinch(gesture: UIPinchGestureRecognizer) {
    let sensitivity: CGFloat = 100
    renderer?.zoomUsing(delta: (ViewController.previousScale - gesture.scale) * sensitivity)
    ViewController.previousScale = gesture.scale
    if gesture.state == .ended {
      ViewController.previousScale = 1
    }
  }
  
}
