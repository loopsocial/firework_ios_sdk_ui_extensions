//
//  DispatchQueue+Once.swift
//
//  Created by Jeff Zheng on 2022/3/1.
//

import Foundation

public extension DispatchQueue {
    private static var _onceContainer = [String]()

    /// Execute a block only once.
    class func once(
        file: String = #file, function: String = #function, line: Int = #line, block: () -> Void
    ) {
        let token = file + ":" + function + ":" + String(line)
        once(token: token, block: block)
    }

    /// Execute a block only once.
    class func once(token: String, block: () -> Void) {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }

        guard !_onceContainer.contains(token) else {
            return
        }

        _onceContainer.append(token)
        block()
    }
}
