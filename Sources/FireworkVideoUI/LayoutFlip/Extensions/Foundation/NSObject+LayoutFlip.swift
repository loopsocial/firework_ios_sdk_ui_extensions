//
//  NSObject+LayoutFlip.swift
//
//  Created by linjie jiang on 4/25/23.
//

import Foundation

typealias ReloadClosure = () -> Void

extension NSObject {
    private struct AssociatedKeys {
        static var reloadClosures: UInt8 = 0
    }

    private var reloadClosures: [String: ReloadClosure] {
        get {
            let result = objc_getAssociatedObject(self, &AssociatedKeys.reloadClosures) as? [String: ReloadClosure]
            return result ?? [:]
        }

        set {
            objc_setAssociatedObject(
                self,
                &AssociatedKeys.reloadClosures,
                newValue,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }

    func performReload() {
        for (_, closure) in reloadClosures {
            closure()
        }
    }

    func addReloadClosure(key: String, reloadClosure: @escaping ReloadClosure) {
        reloadClosures[key] = reloadClosure
        reloadClosure()
    }
}
