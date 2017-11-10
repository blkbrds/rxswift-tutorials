import UIKit
import PlaygroundSupport

public func setupHostView() -> UIView {
    
    let hostView = UIView(frame: CGRect(x: 0, y: 0, width: 400, height: 640))
    hostView.backgroundColor = .white
    
    PlaygroundPage.current.needsIndefiniteExecution = true
    PlaygroundPage.current.liveView = hostView
    
    return hostView
}
