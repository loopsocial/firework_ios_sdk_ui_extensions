//
//  StoryBlockViewCache.swift
//
//  Created by linjie jiang on 8/21/24.
//

import UIKit
import FireworkVideo

public class StoryBlockViewCache {

    private let lruCache: LRUCache<String, StoryBlockView>

    public init(capacity: Int) {
        self.lruCache = LRUCache<String, StoryBlockView>(capacity: capacity)
    }

    public func getOrCreateVideoFeedView(
        source: StoryBlockContentSource,
        indexPath: IndexPath,
        adConfiguration: AdConfiguration = AdConfiguration()
    ) -> StoryBlockView {
        let cacheKey = "\(source.cacheKey)_\(indexPath.cacheKey)"
        if let storyBlockView = lruCache.get(cacheKey) {
            return storyBlockView
        }
        let newStoryBlockView = StoryBlockView(
            source: source,
            adConfiguration: adConfiguration
        )
        lruCache.put(cacheKey, value: newStoryBlockView)
        return newStoryBlockView
    }
}
