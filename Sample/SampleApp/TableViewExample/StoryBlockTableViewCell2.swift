//
//  StoryBlockTableViewCell2.swift
//  SampleApp
//
//  Created by linjie jiang on 8/21/24.
//

import UIKit
import FireworkVideoUI
import FireworkVideo

class StoryBlockViewTableViewCell2: UITableViewCell {
    static let id = "\(StoryBlockViewTableViewCell2.self)"

    var source: StoryBlockContentSource?
    var indexPath: IndexPath?

    var storyBlockView: StoryBlockView? {
        didSet {
            if storyBlockView != oldValue {
                if let oldStoryBlockView = oldValue,
                   oldStoryBlockView.superview == self.contentView {
                    oldStoryBlockView.removeFromSuperview()
                }
                updateStoryBlockView()
            }
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func updateStoryBlockView() {
        guard let storyBlockView = storyBlockView else {
            return
        }
        storyBlockView.delegate = self
        var viewConfiguration = StoryBlockConfiguration()
        viewConfiguration.autoplay.isEnabled = false
        storyBlockView.viewConfiguration = viewConfiguration

        storyBlockView.translatesAutoresizingMaskIntoConstraints = false
        if storyBlockView.superview != contentView {
            if storyBlockView.superview != nil {
                storyBlockView.removeFromSuperview()
            }
            contentView.addSubview(storyBlockView)
        }
        NSLayoutConstraint.activate([
            storyBlockView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            storyBlockView.topAnchor.constraint(equalTo: contentView.topAnchor),
            storyBlockView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            storyBlockView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
}

extension StoryBlockViewTableViewCell2: StoryBlockViewControllerDelegate {
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
