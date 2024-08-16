//
//  CollectionViewController2.swift
//  SampleApp
//
//  Created by linjie jiang on 8/16/24.
//

import UIKit
import FireworkVideo
import FireworkVideoUI

class CollectionViewController2: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var feedViewCache = VideoFeedViewCache(capacity: 5)

    enum Item {
        case text(String)
        case videoFeed(VideoFeedContentSource)
    }

    lazy var items: [Item] = [
        .text("Non-feed Cell"),
        .videoFeed(.discover),
        .text("Non-feed Cell"),
        .videoFeed(.channelPlaylist(channelID: "bJDywZ", playlistID: "g206q5")),
        .text("Non-feed Cell"),
        .videoFeed(.channel(channelID: "bJDywZ")),
        .text("Non-feed Cell"),
        .videoFeed(.discover),
        .text("Non-feed Cell"),
        .videoFeed(.discover),
        .text("Non-feed Cell"),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(
            FeedCollectionViewCell2.self,
            forCellWithReuseIdentifier: FeedCollectionViewCell2.id
        )
        collectionView.register(
            LabelCollectionViewCell.self,
            forCellWithReuseIdentifier: LabelCollectionViewCell.id
        )
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 240)
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch items[indexPath.row] {
        case .text(let text):
            let textCell = collectionView.dequeueReusableCell(withReuseIdentifier: LabelCollectionViewCell.id, for: indexPath) as! LabelCollectionViewCell
            textCell.text = text
            return textCell
        case .videoFeed(let source):
            let feedCell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCollectionViewCell2.id, for: indexPath) as! FeedCollectionViewCell2
            let feedView = feedViewCache.getOrCreateVideoFeedView(for: source, at: indexPath)
            feedCell.feedView = feedView
            return feedCell
        }
    }
}
