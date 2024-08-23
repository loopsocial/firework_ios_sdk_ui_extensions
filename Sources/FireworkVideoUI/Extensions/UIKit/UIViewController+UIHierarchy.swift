//
//  File.swift
//
//  Created by linjie jiang on 8/14/24.
//

import UIKit

public extension UIViewController {
    func attachChild(
        _ childViewController: UIViewController,
        to container: UIView
    ) {
        guard childViewController.parent == nil else {
            return
        }

        addChild(childViewController)
        container.addSubview(childViewController.view)
        childViewController.view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            childViewController.view.topAnchor.constraint(equalTo: container.topAnchor),
            childViewController.view.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            childViewController.view.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            childViewController.view.leadingAnchor.constraint(equalTo: container.leadingAnchor),
        ])
        childViewController.didMove(toParent: self)
    }

    func detachFromParent() {
        guard self.parent != nil else {
            return
        }

        self.willMove(toParent: nil)
        self.removeFromParent()
        self.view.removeFromSuperview()
    }
}
