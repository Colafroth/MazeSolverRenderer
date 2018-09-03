//
//  TileView.swift
//  MazeSolverRenderer
//
//  Created by AnTeng Lin on 3/9/18.
//  Copyright © 2018 Anteng Lin. All rights reserved.
//

import Foundation
import UIKit

class TileView: UIImageView {
    var tile: Tile!

    override init(image: UIImage?) {
        super.init(image: image)
    }

    convenience init(tile: Tile) {
        self.init(image: tile.image)
        self.tile = tile
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
