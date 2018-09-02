//
//  ImageDownloader.swift
//  MazeSolverRenderer
//
//  Created by AnTeng Lin on 2/9/18.
//  Copyright © 2018 Anteng Lin. All rights reserved.
//

import Foundation
import UIKit

enum Result<T> {
    case success(T)
    case failure(Error)
}

enum ImageDownloadError: Error {
    case nilImage
    case invalidData
}

class ImageDownloader {
    static let shared = ImageDownloader()
    private init() {}

    private var queue = DispatchQueue(label: "com.maze.tony", attributes: .concurrent)

    func download(with url: URL, completionHandler: @escaping (Result<UIImage>) -> ()) {
        queue.async {
            do {
                guard let image = try UIImage(data: Data(contentsOf: url)) else {
                    DispatchQueue.main.async {
                        completionHandler(Result.failure(ImageDownloadError.invalidData))
                    }
                    return
                }

                completionHandler(Result.success(image))
            } catch {
                print("Image downloader error: \(error)")
                DispatchQueue.main.async {
                    completionHandler(Result.failure(ImageDownloadError.nilImage))
                }
            }
        }
    }
}
