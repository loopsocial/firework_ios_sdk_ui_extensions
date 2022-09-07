//
//  FeedCollectionViewCell.swift
//  SampleApp
//
//  Created by Luke Davis on 9/1/22.
//

import UIKit
import FireworkVideoUI

class FeedCollectionViewCell: UICollectionViewCell {
    static let id = "\(FeedCollectionViewCell.self)"

    var feed: VideoFeedView? {
        didSet {
            if oldValue != nil && feed == nil {
                oldValue?.removeFromSuperview()
            }
            updateFeed()
        }
    }

    override func prepareForReuse() {
        feed = nil
    }

    private func updateFeed() {
        guard let feed = feed else {
            return
        }
        contentView.addSubview(feed)
        feed.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            feed.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            feed.topAnchor.constraint(equalTo: contentView.topAnchor),
            feed.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            feed.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
}
