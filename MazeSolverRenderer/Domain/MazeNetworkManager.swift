//
//  MazeNetworkManager.swift
//  MazeSolverRenderer
//
//  Created by AnTeng Lin on 3/9/18.
//  Copyright © 2018 Anteng Lin. All rights reserved.
//

import TakeHomeTask

enum MazeNetworkError: Error {
    case general
}

class MazeNetworkManager {
    private let manager = MazeManager()

    func fetchFirstTile(completionHandler: @escaping (Result<Room>) -> ()) {
        manager.fetchStartRoom { (data, error) in
            print("WTF???")
            self.processResponse(data: data, error: error, completionHandler: completionHandler)
        }
    }

    func fetchTile(with id: String, completionHandler: @escaping (Result<Room>) -> ()) {
        manager.fetchRoom(withIdentifier: id) { (data, error) in
            print("id: \(id)")
            self.processResponse(data: data, error: error, completionHandler: completionHandler)
        }
    }

    func unlock(with lock: String) -> String {
        return manager.unlockRoom(withLock: lock)
    }
}

private extension MazeNetworkManager {
    func processResponse(data: Data?, error: Error?, completionHandler: @escaping (Result<Room>) -> ()) {
        if let error = error {
            print("error: \(error)")
            completionHandler(Result.failure(MazeNetworkError.general))
            return
        }

        guard let data = data else {
            completionHandler(Result.failure(MazeNetworkError.general))
            return
        }

        var room: Room
        do {
            room = try JSONDecoder().decode(Room.self, from: data)
            completionHandler(Result.success(room))
        } catch {
            print(error)
            completionHandler(Result.failure(MazeNetworkError.general))
        }
    }
}
