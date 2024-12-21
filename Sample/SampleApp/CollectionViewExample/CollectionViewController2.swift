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
    let videoFeedViewCache = VideoFeedViewCache(capacity: 5)
    let storyBlockViewCache = StoryBlockViewCache(capacity: 2)

    enum Item {
        case text(String)
        case videoFeed(VideoFeedContentSource)
        case storyBlock(StoryBlockContentSource)
    }

    lazy var items: [Item] = [
        .text("Non-feed Cell"),
        .videoFeed(.channel(channelID: "bJDywZ")),
        .text("Non-feed Cell"),
        .videoFeed(.channelPlaylist(channelID: "bJDywZ", playlistID: "g206q5")),
        .text("Non-feed Cell"),
        .videoFeed(.channel(channelID: "bJDywZ")),
        .text("Non-feed Cell"),
        .storyBlock(.channelPlaylist(channelID: "bJDywZ", playlistID: "g206q5")),
        .text("Non-feed Cell"),
        .storyBlock(.channel(channelID: "bJDywZ")),
        .text("Non-feed Cell"),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(
            VideoFeedCollectionViewCell2.self,
            forCellWithReuseIdentifier: VideoFeedCollectionViewCell2.id
        )
        collectionView.register(
            StoryBlockViewCollectionViewCell2.self,
            forCellWithReuseIdentifier: StoryBlockViewCollectionViewCell2.id
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
        switch items[indexPath.row] {
        case .text:
            return CGSize(width: collectionView.bounds.width, height: 100)
        case .videoFeed:
            return CGSize(width: collectionView.bounds.width, height: 240)
        case .storyBlock:
            return CGSize(width: collectionView.bounds.width, height: 500)
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch items[indexPath.row] {
        case .text(let text):
            let textCell = collectionView.dequeueReusableCell(withReuseIdentifier: LabelCollectionViewCell.id, for: indexPath) as! LabelCollectionViewCell
            textCell.text = text
            return textCell
        case .videoFeed(let source):
            let videoFeedCell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoFeedCollectionViewCell2.id, for: indexPath) as! VideoFeedCollectionViewCell2
            let videoFeedView = videoFeedViewCache.getOrCreateVideoFeedView(
                source: source,
                indexPath: indexPath
            )
            videoFeedCell.embed(videoFeedView)
            return videoFeedCell
        case .storyBlock(let source):
            let storyBlockCell = collectionView.dequeueReusableCell(withReuseIdentifier: StoryBlockViewCollectionViewCell2.id, for: indexPath) as! StoryBlockViewCollectionViewCell2
            let storyBlockView = storyBlockViewCache.getOrCreateVideoFeedView(
                source: source,
                indexPath: indexPath
            )
            storyBlockCell.embed(storyBlockView)
            return storyBlockCell
        }
    }
}
