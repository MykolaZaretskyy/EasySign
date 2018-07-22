//
//  FilesManagerService.swift
//  EasySign
//
//  Created by Mykola Zaretskyy on 7/22/18.
//  Copyright © 2018 Mykola Zaretskyy. All rights reserved.
//

import Foundation
import UIKit

class FilesManagerService{
    
    func writeFile(_ image: UIImage, _ imgName: String) -> Bool {
        let imageData = UIImageJPEGRepresentation(image, 1)
        let relativePath = imgName
        let path = self.documentsPathForFileName(name: relativePath)
        
        do {
            try imageData?.write(to: path, options: .atomic)
        } catch {
            return false
        }
        return true
    }
    
    func readFile(_ name: String) -> UIImage? {
        let fullPath = self.documentsPathForFileName(name: name)
        
        if FileManager.default.fileExists(atPath: fullPath.path){
            return UIImage(contentsOfFile: fullPath.path)!
        }
        
        return nil
    }
}

extension FilesManagerService{
    func documentsPathForFileName(name: String) -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let path = paths[0]
        let fullPath = path.appendingPathComponent(name)
        return fullPath
    }
}
