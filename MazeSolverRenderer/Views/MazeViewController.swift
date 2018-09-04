//
//  MazeViewController.swift
//  MazeSolverRenderer
//
//  Created by AnTeng Lin on 1/9/18.
//  Copyright © 2018 Anteng Lin. All rights reserved.
//

import UIKit

class MazeViewController: UIViewController {
    @IBOutlet private weak var mazeFrameContainerView: UIView!

    private lazy var mazeFrameViewController: MazeFrameViewController = {
        return MazeFrameViewController()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        basicSetup()
    }
}

private extension MazeViewController {
    func basicSetup() {
        addChildViewController(mazeFrameViewController)
        mazeFrameContainerView.addSubview(mazeFrameViewController.view)
        mazeFrameViewController.didMove(toParentViewController: self)
        mazeFrameViewController.view.frame = CGRect(x: 10, y: 10, width: mazeFrameContainerView.bounds.size.width - 20, height: mazeFrameContainerView.bounds.size.height - 20)
    }
}

