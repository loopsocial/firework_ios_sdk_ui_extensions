//
//  VideoFeedView.swift
//  FireworkVideoDebug
//
//  Created by Luke Davis on 8/29/22.
//

import UIKit
import FireworkVideo

open class VideoFeedView: UIView {

    private lazy var feedViewController: VideoFeedViewController = VideoFeedViewController(
        layout: VideoFeedHorizontalLayout(),
        source: .discover
    )

    public var delegate: VideoFeedViewControllerDelegate? {
        get { feedViewController.delegate }
        set { feedViewController.delegate = newValue }
    }

    open var viewConfiguration: VideoFeedContentConfiguration {
        get { feedViewController.viewConfiguration }
        set { feedViewController.viewConfiguration = newValue }
    }

    private var isControllerAttached: Bool {
        feedViewController.parent != nil && feedViewController.view.superview == self
    }

    init(frame: CGRect, feedViewController: VideoFeedViewController) {
        super.init(frame: frame)
        self.feedViewController = feedViewController
    }

    public init(
        frame: CGRect = .zero,
        source: VideoFeedContentSource = .discover
    ) {
        super.init(frame: frame)
        feedViewController = VideoFeedViewController(layout: VideoFeedHorizontalLayout(), source: source)
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    public func refresh() {
        feedViewController.refresh()
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        processBoundChange(within: findTopMostSuperview())
        observeScrollViewIfNeeded()
    }

    private func attachControllerIfNeeded() {
        guard !isControllerAttached, let firstVC = findClosestViewController() else { return }
        firstVC.addChild(feedViewController)
        self.addSubview(feedViewController.view)
        feedViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            feedViewController.view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            feedViewController.view.topAnchor.constraint(equalTo: self.topAnchor),
            feedViewController.view.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            feedViewController.view.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
        feedViewController.didMove(toParent: firstVC)
    }

    private func detachControllerIfNeeded() {
        guard isControllerAttached else { return }
        feedViewController.willMove(toParent: nil)
        feedViewController.removeFromParent()
        feedViewController.view.removeFromSuperview()
    }

    override open func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        if newSuperview == nil {
            removeObserverFromScrollViewIfNeeded()
        }
    }

    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if superview != nil {
            observeScrollViewIfNeeded()
        }
    }

    override public func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey : Any]?,
        context: UnsafeMutableRawPointer?
    ) {
        guard keyPath == "bounds" else { return }
        guard let layer = object as? CALayer else { return }
        guard let view = layer.delegate as? UIView else { return }
        processBoundChange(within: view.superview)
    }

    private var isObserving = false
    private func observeScrollViewIfNeeded() {
        guard !isObserving, let scrollView = findContainingScrollView() else { return }
        scrollView.layer.addObserver(self, forKeyPath: "bounds", options: [.new], context: nil)
        isObserving = true
    }

    private func removeObserverFromScrollViewIfNeeded() {
        guard isObserving, let scrollView = findContainingScrollView() else { return }
        scrollView.layer.removeObserver(self, forKeyPath: "bounds")
        isObserving = false
    }

    private func processBoundChange(within superview: UIView?) {
        guard let superview = superview else { return }
        let converted = self.convert(self.frame, to: superview)

        if converted.intersects(superview.bounds) {
            attachControllerIfNeeded()
        } else {
            detachControllerIfNeeded()
        }
    }

    private func findClosestViewController() -> UIViewController? {
        var next: UIResponder? = next
        while next != nil {
            if let vc = next as? UIViewController {
                return vc
            }
            next = next?.next
        }
        return nil
    }

    private func findTopMostSuperview() -> UIView? {
        var currentParent: UIView? = superview
        while currentParent != nil {
            if currentParent?.superview == nil {
                return currentParent
            }
            currentParent = currentParent?.superview
        }
        return nil
    }

    /**
     Special considerations need to be made when the view is nested within a scroll view.
     */
    private func findContainingScrollView() -> UIScrollView? {
        var currentParent: UIView? = superview
        while currentParent != nil {
            if let scroll = currentParent as? UIScrollView {
                return scroll
            }
            currentParent = currentParent?.superview
        }
        return nil
    }

}

class FeedTableCell: UITableViewCell {
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
