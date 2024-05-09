//
//  Swizzle.swift
//  
//  Created by linjie jiang on 2023/2/7.
//

import Foundation

public class Swizzle {
    public static func swizzleSelector(cls: AnyClass, originalSelector: Selector, customSelector: Selector) {
        guard let originalMethod = class_getInstanceMethod(cls, originalSelector) else { return }
        guard let customMethod = class_getInstanceMethod(cls, customSelector) else { return }

        if class_addMethod(
            cls,
            originalSelector,
            method_getImplementation(customMethod),
            method_getTypeEncoding(customMethod)
        ) {
            class_replaceMethod(
                cls,
                customSelector,
                method_getImplementation(originalMethod),
                method_getTypeEncoding(originalMethod)
            )
        } else {
            method_exchangeImplementations(originalMethod, customMethod)
        }
    }

    public static func swizzleClassSelector(cls: AnyClass, originalSelector: Selector, customSelector: Selector) {
        guard let originalMethod = class_getClassMethod(cls, originalSelector) else { return }
        guard let customMethod = class_getClassMethod(cls, customSelector) else { return }

        if class_addMethod(
            cls,
            originalSelector,
            method_getImplementation(customMethod),
            method_getTypeEncoding(customMethod)
        ) {
            class_replaceMethod(
                cls,
                customSelector,
                method_getImplementation(originalMethod),
                method_getTypeEncoding(originalMethod)
            )
        } else {
            method_exchangeImplementations(originalMethod, customMethod)
        }
    }
}
