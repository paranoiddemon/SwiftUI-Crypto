//
//  LocalFileManager.swift
//  Crypto
//
//  Created by forys on 2023-10-03.
//

import Foundation
import SwiftUI


class LocalFileManager {
    
    static let instance = LocalFileManager()
    
    private init() {
        
    }
    
    func saveIamge(image: UIImage, imageName: String, folderName: String) {
        // 如果文件夹不存在 需要提前创建
        createFolderIfNeeded(folderName: folderName)
        
        guard                       // optional使用guard
            let data = image.pngData(), // 多个条件要加逗号
            let url = getURLForImage(imageName: imageName, folderName: folderName)
        else { return }
        
       
        do {
            try data.write(to:url) // call can throw 需要catch
        } catch let error {
            print("Error saving image. \(error)")
        }
    }
    
    func getImage(imageName: String, folderName: String) -> UIImage? {
        guard let url = getURLForImage(imageName: imageName, folderName: folderName),
              FileManager.default.fileExists(atPath: url.path)
        else {
            return nil // 需要返回值
        }
        return UIImage(contentsOfFile: url.path)
    }
    
    private func createFolderIfNeeded(folderName: String){
        guard let url = getURLForFolder(folderName: folderName) else {return}
        
        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            } catch let error { // 绑定错误
                print("Error creating directory, FolderName: \(folderName). \(error)")
               
            }
        }
    }
    
    private func getURLForFolder(folderName: String) -> URL?  {
        guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
        else {
            return nil
        }
        return url.appendingPathComponent(folderName) // 在cache文件夹后面添加文件夹路径
    }
    
    private func getURLForImage(imageName: String, folderName: String) -> URL? {
        guard let folderURL = getURLForFolder(folderName: folderName)
        else {
            return nil
        }
        return folderURL.appendingPathComponent(imageName + ".png")
    }
}
