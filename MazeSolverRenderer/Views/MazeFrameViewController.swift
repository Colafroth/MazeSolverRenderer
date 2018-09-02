//
//  MazeFrameViewController.swift
//  MazeSolverRenderer
//
//  Created by AnTeng Lin on 2/9/18.
//  Copyright © 2018 Anteng Lin. All rights reserved.
//

import UIKit

class MazeFrameViewController: UIViewController {

    var viewModel = MazeFrameViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .blue

        view.frame = CGRect(x: 0, y: 0, width: 200, height: 200)

        viewModel.fetchFirstTile()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        guard let superview = view.superview else { return }
        view.center = superview.center
    }
}
