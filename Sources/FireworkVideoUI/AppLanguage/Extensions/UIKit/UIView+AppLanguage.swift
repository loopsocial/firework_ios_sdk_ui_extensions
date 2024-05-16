//
//  UIView+AppLanguage.swift
//
//  Created by linjie jiang on 2023/3/11.
//

import UIKit
import FireworkVideo
import AVFoundation

private let gNamesOfImagesWithDirection: [String] = [
    "stream-gate-back",
]

extension UIView {
    static func swizzleViewMethodsForAppLanguage() {
        Swizzle.swizzleSelector(
            cls: self,
            originalSelector: #selector(UIView.init(frame:)),
            customSelector: #selector(UIView.fw_init(frame:))
        )
        Swizzle.swizzleSelector(
            cls: self,
            originalSelector: #selector(UIView.awakeFromNib),
            customSelector: #selector(UIView.fw_viewAwakeFromNib)
        )
        Swizzle.swizzleSelector(
            cls: self,
            originalSelector: #selector(getter: UIView.semanticContentAttribute),
            customSelector: #selector(UIView.fw_semanticContentAttribute)
        )
    }

    @objc func fw_init(frame: CGRect) -> UIView {
        let view = self.fw_init(frame: frame)
        updateViewTypeIfNeeded(view)

        return view
    }

    @objc func fw_viewAwakeFromNib() {
        self.fw_viewAwakeFromNib()
        updateViewTypeIfNeeded(self)
    }

    @objc func fw_semanticContentAttribute() -> UISemanticContentAttribute {
        if self.isIOSSDKView, AppLanguageManager.shared.shouldHorizontalFlip {
            let systemLanguageLayoutDirection = AppLanguageManager.shared.systemLanguageLayoutDirection ?? .unsupported
            switch systemLanguageLayoutDirection {
            case .ltr:
                return .forceLeftToRight
            case .rtl:
                return .forceRightToLeft
            case .unsupported:
                return fw_semanticContentAttribute()
            }
        }

        return fw_semanticContentAttribute()
    }

    private func updateViewTypeIfNeeded(_ view: UIView) {
        if view is FireworkPlayerView, AppLanguageManager.shared.shouldHorizontalFlip {
            view.viewType = .normal
        }

        DispatchQueue.main.async {
            if AppLanguageManager.shared.shouldHorizontalFlip {
                // ImageLayer
                // CGDrawingLayer
                let swiftUIImageLayerClassName = "SW1hZ2VMYXllcg==".decodeBase64String()
                let swiftUITextLayerClassName = "Q0dEcmF3aW5nTGF5ZXI=".decodeBase64String()
                let layerClassName = String(describing: type(of: self.layer))
                if layerClassName == swiftUITextLayerClassName {
                    view.viewType = .normal
                } else if layerClassName == swiftUIImageLayerClassName {
                    var resultViewType = LayoutFlipViewType.normal
                    if let contents = self.layer.contents as? CFTypeRef,
                       CFGetTypeID(contents) == CGImage.typeID {
                        let image = self.layer.contents as! CGImage
                        for imageName in gNamesOfImagesWithDirection {
                            let imageWithDirection = UIImage(
                                named: imageName,
                                in: Bundle(for: FireworkVideoSDK.self),
                                compatibleWith: nil
                            )?.cgImage
                            if image == imageWithDirection {
                                resultViewType = .flip
                                break
                            }
                        }
                    }
                    view.viewType = resultViewType
                }
            }

            if view.layer.sublayers?.first(where: { layer in
                layer is AVPlayerLayer
            }) != nil, AppLanguageManager.shared.shouldHorizontalFlip {
                view.viewType = .normal
            }
        }
    }
}
