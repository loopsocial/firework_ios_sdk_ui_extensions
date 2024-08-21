//
//  StoryBlockViewTableViewCell.swift
//  SampleApp
//
//  Created by linjie jiang on 8/16/24.
//

import UIKit
import FireworkVideoUI
import FireworkVideo

class StoryBlockTableViewCell: UITableViewCell {
    static let id = "\(StoryBlockTableViewCell.self)"

    var source: StoryBlockContentSource?
    var indexPath: IndexPath?

    private var storyBlockView: StoryBlockView?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func updateSourceAndIndexPath(
        source: StoryBlockContentSource,
        indexPath: IndexPath
    ) {
        if !canReuseVideoFeedView(source: source, indexPath: indexPath) {
            storyBlockView?.removeFromSuperview()
            createVideoFeedView(source: source)
        }

        self.source = source
        self.indexPath = indexPath
    }

    private func canReuseVideoFeedView(
        source: StoryBlockContentSource,
        indexPath: IndexPath
    ) -> Bool {
        return source == self.source && indexPath == self.indexPath
    }

    private func createVideoFeedView(source: StoryBlockContentSource) {
        let storyBlockView = StoryBlockView(source: source)
        storyBlockView.delegate = self
        var viewConfiguration = StoryBlockConfiguration()
        viewConfiguration.autoplay.isEnabled = false
        storyBlockView.viewConfiguration = viewConfiguration

        storyBlockView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(storyBlockView)
        NSLayoutConstraint.activate([
            storyBlockView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            storyBlockView.topAnchor.constraint(equalTo: contentView.topAnchor),
            storyBlockView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            storyBlockView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
        self.storyBlockView = storyBlockView
    }
}

extension StoryBlockTableViewCell: StoryBlockViewControllerDelegate {
    func storyBlockDidLoadFeed(
        _ viewController: StoryBlockViewController
    ) {

    }

    func storyBlock(
        _ viewController: StoryBlockViewController,
        didFailToLoadFeed error: StoryBlockError
    ) {

    }
}
