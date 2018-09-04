//
//  Tile.swift
//  MazeSolverRenderer
//
//  Created by AnTeng Lin on 3/9/18.
//  Copyright © 2018 Anteng Lin. All rights reserved.
//

import UIKit

enum Direction {
    case north
    case west
    case south
    case east
}

struct Location {
    var x: Int
    var y: Int
    
    static func +(lhs: Location, rhs: Location) -> Location {
        return Location(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
}

class Tile {
    var lock: String?
    var room: Room?
    var location: Location
    var image: UIImage?
    var id: String
    
    var tileURL: String? {
        return room?.tileUrl
    }
    
    init(id: String? = nil,
        lock: String? = nil,
        room: Room? = nil,
        location: Location,
        image: UIImage? = nil) {
        
        if let id = id {
            self.id = id
        } else {
            self.id = room?.id ?? ""
        }
        
        self.lock = lock
        self.room = room
        self.location = location
        self.image = image
    }
}

extension Tile {
    static func newTile(from room: DirectionRoom?, direction: Direction, location: Location) -> Tile? {
        guard let room = room else { return nil }
        
        let vector: Location
        switch direction {
        case .north:
            vector = Location(x: 0, y: 1)
        case .west:
            vector = Location(x: -1, y: 0)
        case .south:
            vector = Location(x: 0, y: -1)
        case .east:
            vector = Location(x: 1, y: 0)
        }
        
        let tile = Tile(id: room.room, lock: room.lock, location: location + vector)
        return tile
    }
}
