//
//  MazeFrameViewModel.swift
//  MazeSolverRenderer
//
//  Created by AnTeng Lin on 2/9/18.
//  Copyright © 2018 Anteng Lin. All rights reserved.
//

import Foundation
import TakeHomeTask

struct MazeFrameViewModel {


    func fetchFirstTile() {
        MazeManager().fetchStartRoom { (data, error) in
            if let error = error {
                print("error: \(error)")
                return
            }

            guard let data = data else { return }
        }
    }
}
