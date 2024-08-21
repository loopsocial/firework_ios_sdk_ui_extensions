//
//  File.swift
//  SampleApp
//
//  Created by linjie jiang on 8/16/24.
//

import UIKit
import FireworkVideoUI
import FireworkVideo

class VideoFeedViewTableViewCell2: UITableViewCell {
    static let id = "\(VideoFeedViewTableViewCell2.self)"

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

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func updateVideoFeedView() {
        guard let videoFeedView = videoFeedView else {
            return
        }
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

extension VideoFeedViewTableViewCell2: VideoFeedViewControllerDelegate {
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
