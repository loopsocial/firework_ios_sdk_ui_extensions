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
    let videoFeedViewCache = VideoFeedViewCache(capacity: 3)
    let storyBlockViewCache = StoryBlockViewCache(capacity: 2)

    enum Item {
        case text(String)
        case videoFeed(VideoFeedContentSource)
        case storyBlock(StoryBlockContentSource)
    }

    lazy var items: [Item] = [
        .text("Non-feed Cell"),
        .videoFeed(.channel(channelID: "bJDywZ")),
        .text("Non-feed Cell"),
        .text("Non-feed Cell"),
        .videoFeed(.channelPlaylist(channelID: "bJDywZ", playlistID: "g206q5")),
        .text("Non-feed Cell"),
        .text("Non-feed Cell"),
        .videoFeed(.channel(channelID: "bJDywZ")),
        .text("Non-feed Cell"),
        .text("Non-feed Cell"),
        .storyBlock(.channelPlaylist(channelID: "bJDywZ", playlistID: "g206q5")),
        .text("Non-feed Cell"),
        .text("Non-feed Cell"),
        .storyBlock(.channel(channelID: "bJDywZ")),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(
            VideoFeedViewTableViewCell2.self,
            forCellReuseIdentifier: VideoFeedViewTableViewCell2.id
        )
        tableView.register(
            StoryBlockViewTableViewCell2.self,
            forCellReuseIdentifier: StoryBlockViewTableViewCell2.id
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
        switch items[indexPath.row] {
        case .text:
            return 100
        case .videoFeed:
            return 240
        case .storyBlock:
            return 500
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch items[indexPath.row] {
        case .text(let text):
            let textCell = tableView.dequeueReusableCell(withIdentifier: LabelTableViewCell.id, for: indexPath) as! LabelTableViewCell
            textCell.textLabel?.text = text
            return textCell
        case .videoFeed(let source):
            let videoFeedCell = tableView.dequeueReusableCell(withIdentifier: VideoFeedViewTableViewCell2.id, for: indexPath) as! VideoFeedViewTableViewCell2
            let videoFeedView = videoFeedViewCache.getOrCreateVideoFeedView(
                source: source,
                indexPath: indexPath
            )
            videoFeedCell.videoFeedView = videoFeedView
            return videoFeedCell
        case .storyBlock(let source):
            let storyBlockCell = tableView.dequeueReusableCell(withIdentifier: StoryBlockViewTableViewCell2.id, for: indexPath) as! StoryBlockViewTableViewCell2
            let storyBlockView = storyBlockViewCache.getOrCreateVideoFeedView(
                source: source, indexPath: indexPath
            )
            storyBlockCell.storyBlockView = storyBlockView
            return storyBlockCell
        }
    }
}
