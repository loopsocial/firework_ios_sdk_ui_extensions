//
//  UIImageView+AppLanguage.swift
//
//  Created by linjie jiang on 2023/2/22.
//

import UIKit
import FireworkVideo

private let FWImageNamesWithDirections: [String] = [
    "shopping-cart",
    "left-arrow",
    "right-arrow",
    "speaker-unmute",
    "speaker-mute"
]

extension UIImageView {
    static func swizzleImageViewMethodsForAppLanguage() {
        Swizzle.swizzleSelector(
            cls: self,
            originalSelector: #selector(UIImageView.didMoveToWindow),
            customSelector: #selector(UIImageView.fw_imageViewDidMoveToWindow))
        Swizzle.swizzleSelector(
            cls: self,
            originalSelector: #selector(setter: UIImageView.image),
            customSelector: #selector(UIImageView.fw_setImage(_:))
        )
        Swizzle.swizzleSelector(
            cls: self,
            originalSelector: #selector(UIImageView.awakeFromNib),
            customSelector: #selector(UIImageView.fw_imageViewAwakeFromNib)
        )
    }

    @objc func fw_imageViewDidMoveToWindow() {
        fw_imageViewDidMoveToWindow()
        updateViewType(self.image)
    }

    @objc func fw_setImage(_ image: UIImage?) {
        fw_setImage(image)
        updateViewType(image)
    }

    @objc func fw_imageViewAwakeFromNib() {
        self.fw_imageViewAwakeFromNib()
        updateViewType(self.image)
    }

    private func updateViewType(_ image: UIImage?) {
        self.viewType = shouldFlipImage(image) ? .flip : .auto
    }

    private func shouldFlipImage(_ image: UIImage?) -> Bool {
        guard let image = image else {
            return false
        }

        if AppLanguageManager.shared.shouldHorizontalFlip, self.isIOSSDKView {
            let iOSSDKBundle = Bundle(for: FireworkVideoSDK.self)

            for imageName in FWImageNamesWithDirections {
                let targetImage = UIImage(named: imageName, in: iOSSDKBundle, compatibleWith: nil)
                if image.isEqual(targetImage) {
                    return true
                }

                if let cgImage = image.cgImage,
                   let targetCgImage = targetImage?.cgImage,
                   cgImage == targetCgImage {
                    return true
                }

                if let ciImage = image.ciImage,
                   let targetCiImage = targetImage?.ciImage,
                   ciImage == targetCiImage {
                    return true
                }
            }
        }

        if AppLanguageManager.shared.shouldHorizontalFlip,
           image.flipsForRightToLeftLayoutDirection == true,
           self.isIOSSDKView {
            return true
        }

        return false
    }
}
