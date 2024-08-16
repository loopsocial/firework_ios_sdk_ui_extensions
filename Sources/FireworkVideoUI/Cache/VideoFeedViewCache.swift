//
//  File.swift
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
        for source: VideoFeedContentSource,
        at indexPath: IndexPath
    ) -> VideoFeedView {
        let cacheKey = "\(source.cacheKey)_\(indexPath.cacheKey)"
        if let videoFeedView = lruCache.get(cacheKey) {
            return videoFeedView
        }
        let newVideoFeedView = VideoFeedView(source: source)
        lruCache.put(cacheKey, value: newVideoFeedView)
        return newVideoFeedView
    }
}
