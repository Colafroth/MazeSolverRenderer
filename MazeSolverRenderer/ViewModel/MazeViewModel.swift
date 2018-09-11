//
//  MazeViewModel.swift
//  MazeSolverRenderer
//
//  Created by AnTeng Lin on 10/9/18.
//  Copyright © 2018 Anteng Lin. All rights reserved.
//

import Foundation

protocol MazeViewModelDelegate: class {
    func timerDidTick(with timeText: String)
}

class MazeViewModel {
    weak var delegate: MazeViewModelDelegate?
    var childViewModel: MazeFrameViewModel!

    private var timer: Timer?
    private var startTime: Date!

    func start() {
        startTime = Date()

        stop()
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(tick), userInfo: nil, repeats: true)
    }

    private func stop() {
        timer?.invalidate()
        timer = nil
    }
}

private extension MazeViewModel {
    @objc
    func tick() {
        let elapsed = Date().timeIntervalSince(startTime)
        delegate?.timerDidTick(with: String(format: "%.1f", elapsed))
    }
}

extension MazeViewModel: MazeFrameChildViewModelDelegate {
    func mazeDidComplete() {
        stop()
    }
}
