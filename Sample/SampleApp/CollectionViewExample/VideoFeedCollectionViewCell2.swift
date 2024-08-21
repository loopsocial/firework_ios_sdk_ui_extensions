//
//  FeedCollectionViewCell2.swift
//  SampleApp
//
//  Created by linjie jiang on 8/16/24.
//

import UIKit
import FireworkVideoUI
import FireworkVideo

class VideoFeedCollectionViewCell2: UICollectionViewCell {
    static let id = "\(VideoFeedCollectionViewCell2.self)"

    var source: VideoFeedContentSource?
    var indexPath: IndexPath?

    var videoFeedView: VideoFeedView? {
        didSet {
            if videoFeedView != oldValue {
                if let oldVideoFeedView = oldValue,
                   oldVideoFeedView.superview == self.contentView {
                    oldVideoFeedView.removeFromSuperview()
                }
                updateVideoFeedView()
            }
        }
    }

    private func updateVideoFeedView() {
        guard let videoFeedView = videoFeedView else {
            return
        }
        videoFeedView.delegate = self
        var viewConfiguration = VideoFeedContentConfiguration()
        viewConfiguration.itemView.autoplay.isEnabled = true
        videoFeedView.viewConfiguration = viewConfiguration

        videoFeedView.translatesAutoresizingMaskIntoConstraints = false
        if videoFeedView.superview != contentView {
            if videoFeedView.superview != nil {
                videoFeedView.removeFromSuperview()
            }
            contentView.addSubview(videoFeedView)
        }
        NSLayoutConstraint.activate([
            videoFeedView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            videoFeedView.topAnchor.constraint(equalTo: contentView.topAnchor),
            videoFeedView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            videoFeedView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
}

extension VideoFeedCollectionViewCell2: VideoFeedViewControllerDelegate {
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
