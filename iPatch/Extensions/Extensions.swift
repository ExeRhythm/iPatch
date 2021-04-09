//
//  FileManager+FilesExist.swift
//  iPatch
//
//  Created by Eamon Tracey.
//

import Foundation

extension FileManager {
    func filesExist(atFileURLS fileURLs: [URL]) -> Bool {
        for urlPath in fileURLs {
            if !self.fileExists(atPath: urlPath.path) {
                return false
            }
        }
        return true
    }
}

extension URL {
    var contents: [URL] {
        guard let items = try? FileManager.default.contentsOfDirectory(atPath: path) else { return [] }
        let urls = items.map { appendingPathComponent($0) }
        return urls
    }
    var isDirectory: Bool {
        return (try? resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory ?? false
    }
    func delete() {
        try? FileManager.default.removeItem(at: self)
    }
}
