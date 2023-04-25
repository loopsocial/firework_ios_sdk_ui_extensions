//
//  CALayer+LayoutFlip.swift
//
//  Created by linjie jiang on 4/25/23.
//

import UIKit

private var gHasEnabledHorizontalFlip = false

extension CALayer {
    private struct AssociatedKeys {
        static var basicTransform = "basicTransform"
        static var isRenderStartLayer = "isRenderStartLayer"
        static var affineTransform = "affineTransform"
    }

    static func swizzleLayerMethodsForLayoutFlip() {
        SwizzleUtil.swizzleSelector(
            cls: self,
            originalSelector: #selector(CALayer.setAffineTransform(_:)),
            customSelector: #selector(CALayer.fw_setAffineTransform(_:)))
        SwizzleUtil.swizzleSelector(
            cls: self,
            originalSelector: #selector(CALayer.affineTransform),
            customSelector: #selector(CALayer.fw_affineTransform))
        SwizzleUtil.swizzleSelector(
            cls: self,
            originalSelector: #selector(CALayer.add(_:forKey:)),
            customSelector: #selector(CALayer.fw_add(_:forKey:)))
        SwizzleUtil.swizzleSelector(
            cls: self,
            originalSelector: #selector(CALayer.render(in:)),
            customSelector: #selector(CALayer.fw_render(in:)))
    }

    var basicTransform: CGAffineTransform {
        get {
            let result = objc_getAssociatedObject(self, &AssociatedKeys.basicTransform) as? NSValue

            return result?.cgAffineTransformValue ?? CGAffineTransformIdentity
        }

        set {
            if objc_getAssociatedObject(self, &AssociatedKeys.basicTransform) == nil,
               CGAffineTransformIsIdentity(newValue) {
                return
            }

            objc_setAssociatedObject(
                self,
                &AssociatedKeys.basicTransform,
                NSValue(cgAffineTransform: newValue),
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
            self.setAffineTransform(self.affineTransform())
        }
    }

    var isRenderStartLayer: Bool {
        get {
            let result = objc_getAssociatedObject(self, &AssociatedKeys.isRenderStartLayer) as? Bool
            return result ?? false
        }

        set {
            objc_setAssociatedObject(
                self,
                &AssociatedKeys.basicTransform,
                newValue,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }

    @objc func fw_setAffineTransform(_ affineTransform: CGAffineTransform) {
        if !gHasEnabledHorizontalFlip && LayoutFlipManager.shared.enableHorizontalFlip {
            gHasEnabledHorizontalFlip = true
        }

        if gHasEnabledHorizontalFlip {
            objc_setAssociatedObject(
                self,
                &AssociatedKeys.affineTransform,
                NSValue(cgAffineTransform: affineTransform),
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
            fw_setAffineTransform(CGAffineTransformConcat(basicTransform, affineTransform))
        } else {
            fw_setAffineTransform(affineTransform)
        }
    }

    @objc func fw_affineTransform() -> CGAffineTransform {
        if !gHasEnabledHorizontalFlip && LayoutFlipManager.shared.enableHorizontalFlip {
            gHasEnabledHorizontalFlip = true
        }

        if gHasEnabledHorizontalFlip {
            if let value = objc_getAssociatedObject(self, &AssociatedKeys.affineTransform) as? NSValue {
                return value.cgAffineTransformValue
            }
            return fw_affineTransform()
        } else {
            return fw_affineTransform()
        }
    }

    @objc func fw_add(_ anim: CAAnimation, forKey key: String?) {
        if let basicAnim = anim as? CABasicAnimation,
           let keyPath = basicAnim.keyPath,
           keyPath.starts(with: "transform.scale"),
           self.basicTransform.a == -1,
           let fromValue = basicAnim.fromValue as? Double,
           let toValue = basicAnim.toValue as? Double {
            basicAnim.fromValue = fromValue * -1
            basicAnim.toValue = toValue * -1
        }

        fw_add(anim, forKey: key)
    }

    @objc func fw_render(in ctx: CGContext) {
        if !gHasEnabledHorizontalFlip && LayoutFlipManager.shared.enableHorizontalFlip {
            gHasEnabledHorizontalFlip = true
        }

        if gHasEnabledHorizontalFlip {
            var isRenderStartLayer = true
            var allSuperLayerTransform = basicTransform
            var layer = self
            while let superlayer = layer.superlayer {
                layer = superlayer
                if layer.isRenderStartLayer {
                    isRenderStartLayer = false
                    break
                }
                allSuperLayerTransform = CGAffineTransformConcat(layer.basicTransform, allSuperLayerTransform)
            }

            if isRenderStartLayer {
                self.isRenderStartLayer = true
                if allSuperLayerTransform.a == -1 {
                    ctx.saveGState()
                    ctx.concatenate(CGAffineTransformMakeScale(-1, 1))
                    ctx.translateBy(x: -self.bounds.size.width, y: 0)
                }
            }
            fw_render(in: ctx)
            if isRenderStartLayer {
                self.isRenderStartLayer = false
                if allSuperLayerTransform.a == -1 {
                    ctx.restoreGState()
                }
            }
        } else {
            fw_render(in: ctx)
        }
    }
}
