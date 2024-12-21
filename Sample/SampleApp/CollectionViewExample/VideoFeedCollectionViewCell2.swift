//
//  FeedCollectionViewCell2.swift
//  SampleApp
//
//  Created by linjie jiang on 8/16/24.
//

import UIKit
import FireworkVideo
import FireworkVideoUI

class VideoFeedCollectionViewCell2: UICollectionViewCell {
    static let id = "\(VideoFeedCollectionViewCell2.self)"

    func embed(_ videoFeedView: VideoFeedView) {
        videoFeedView.delegate = self
        var viewConfiguration = VideoFeedContentConfiguration()
        viewConfiguration.itemView.autoplay.isEnabled = true
        viewConfiguration.playerView.playbackButton.isHidden = false
        videoFeedView.viewConfiguration = viewConfiguration

        videoFeedView.translatesAutoresizingMaskIntoConstraints = false
        if videoFeedView.superview != contentView {
            if videoFeedView.superview != nil {
                videoFeedView.removeFromSuperview()
            }
            for subview in contentView.subviews where subview is VideoFeedView {
                subview.removeFromSuperview()
            }
            contentView.addSubview(videoFeedView)
            NSLayoutConstraint.activate([
                videoFeedView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                videoFeedView.topAnchor.constraint(equalTo: contentView.topAnchor),
                videoFeedView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                videoFeedView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            ])
        }
    }
}

extension VideoFeedCollectionViewCell2: VideoFeedViewControllerDelegate {
    func videoFeedDidLoadFeed(
        _ viewController: VideoFeedViewController
    ) {
        debugPrint("Video feed loaded successfully.")
    }

    func videoFeed(
        _ viewController: VideoFeedViewController,
        didFailToLoadFeed error: VideoFeedError
    ) {
        debugPrint("Video feed did fail loading with error: \(error.localizedDescription)")
    }
}
