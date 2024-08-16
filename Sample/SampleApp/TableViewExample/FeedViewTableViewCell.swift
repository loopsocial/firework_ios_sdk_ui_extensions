//
//  FeedViewTableViewCell.swift
//  SampleApp
//
//  Created by Luke Davis on 9/1/22.
//

import UIKit
import FireworkVideoUI
import FireworkVideo

class FeedViewTableViewCell: UITableViewCell {
    static let id = "\(FeedViewTableViewCell.self)"

    var source: VideoFeedContentSource?
    var indexPath: IndexPath?

    private var feedView: VideoFeedView?

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
        if !canReuseFeedView(source: source, indexPath: indexPath) {
            feedView?.removeFromSuperview()
            createFeedView(source: source)
        }

        self.source = source
        self.indexPath = indexPath
    }

    private func canReuseFeedView(
        source: VideoFeedContentSource,
        indexPath: IndexPath
    ) -> Bool {
        return source == self.source && indexPath == self.indexPath
    }

    private func createFeedView(source: VideoFeedContentSource) {
        let feedView = VideoFeedView(source: source)
        feedView.delegate = self
        var viewConfiguration = VideoFeedContentConfiguration()
        viewConfiguration.itemView.autoplay.isEnabled = true
        feedView.viewConfiguration = viewConfiguration

        feedView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(feedView)
        NSLayoutConstraint.activate([
            feedView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            feedView.topAnchor.constraint(equalTo: contentView.topAnchor),
            feedView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            feedView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
        self.feedView = feedView
    }
}

extension FeedViewTableViewCell: VideoFeedViewControllerDelegate {
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
