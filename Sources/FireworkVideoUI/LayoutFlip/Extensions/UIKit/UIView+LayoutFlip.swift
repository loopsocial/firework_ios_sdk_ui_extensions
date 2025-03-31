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
    "X1VJUmVtb3RlVmlldw==".decodeBase64String(),
    "VUlBdXRvY29ycmVjdFRleHRWaWV3".decodeBase64String(),
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
        static var viewType: UInt8 = 0
        static var calculatedViewType: UInt8 = 0
        static var lastType: UInt8 = 0
        static var hasCalculatedSemanticContentAttribute: UInt8 = 0
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
        Swizzle.swizzleSelector(
            cls: self,
            originalSelector: #selector(UIView.layoutSubviews),
            customSelector: #selector(UIView.fw_layoutSubviews))
        Swizzle.swizzleSelector(cls: self,
                                originalSelector: #selector(UIView.removeFromSuperview),
                                customSelector: #selector(UIView.fw_viewRemoveFromSuperview))
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

    private var hasCalculatedSemanticContentAttribute: Bool {
        get {
            let result = objc_getAssociatedObject(self, &AssociatedKeys.hasCalculatedSemanticContentAttribute) as? Bool
            return result ?? false
        }

        set {
            objc_setAssociatedObject(
                self,
                &AssociatedKeys.hasCalculatedSemanticContentAttribute,
                newValue,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }

    @objc func fw_didMoveToSuperview() {
        fw_didMoveToSuperview()
        if self.superview == nil {
            return
        }

        renewLayerTransformForceRecursively(false)
    }

    @objc func fw_didMoveToWindow() {
        fw_didMoveToWindow()
        if self.window == nil {
            return
        }

        renewLayerTransformForceRecursively(false)
        LayoutFlipManager.shared.registerUIElement(self)
        if !hasCalculatedSemanticContentAttribute,
            shouldCalculateSemanticContentAttribute() {
            semanticContentAttribute = calculateSemanticContentAttribute()
            hasCalculatedSemanticContentAttribute = true
        }
    }

    @objc func fw_snapshotView(afterScreenUpdates afterUpdates: Bool) -> UIView? {
        let view = fw_snapshotView(afterScreenUpdates: afterUpdates)
        view?.viewType = calculatedViewType
        return view
    }

    @objc func fw_layoutSubviews() {
        fw_layoutSubviews()
        renewLayerTransformForceRecursively(false)
    }

    @objc func fw_viewRemoveFromSuperview() {
        fw_viewRemoveFromSuperview()
        hasCalculatedSemanticContentAttribute = false
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
            if layer.anchorPoint == CGPointZero {
                layer.basicTransform = CGAffineTransformConcat(CGAffineTransformMakeScale(-1, 1), CGAffineTransform(translationX: layer.bounds.width, y: 0))
            } else {
                layer.basicTransform = CGAffineTransformMakeScale(-1, 1)
            }
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

    private func shouldCalculateSemanticContentAttribute() -> Bool {
        if AppLanguageManager.shared.shouldHorizontalFlip,
            isIOSSDKView,
           let layoutDirection = AppLanguageManager.shared.appLanguageLayoutDirection,
           layoutDirection != .unsupported {
            return true
        }

        return false
    }

    private func calculateSemanticContentAttribute() -> UISemanticContentAttribute {
        let systemLanguageLayoutDirection = AppLanguageManager.shared.systemLanguageLayoutDirection ?? .unsupported
        switch systemLanguageLayoutDirection {
        case .ltr:
            return .forceLeftToRight
        case .rtl:
            return .forceRightToLeft
        case .unsupported:
            return .unspecified
        }
    }
}

public extension UIView {
    func flipIfNeeded() {
        if AppLanguageManager.shared.shouldHorizontalFlip {
            self.viewType = .flip
        }
    }
}
