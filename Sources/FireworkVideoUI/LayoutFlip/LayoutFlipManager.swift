//
//  LayoutFlipManager.swift
//
//  Created by linjie jiang on 4/25/23.
//

import UIKit

class LayoutFlipManager {
    static let shared = LayoutFlipManager()

    static func swizzelMethods() {
        DispatchQueue.once {
            UIView.swizzleViewMethodsForLayoutFlip()
            CALayer.swizzleLayerMethodsForLayoutFlip()
        }
    }

    var enableHorizontalFlip: Bool = false {
        didSet {
            if enableHorizontalFlip == oldValue {
                return
            }

            var rootViews: Set<UIView> = Set()
            for element in registeredUIElements.allObjects {
                element.performReload()

                if element.window != nil && element.window != element {
                    continue
                }
                rootViews.insert(rootViewForView(element))
            }

            for rootView in rootViews {
                rootView.renewLayerTransformForceRecursively(true)
            }
        }
    }

    private var registeredUIElements: NSHashTable<UIView> = NSHashTable.weakObjects()

    func registerUIElement(_ element: UIView) {
        self.registeredUIElements.add(element)
    }

    private func rootViewForView(_ view: UIView) -> UIView {
        if let window = view.window {
            return window
        }

        var rootView: UIView = view
        while let superview = rootView.superview {
            rootView = superview
        }

        return rootView
    }
}
