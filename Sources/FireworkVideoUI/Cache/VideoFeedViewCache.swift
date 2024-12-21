//
//  VideoFeedViewCache.swift
//  
//  Created by linjie jiang on 8/16/24.
//

import UIKit
import FireworkVideo

public class VideoFeedViewCache {

    private let lruCache: LRUCache<String, VideoFeedView>

    public init(capacity: Int) {
        self.lruCache = LRUCache<String, VideoFeedView>(capacity: capacity)
    }

    public func getOrCreateVideoFeedView(
        source: VideoFeedContentSource,
        indexPath: IndexPath? = nil,
        layout: VideoFeedLayout = VideoFeedHorizontalLayout(),
        adConfiguration: AdConfiguration = AdConfiguration()
    ) -> VideoFeedView {
        var cacheKey = "\(source.cacheKey)"
        if let indexPath = indexPath {
            cacheKey += "_\(indexPath.cacheKey)"
        }
        if let videoFeedView = lruCache.get(cacheKey) {
            return videoFeedView
        }
        let newVideoFeedView = VideoFeedView(
            layout: layout,
            source: source,
            adConfiguration: adConfiguration
        )
        lruCache.put(cacheKey, value: newVideoFeedView)
        return newVideoFeedView
    }
}
