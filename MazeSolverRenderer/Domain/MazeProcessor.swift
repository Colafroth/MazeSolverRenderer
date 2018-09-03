//
//  MazeProcessor.swift
//  MazeSolverRenderer
//
//  Created by AnTeng Lin on 3/9/18.
//  Copyright © 2018 Anteng Lin. All rights reserved.
//

import Foundation

struct MazeInfo {
    var maxWidth = 0
    var maxHeight = 0
    var tileSize = 0
}

protocol MazeProcessorDelegate: class {
    func didSetTile(_ tile: Tile)
}

class MazeProcessor {
    private var stack = ThreadSafeStack<Tile>()
    private var array = ThreadSafeArray<Tile>()

    private var queue = DispatchQueue(label: "com.mazeprocessor.tony", attributes: .concurrent)
    private let manager = MazeNetworkManager()
    private var info = MazeInfo()
    private var imageDownloader = ImageDownloader()

    weak var delegate: MazeProcessorDelegate?

    func start() {
        manager.fetchFirstTile { result in
            switch result {
            case .success(let room):
                self.queue.async {
                    let tile = Tile(room: room, location: Location(x: 0, y: 0))
                    self.addToArray(tile)
                    self.fetchTileById(in: tile)
                }
            case .failure:
                self.start()
            }
        }
    }
}

private extension MazeProcessor {
    func process() {
        queue.async {
            guard let tile = self.stack.pop() else {
                print("Empty Stack")
                return
            }

            if tile.lock != nil {
                self.processLock(in: tile)
                return
            }

            self.fetchTileById(in: tile)
        }
    }

    func fetchTileById(in tile: Tile) {
        manager.fetchTile(with: tile.id) { result in
            switch result {
            case .success(let room):
                tile.room = room
                self.processRoom(in: tile)
            case .failure:
                self.fetchTileById(in: tile)
            }
        }
    }

    func processRoom(in tile: Tile) {
        downloadImage(for: tile) {
            guard let rooms = tile.room?.rooms else {
                print("Empty rooms error")
                return
            }

            let tiles = [Tile.newTile(from: rooms.north, direction: .north, location: tile.location),
                         Tile.newTile(from: rooms.west, direction: .west, location: tile.location),
                         Tile.newTile(from: rooms.south, direction: .south, location: tile.location),
                         Tile.newTile(from: rooms.east, direction: .east, location: tile.location)]

            tiles.forEach {
                self.addToArray($0)
            }
        }
    }

    func processLock(in tile: Tile) {
        guard let lock = tile.lock else {
            fatalError("Error having lock")
        }
        queue.async {
            let id = self.manager.unlock(with: lock)
            tile.room?.id = id
            self.fetchTileById(in: tile)
        }
    }
}

private extension MazeProcessor {
    func downloadImage(for tile: Tile, completionHandler: @escaping () -> ()) {
        guard let tileURLString = tile.tileURL,
            let tileURL = URL(string: tileURLString) else { return }

        imageDownloader.download(with: tileURL) { result in
            switch result {
            case .success(let image):
                tile.image = image
                self.delegate?.didSetTile(tile)
                completionHandler()
            case .failure:
                fatalError("Image downloading failure")
            }
        }
    }

    func addToArray(_ tile: Tile) {
        if array.contains(where: { $0.id == tile.id }) {
            return
        }

        array.append(tile)
    }
}
