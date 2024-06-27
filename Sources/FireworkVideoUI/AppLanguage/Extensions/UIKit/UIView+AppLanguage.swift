//
//  UIView+AppLanguage.swift
//
//  Created by linjie jiang on 2023/3/11.
//

import UIKit
import FireworkVideo
import AVFoundation

private let gNamesOfImagesWithDirection: [String] = [
    "c3RyZWFtLWdhdGUtYmFjaw==".decodeBase64String(),
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

    private func updateViewTypeIfNeeded(_ view: UIView) {
        if view is FireworkPlayerView, AppLanguageManager.shared.shouldHorizontalFlip {
            view.viewType = .normal
        }

        let swiftUIImageLayerClassName = "SW1hZ2VMYXllcg==".decodeBase64String()
        let swiftUITextLayerClassName = "Q0dEcmF3aW5nTGF5ZXI=".decodeBase64String()
        let layerClassName = String(describing: type(of: self.layer))

        if AppLanguageManager.shared.shouldHorizontalFlip,
           layerClassName == swiftUITextLayerClassName ||
            layerClassName == swiftUIImageLayerClassName {
            view.viewType = .normal
        }

        DispatchQueue.main.async {
            if AppLanguageManager.shared.shouldHorizontalFlip,
                layerClassName == swiftUIImageLayerClassName,
               let contents = self.layer.contents as? CFTypeRef,
               CFGetTypeID(contents) == CGImage.typeID {
                let image = self.layer.contents as! CGImage
                for imageName in gNamesOfImagesWithDirection {
                    let imageWithDirection = UIImage(
                        named: imageName,
                        in: Bundle(for: FireworkVideoSDK.self),
                        compatibleWith: nil
                    )?.cgImage
                    if image == imageWithDirection {
                        view.viewType = .flip
                        break
                    }
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
