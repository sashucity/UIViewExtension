import Foundation

extension UIView {
    private func pinToItem(_ item: Any, withInsets insets: UIEdgeInsets, relaxBottomConstraint: Bool = false) {
        func pin(attribute: NSLayoutConstraint.Attribute, constant: CGFloat) -> NSLayoutConstraint {
            return NSLayoutConstraint(item: self,
                                      attribute: attribute,
                                      relatedBy: .equal,
                                      toItem: item,
                                      attribute: attribute,
                                      multiplier: 1.0,
                                      constant: constant)
        }
        
        let constraints = PinnedEdgeConstraints(top: pin(attribute: .top, constant: insets.top),
                                                left: pin(attribute: .left, constant: insets.left),
                                                bottom: pin(attribute: .bottom, constant: -insets.bottom),
                                                right: pin(attribute: .right, constant: -insets.right))
        
        if relaxBottomConstraint {
            constraints.bottom.priority = UILayoutPriority(999)
        }
        
        constraints.activate()
    }
    
    // Anchors view edges to superview edges, activating created constraints
    func anchorToSuperviewEdges(insets: UIEdgeInsets = .zero, relaxBottomConstraint: Bool = false) {
        guard let superview = self.superview else { return }
        
        translatesAutoresizingMaskIntoConstraints = false
        pinToItem(superview, withInsets: insets, relaxBottomConstraint: relaxBottomConstraint)
    }
    
    // Anchors view edges to superview safe area, activating created constraints
    func anchorToSuperviewSafeArea(insets: UIEdgeInsets = .zero) {
        guard #available(iOS 11, *) else {
            return anchorToSuperviewEdges(insets: insets)
        }
        
        guard let superview = self.superview else { return }
        
        translatesAutoresizingMaskIntoConstraints = false
        pinToItem(superview.safeAreaLayoutGuide, withInsets: insets)
    }
}

fileprivate struct PinnedEdgeConstraints {
    let top: NSLayoutConstraint
    let left: NSLayoutConstraint
    let bottom: NSLayoutConstraint
    let right: NSLayoutConstraint
    
    var all: [NSLayoutConstraint] {
        return [top, left, bottom, right]
    }
    
    func activate() {
        NSLayoutConstraint.activate(all)
    }
}
