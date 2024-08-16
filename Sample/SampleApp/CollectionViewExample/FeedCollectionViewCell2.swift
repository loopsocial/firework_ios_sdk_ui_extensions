//
//  FeedCollectionViewCell2.swift
//  SampleApp
//
//  Created by linjie jiang on 8/16/24.
//

import UIKit
import FireworkVideoUI
import FireworkVideo

class FeedCollectionViewCell2: UICollectionViewCell {
    static let id = "\(FeedCollectionViewCell2.self)"

    var source: VideoFeedContentSource?
    var indexPath: IndexPath?

    var feedView: VideoFeedView? {
        didSet {
            if feedView != oldValue {
                if let oldFeedView = oldValue,
                   oldFeedView.superview == self.contentView {
                    oldFeedView.removeFromSuperview()
                }
                updateFeedView()
            }
        }
    }

    private func updateFeedView() {
        guard let feedView = feedView else {
            return
        }
        feedView.delegate = self
        var viewConfiguration = VideoFeedContentConfiguration()
        viewConfiguration.itemView.autoplay.isEnabled = true
        feedView.viewConfiguration = viewConfiguration

        feedView.translatesAutoresizingMaskIntoConstraints = false
        if feedView.superview != contentView {
            if feedView.superview != nil {
                feedView.removeFromSuperview()
            }
            contentView.addSubview(feedView)
        }
        NSLayoutConstraint.activate([
            feedView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            feedView.topAnchor.constraint(equalTo: contentView.topAnchor),
            feedView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            feedView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
}

extension FeedCollectionViewCell2: VideoFeedViewControllerDelegate {
    func videoFeedDidLoadFeed(
        _ viewController: VideoFeedViewController
    ) {

    }

    func videoFeed(
        _ viewController: VideoFeedViewController,
        didFailToLoadFeed error: VideoFeedError
    ) {

    }
}
