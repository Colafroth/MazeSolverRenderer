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
        var vm = MazeFrameViewModel(viewLength: view.bounds.size.width)
        vm.delegate = self
        return vm
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.start()
    }
}

private extension MazeFrameViewController {
    func render(with tile: Tile) {
        let tileView = TileView(tile: tile)
        view.addSubview(tileView)
        tileViews.append(tileView)

        if viewModel.shouldReRenderMaze {
            renderWhole()
        } else {
            tileView.frame = viewModel.frame(for: tileView.tile.location)
        }
    }

    func renderWhole() {
        tileViews.forEach {
            $0.frame = viewModel.frame(for: $0.tile.location)
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
