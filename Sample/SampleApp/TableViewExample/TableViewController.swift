//
//  TableViewController.swift
//  SampleApp
//
//  Created by Luke Davis on 9/1/22.
//

import UIKit
import FireworkVideo
import FireworkVideoUI

class TableViewController: UITableViewController {

    enum Item {
        case text(String)
        case videoFeed(VideoFeedContentSource)
        case storyBlock(StoryBlockContentSource)
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
        .storyBlock(.channelPlaylist(channelID: "bJDywZ", playlistID: "g206q5")),
        .text("Non-feed Cell"),
        .text("Non-feed Cell"),
        .storyBlock(.channel(channelID: "bJDywZ")),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(
            VideoFeedViewTableViewCell.self,
            forCellReuseIdentifier: VideoFeedViewTableViewCell.id
        )
        tableView.register(
            StoryBlockTableViewCell.self,
            forCellReuseIdentifier: StoryBlockTableViewCell.id
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
            let videoFeedCell = tableView.dequeueReusableCell(withIdentifier: VideoFeedViewTableViewCell.id, for: indexPath) as! VideoFeedViewTableViewCell
            videoFeedCell.updateSourceAndIndexPath(source: source, indexPath: indexPath)
            return videoFeedCell
        case .storyBlock(let source):
            let storyBlockCell = tableView.dequeueReusableCell(withIdentifier: StoryBlockTableViewCell.id, for: indexPath) as! StoryBlockTableViewCell
            storyBlockCell.updateSourceAndIndexPath(source: source, indexPath: indexPath)
            return storyBlockCell
        }
    }
}


