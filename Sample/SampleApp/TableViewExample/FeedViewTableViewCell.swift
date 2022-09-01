//
//  FeedViewTableViewCell.swift
//  SampleApp
//
//  Created by Luke Davis on 9/1/22.
//

import UIKit
import FireworkVideoUI

class FeedViewTableViewCell: UITableViewCell {
    static let id = "\(FeedViewTableViewCell.self)"

    var feed: VideoFeedView? {
        didSet {
            if oldValue != nil && feed == nil {
                oldValue?.removeFromSuperview()
            }
            updateFeed()
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
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
