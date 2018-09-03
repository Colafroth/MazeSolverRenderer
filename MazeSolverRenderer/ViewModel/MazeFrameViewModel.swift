//
//  MazeFrameViewModel.swift
//  MazeSolverRenderer
//
//  Created by AnTeng Lin on 2/9/18.
//  Copyright © 2018 Anteng Lin. All rights reserved.
//

import Foundation
import UIKit

protocol MazeFrameViewModelDelegate: class {
    func didSetTile(_ tile: Tile)
}

class MazeFrameViewModel {
    weak var delegate: MazeFrameViewModelDelegate?

    var tiles: ThreadSafeArray<Tile> {
        return processor.array
    }

    private lazy var processor: MazeProcessor = {
        let p = MazeProcessor()
        p.delegate = self
        return p
    }()

    func start() {
        processor.start()
    }

    func frame(for location: Location) -> CGRect {
        return processor.frame(for: location)
    }
}

extension MazeFrameViewModel: MazeProcessorDelegate {
    func didSetTile(_ tile: Tile) {
        delegate?.didSetTile(tile)
    }
}
