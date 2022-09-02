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
    }

    private var cache: FeedViewCache = FeedViewCache()
    lazy var items: [Item] = [
        .text("Non-feed Cell"),
        .videoFeed(.discover),
        .text("Non-feed Cell"),
        .videoFeed(.discover),
        .text("Non-feed Cell"),
        .videoFeed(.discover),
        .text("Non-feed Cell"),
        .videoFeed(.discover),
        .text("Non-feed Cell"),
        .videoFeed(.discover),
        .text("Non-feed Cell"),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(
            FeedCollectionViewCell.self,
            forCellWithReuseIdentifier: FeedCollectionViewCell.id
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
        case .videoFeed(let feed):
            let feedCell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCollectionViewCell.id, for: indexPath) as! FeedCollectionViewCell
            feedCell.feed = cache.fetchOrCreateFeedView(for: feed, at: indexPath)
            return feedCell
        }
    }

}
