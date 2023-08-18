//
//  UIView+LayoutFlip.swift
//
//  Created by linjie jiang on 4/25/23.
//

import UIKit
import WebKit

private let gNoFlipClasses: [Any] = [
    UILabel.self,
    UITextView.self,
    UITextField.self,
    WKWebView.self,
    UIImageView.self,
    UISearchBar.self,
    "PUPhotosSectionHeaderContentView",
    "UITableViewIndex",
    "UIWebView",
    "X1VJUmVtb3RlVmlldw==".decodeBase64String(), // _UIRemoteView
    "VUlBdXRvY29ycmVjdFRleHRWaWV3".decodeBase64String() // UIAutocorrectTextView
]

enum LayoutFlipViewType: Int {
    case auto
    case inherit
    case normal
    case flip
    case normalWithAllDescendants
    case flipWithAllDescendants
}

extension UIView {
    private struct AssociatedKeys {
        static var viewType = "viewType"
        static var calculatedViewType = "calculatedViewType"
        static var lastType = "lastType"
    }

    static func swizzleViewMethodsForLayoutFlip() {
        Swizzle.swizzleSelector(
            cls: self,
            originalSelector: #selector(UIView.didMoveToSuperview),
            customSelector: #selector(UIView.fw_didMoveToSuperview))
        Swizzle.swizzleSelector(
            cls: self,
            originalSelector: #selector(UIView.didMoveToWindow),
            customSelector: #selector(UIView.fw_didMoveToWindow))
        Swizzle.swizzleSelector(
            cls: self,
            originalSelector: #selector(UIView.snapshotView(afterScreenUpdates:)),
            customSelector: #selector(UIView.fw_snapshotView(afterScreenUpdates:)))
    }

    var viewType: LayoutFlipViewType {
        get {
            let rawValue = objc_getAssociatedObject(self, &AssociatedKeys.viewType) as? Int ?? 0
            let type = LayoutFlipViewType(rawValue: rawValue) ?? .auto

            return type
        }

        set {
            if viewType == newValue {
                return
            }

            objc_setAssociatedObject(
                self,
                &AssociatedKeys.viewType,
                newValue.rawValue,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
            renewLayerTransformForceRecursively(false)
        }
    }

    private(set) var calculatedViewType: LayoutFlipViewType {
        get {
            let rawValue = objc_getAssociatedObject(self, &AssociatedKeys.calculatedViewType) as? Int ?? 0
            var type = LayoutFlipViewType(rawValue: rawValue) ?? .auto
            if type == .auto {
                if self.window != nil {
                    updateCalculatedViewType()
                    let newRawValue = objc_getAssociatedObject(self, &AssociatedKeys.calculatedViewType) as? Int ?? 0
                    type = LayoutFlipViewType(rawValue: newRawValue) ?? .auto
                } else {
                    type = .normal
                }
            }

            return type
        }

        set {
            objc_setAssociatedObject(
                self,
                &AssociatedKeys.calculatedViewType,
                newValue.rawValue,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }

    private var lastType: LayoutFlipViewType {
        get {
            let rawValue = objc_getAssociatedObject(self, &AssociatedKeys.lastType) as? Int ?? 0
            let type = LayoutFlipViewType(rawValue: rawValue) ?? .auto

            return type
        }

        set {
            objc_setAssociatedObject(
                self,
                &AssociatedKeys.lastType,
                newValue.rawValue,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }

    @objc func fw_didMoveToSuperview() {
        fw_didMoveToSuperview()
        renewLayerTransformForceRecursively(false)
    }

    @objc func fw_didMoveToWindow() {
        fw_didMoveToWindow()
        renewLayerTransformForceRecursively(false)
        LayoutFlipManager.shared.registerUIElement(self)
    }

    @objc func fw_snapshotView(afterScreenUpdates afterUpdates: Bool) -> UIView? {
        let view = fw_snapshotView(afterScreenUpdates: afterUpdates)
        view?.viewType = calculatedViewType
        return view
    }

    func renewLayerTransformForceRecursively(_ forceRecursively: Bool) {
        if !isIOSSDKView {
            return
        }
        updateCalculatedViewType()
        let updatedViewType = calculatedViewType
        let superViewCalculatedViewType = superview?.calculatedViewType ?? .auto
        let shouldFlipCurrentView = updatedViewType == .flip || updatedViewType == .flipWithAllDescendants
        let shouldFlipSuperview = superViewCalculatedViewType == .flip
                                  || superViewCalculatedViewType == .flipWithAllDescendants

        let shouldSetFlipTransform = shouldFlipSuperview != shouldFlipCurrentView

        if shouldSetFlipTransform && LayoutFlipManager.shared.enableHorizontalFlip {
            layer.basicTransform = CGAffineTransformMakeScale(-1, 1)
        } else {
            layer.basicTransform = CGAffineTransformIdentity
        }

        if updatedViewType != lastType || forceRecursively {
            for subView in subviews {
                subView.renewLayerTransformForceRecursively(forceRecursively)
            }
        }

        lastType = updatedViewType
    }

    private func automaticViewType() -> LayoutFlipViewType {
        if self is UIWindow {
            return .normal
        }

        for element in gNoFlipClasses {
            if let cls = element as? AnyClass,
               self.isKind(of: cls) {
                return .normal

            } else if let className = element as? String,
                      let cls = NSClassFromString(className),
                      self.isKind(of: cls) {
                return .normal
            }
        }

        return superview != nil ? .inherit : .normal
    }

    private func updateCalculatedViewType() {
        var resultCalculatedViewType = viewType
        if resultCalculatedViewType == .auto {
            resultCalculatedViewType = automaticViewType()
        }
        let superViewCalculatedViewType = superview?.calculatedViewType ?? .auto
        if superViewCalculatedViewType == .flipWithAllDescendants
            || superViewCalculatedViewType == .normalWithAllDescendants
            || resultCalculatedViewType == .inherit {
            calculatedViewType = superViewCalculatedViewType
        } else {
            calculatedViewType = resultCalculatedViewType
        }
    }
}
