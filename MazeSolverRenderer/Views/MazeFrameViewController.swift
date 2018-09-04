//
//  MazeFrameViewController.swift
//  MazeSolverRenderer
//
//  Created by AnTeng Lin on 2/9/18.
//  Copyright © 2018 Anteng Lin. All rights reserved.
//

import UIKit

class MazeFrameViewController: UIViewController {
    private var tileViews = [TileView]()

    private lazy var viewModel: MazeFrameViewModel = {
        var vm = MazeFrameViewModel()
        vm.delegate = self
        return vm
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.start()
    }
}

private extension MazeFrameViewController {
    func render(with tile: Tile) {
        print("Rendering... \(tile.room)")
        let tileView = TileView(tile: tile)
        view.addSubview(tileView)
        tileViews.append(tileView)

        renderWhole()
    }

    func renderWhole() {
        tileViews.forEach {
            $0.frame = viewModel.frame(for: $0.tile.location)
            print("frame: \($0.frame)")
        }
    }
}

extension MazeFrameViewController: MazeFrameViewModelDelegate {
    func didSetTile(_ tile: Tile) {
        DispatchQueue.main.async {
            self.render(with: tile)
        }
    }
}
