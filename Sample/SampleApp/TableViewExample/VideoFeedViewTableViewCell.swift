//
//  FeedViewTableViewCell.swift
//  SampleApp
//
//  Created by Luke Davis on 9/1/22.
//

import UIKit
import FireworkVideoUI
import FireworkVideo

class VideoFeedViewTableViewCell: UITableViewCell {
    static let id = "\(VideoFeedViewTableViewCell.self)"

    var source: VideoFeedContentSource?
    var indexPath: IndexPath?

    private var videoFeedView: VideoFeedView?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func updateSourceAndIndexPath(
        source: VideoFeedContentSource,
        indexPath: IndexPath
    ) {
        if !canReuseVideoFeedView(source: source, indexPath: indexPath) {
            videoFeedView?.removeFromSuperview()
            createVideoFeedView(source: source)
        }

        self.source = source
        self.indexPath = indexPath
    }

    private func canReuseVideoFeedView(
        source: VideoFeedContentSource,
        indexPath: IndexPath
    ) -> Bool {
        return source == self.source && indexPath == self.indexPath
    }

    private func createVideoFeedView(source: VideoFeedContentSource) {
        let videoFeedView = VideoFeedView(source: source)
        videoFeedView.delegate = self
        var viewConfiguration = VideoFeedContentConfiguration()
        viewConfiguration.itemView.autoplay.isEnabled = true
        viewConfiguration.playerView.playbackButton.isHidden = false
        videoFeedView.viewConfiguration = viewConfiguration

        videoFeedView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(videoFeedView)
        NSLayoutConstraint.activate([
            videoFeedView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            videoFeedView.topAnchor.constraint(equalTo: contentView.topAnchor),
            videoFeedView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            videoFeedView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
        self.videoFeedView = videoFeedView
    }
}

extension VideoFeedViewTableViewCell: VideoFeedViewControllerDelegate {
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
