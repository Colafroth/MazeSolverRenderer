//
//  Room.swift
//  MazeSolverRenderer
//
//  Created by AnTeng Lin on 2/9/18.
//  Copyright © 2018 Anteng Lin. All rights reserved.
//

import Foundation

struct Room: Codable {
    var id: String
    var tileUrl: String?
    var rooms: Rooms?
}

struct Rooms: Codable {
    var north: DirectionRoom?
    var west: DirectionRoom?
    var south: DirectionRoom?
    var east: DirectionRoom?
}

struct DirectionRoom: Codable {
    var room: String?
    var lock: String?
}
