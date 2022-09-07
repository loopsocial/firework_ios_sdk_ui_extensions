//
//  FeedViewCache.swift
//  SampleApp
//
//  Created by Luke Davis on 9/1/22.
//

import UIKit
import FireworkVideo
import FireworkVideoUI

class FeedViewCache {
    private var cachedFeedViews: [IndexPath: VideoFeedView] = [:]

    func fetchOrCreateFeedView(
        for source: VideoFeedContentSource,
        at indexPath: IndexPath
    ) -> VideoFeedView {
        if let feed = cachedFeedViews[indexPath] { return feed }
        let feed = VideoFeedView(source: source)
        cachedFeedViews[indexPath] = feed
        return feed
    }
}
