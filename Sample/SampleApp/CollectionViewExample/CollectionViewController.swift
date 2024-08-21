//
//  CollectionViewController.swift
//  SampleApp
//
//  Created by Luke Davis on 9/1/22.
//

import UIKit
import FireworkVideo
import FireworkVideoUI

class CollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    enum Item {
        case text(String)
        case videoFeed(VideoFeedContentSource)
        case storyBlock(StoryBlockContentSource)
    }

    lazy var items: [Item] = [
        .text("Non-feed Cell"),
        .videoFeed(.discover),
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
            VideoFeedCollectionViewCell.self,
            forCellWithReuseIdentifier: VideoFeedCollectionViewCell.id
        )
        collectionView.register(
            StoryBlockCollectionViewCell.self,
            forCellWithReuseIdentifier: StoryBlockCollectionViewCell.id
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
            let videoFeedCell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoFeedCollectionViewCell.id, for: indexPath) as! VideoFeedCollectionViewCell
            videoFeedCell.updateSourceAndIndexPath(source: source, indexPath: indexPath)
            return videoFeedCell
        case .storyBlock(let source):
            let storyBlockCell = collectionView.dequeueReusableCell(withReuseIdentifier: StoryBlockCollectionViewCell.id, for: indexPath) as! StoryBlockCollectionViewCell
            storyBlockCell.updateSourceAndIndexPath(source: source, indexPath: indexPath)
            return storyBlockCell
        }
    }
}
