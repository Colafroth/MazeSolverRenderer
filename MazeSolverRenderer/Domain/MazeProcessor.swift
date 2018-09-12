//
//  MazeProcessor.swift
//  MazeSolverRenderer
//
//  Created by AnTeng Lin on 3/9/18.
//  Copyright © 2018 Anteng Lin. All rights reserved.
//

import UIKit

class MazeInfo {
    var viewLength: CGFloat
    var maze: Maze

    var tileSize: CGFloat {
        let size = viewLength / CGFloat(length)
        maze.tileSize = size
        return size
    }
    
    var dense: Int {
        return tilesOnWidth * tilesOnHeight
    }

    init(viewLength: CGFloat, maze: Maze) {
        self.viewLength = viewLength
        self.maze = maze
    }
    
    func reset() {
        maze.smallestX = 0
        maze.largestX = 0
        maze.smallestY = 0
        maze.largestY = 0
    }

    func updateInfo(with tile: Tile) {
        if tile.location.x > maze.largestX {
            maze.largestX = tile.location.x
        } else if tile.location.x < maze.smallestX {
            maze.smallestX = tile.location.x
        }

        if tile.location.y > maze.largestY {
            maze.largestY = tile.location.y
        } else if tile.location.y < maze.smallestY {
            maze.smallestY = tile.location.y
        }
    }

    func x(of location: Location) -> CGFloat {
        return CGFloat(location.x - maze.smallestX) * tileSize + startingX
    }

    func y(of location: Location) -> CGFloat {
        return CGFloat(location.y - maze.smallestY) * tileSize + startingY
    }
}

private extension MazeInfo {
    var length: Int {
        return tilesOnWidth > tilesOnHeight ? tilesOnWidth : tilesOnHeight
    }
    
    var tilesOnWidth: Int {
        return maze.largestX - maze.smallestX + 1
    }
    
    var tilesOnHeight: Int {
        return maze.largestY - maze.smallestY + 1
    }
    
    var startingX: CGFloat {
        let width = CGFloat(tilesOnWidth) * tileSize
        let x = (viewLength - width) / 2
        maze.startingX = x
        return x
    }
    
    var startingY: CGFloat {
        let height = CGFloat(tilesOnHeight) * tileSize
        let y = (viewLength - height) / 2
        maze.startingY = y
        return y
    }
}

protocol MazeProcessorDelegate: class {
    func didSetTile(_ tile: Tile)
    func mazeDidComplete()
}

class MazeProcessor {
    var viewLength: CGFloat
    var info: MazeInfo
    var array = ThreadSafeArray<Tile>()

    private var stack = ThreadSafeStack<Tile>()
    private var queue = DispatchQueue(label: "com.mazeprocessor.tony", attributes: .concurrent)
    private let manager = MazeNetworkManager()
    private var imageDownloader = ImageDownloader()
    private var group = DispatchGroup()

    weak var delegate: MazeProcessorDelegate?

    init(viewLength: CGFloat) {
        self.viewLength = viewLength
        self.info = MazeInfo(viewLength: viewLength, maze: Maze())
    }
    
    func start() {
        group = DispatchGroup()

        fetchFirstTile()

        group.notify(queue: .main) {
            self.delegate?.mazeDidComplete()
        }
    }
    
    func reset() {
        info.reset()
        array.removeAll()
        stack.removeAll()
    }

    func frame(for location: Location) -> CGRect {
        return CGRect(x: info.x(of: location),
                      y: info.y(of: location),
                      width: info.tileSize,
                      height: info.tileSize)
    }
}

private extension MazeProcessor {
    func fetchFirstTile() {
        group.enter()
        queue.async {
            self.manager.fetchFirstTile { result in
                switch result {
                case .success(let room):
                    let tile = Tile(room: room, location: Location(x: 0, y: 0))
                    self.fetchTileById(in: tile)
                    self.group.leave()
                case .failure:
                    self.start()
                    self.group.leave()
                }
            }
        }
    }

    func process() {
        group.enter()
        queue.async {
            guard let tile = self.stack.pop() else {
                print("Empty Stack")
                self.group.leave()
                return
            }

            if tile.lock != nil {
                self.processLock(in: tile)
                self.group.leave()
                return
            }

            self.fetchTileById(in: tile)
            self.group.leave()
        }
    }

    func fetchTileById(in tile: Tile) {
        group.enter()
        manager.fetchTile(with: tile.id) { result in
            switch result {
            case .success(let room):
                tile.room = room
                
                if self.addToArray(tile) {
                    self.processRoom(in: tile)
                }
                self.group.leave()
            case .failure:
                self.fetchTileById(in: tile)
                self.group.leave()
            }
        }
    }

    func processRoom(in tile: Tile) {
        group.enter()
        downloadImage(for: tile) {
            guard let rooms = tile.room?.rooms else {
                print("Empty rooms error")
                self.group.leave()
                return
            }

            let tiles = [Tile.newTile(from: rooms.north, direction: .north, location: tile.location),
                         Tile.newTile(from: rooms.west, direction: .west, location: tile.location),
                         Tile.newTile(from: rooms.south, direction: .south, location: tile.location),
                         Tile.newTile(from: rooms.east, direction: .east, location: tile.location)]
                        .compactMap{ $0 }

            tiles.forEach {
                if self.addToStack($0) {
                    self.process()
                }
            }
            self.group.leave()
        }
    }

    func processLock(in tile: Tile) {
        guard let lock = tile.lock else {
            fatalError("Error having lock")
        }

        group.enter()

        queue.async {
            let id = self.manager.unlock(with: lock)
            tile.id = id
            self.fetchTileById(in: tile)
            self.group.leave()
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
                self.info.updateInfo(with: tile)
                self.delegate?.didSetTile(tile)
                completionHandler()
            case .failure:
                fatalError("Image downloading failure")
            }
        }
    }

    func addToArray(_ tile: Tile) -> Bool {
        if array.contains(where: { $0.id == tile.id }) {
            return false
        }

        array.append(tile)
        return true
    }
    
    func addToStack(_ tile: Tile) -> Bool {
        if array.contains(where: { $0.id == tile.id }) {
            return false
        }
        
        stack.push(tile)
        return true
    }
}
