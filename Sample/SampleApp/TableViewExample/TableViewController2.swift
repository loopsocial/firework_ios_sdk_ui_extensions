//
//  TableViewController2.swift
//  SampleApp
//
//  Created by linjie jiang on 8/16/24.
//

import UIKit
import FireworkVideo
import FireworkVideoUI

class TableViewController2: UITableViewController {
    var feedViewCache = VideoFeedViewCache(capacity: 5)

    enum Item {
        case text(String)
        case videoFeed(VideoFeedContentSource)
    }

    lazy var items: [Item] = [
        .text("Non-feed Cell"),
        .videoFeed(.discover),
        .text("Non-feed Cell"),
        .text("Non-feed Cell"),
        .videoFeed(.channelPlaylist(channelID: "bJDywZ", playlistID: "g206q5")),
        .text("Non-feed Cell"),
        .text("Non-feed Cell"),
        .videoFeed(.channel(channelID: "bJDywZ")),
        .text("Non-feed Cell"),
        .text("Non-feed Cell"),
        .videoFeed(.discover),
        .text("Non-feed Cell"),
        .text("Non-feed Cell"),
        .videoFeed(.discover),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(
            FeedViewTableViewCell2.self,
            forCellReuseIdentifier: FeedViewTableViewCell2.id
        )
        tableView.register(
            LabelTableViewCell.self,
            forCellReuseIdentifier: LabelTableViewCell.id
        )
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 240
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch items[indexPath.row] {
        case .text(let text):
            let textCell = tableView.dequeueReusableCell(withIdentifier: LabelTableViewCell.id, for: indexPath) as! LabelTableViewCell
            textCell.textLabel?.text = text
            return textCell
        case .videoFeed(let source):
            let feedCell = tableView.dequeueReusableCell(withIdentifier: FeedViewTableViewCell2.id, for: indexPath) as! FeedViewTableViewCell2
            let feedView = feedViewCache.getOrCreateVideoFeedView(for: source, at: indexPath)
            feedCell.feedView = feedView
            return feedCell
        }
    }
}
