//
//  File.swift
//  
//  Created by linjie jiang on 8/16/24.
//

import UIKit

extension IndexPath {
    var cacheKey: String {
        "IndexPath:section:\(section)_item:\(item)_row:\(row)"
    }
}
