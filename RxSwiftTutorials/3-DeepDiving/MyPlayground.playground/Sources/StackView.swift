import UIKit

extension UIStackView {
    public class func makeVertical(_ views: [UIView]) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: views)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fill
        stack.axis = .vertical
        stack.spacing = 15
        return stack
    }
    
    public func insert(_ view: UIView, at index: Int) {
        insertArrangedSubview(view, at: index)
    }
    
    public func keep(atMost: Int) {
        while arrangedSubviews.count > atMost {
            let view = arrangedSubviews.last!
            removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }
}

