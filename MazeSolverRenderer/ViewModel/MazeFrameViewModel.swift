//
//  MazeFrameViewModel.swift
//  MazeSolverRenderer
//
//  Created by AnTeng Lin on 2/9/18.
//  Copyright © 2018 Anteng Lin. All rights reserved.
//

import Foundation

protocol MazeFrameViewModelDelegate: class {
    func didSetTile(_ tile: Tile)
}

class MazeFrameViewModel {
    weak var delegate: MazeFrameViewModelDelegate?
    

    private lazy var processor: MazeProcessor = {
        let p = MazeProcessor()
        p.delegate = self
        return p
    }()

    func start() {
        processor.start()
    }
}

extension MazeFrameViewModel: MazeProcessorDelegate {
    func didSetTile(_ tile: Tile) {
        delegate?.didSetTile(tile)
    }
}
