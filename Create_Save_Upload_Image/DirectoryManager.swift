//
//  DirectoryManager.swift
//  Create_Save_Upload_Image
//
//  Created by TrinhThai on 10/22/20.
//  Copyright © 2020 Trinh Thai. All rights reserved.
//

import UIKit

class DirectoryManager {
    
    let fileManager = FileManager.default
    var folder: FolderType = .final

    enum FolderType: String {
        case final = "Final"
        
        func getURL() -> URL? {
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            guard let documentDirectory = paths.first else { return nil }
            let documentURL = URL(fileURLWithPath: documentDirectory)
            switch self {
            case .final:
                return documentURL.appendingPathComponent(self.rawValue, isDirectory: true)
            }
        }
    }
    
    init(folder: FolderType) {
        self.folder = folder
    }
    
    func createDirectory() {
        guard let folderURL = folder.getURL() else { return }
        guard !fileManager.fileExists(atPath: folderURL.absoluteString) else { return }
        do {
            try fileManager.createDirectory(atPath: folderURL.absoluteString, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print("Can not create Directory")
        }
    }
    
    func saveImage(image: UIImage, fileName: String) {
        guard let folderURL = folder.getURL() else { return }
        if !fileManager.fileExists(atPath: folderURL.absoluteString) {
            createDirectory()
        }
        guard let imageData = image.pngData() else { return }
        let imageURL = folderURL.appendingPathComponent("\(fileName).png")
        do {
            try imageData.write(to: imageURL)
        } catch {
            print("Error: \(error)")
        }
    }
}
