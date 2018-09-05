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
    var viewLength: CGFloat
    
    weak var delegate: MazeFrameViewModelDelegate?
    
    var tiles: ThreadSafeArray<Tile> {
        return processor.array
    }
    
    private var previousDense: Int = 0
    var shouldReRenderMaze: Bool {
        if processor.info.dense != previousDense {
            previousDense = processor.info.dense
            return true
        }
        
        return false
    }

    private lazy var processor: MazeProcessor = {
        let p = MazeProcessor(viewLength: viewLength)
        p.delegate = self
        return p
    }()

    init(viewLength: CGFloat) {
        self.viewLength = viewLength
    }
    
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
