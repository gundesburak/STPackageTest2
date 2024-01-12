//
//  LoggingMessageHandler.swift
//  Misli.com
//
//  Created by Oktay Tanrıkulu on 3.11.2023.
//  Copyright © 2023 Misli.com. All rights reserved.
//

import Foundation
import WebKit
import ZIPFoundation

public protocol LoggingMessageProtocol {
    func closeFile()
    func removeZipFiles()
    func saveFile(completion: @escaping (_ destination: URL?) -> Void)
    func saveFolder(completion: @escaping (_ destination: URL?) -> Void)
}

public final class LoggingMessageHandler: NSObject {
    
    let fileName: String
    let folderName: String
    let fileManager = FileManager.default
    var fileHandle: FileHandle?
    
    public init(fileName: String, folderName: String) {
        self.fileName = fileName
        self.folderName = folderName
    }
    
    enum LevelType: String {
        case LOG
        case WARNING
        case ERROR
        case DEBUG
        
        init(flag: Character?) {
            guard let flag = flag else {
                self = .LOG
                return
            }
            switch flag {
            case "📗": self = .LOG
            case "📙": self = .WARNING
            case "📕": self = .ERROR
            case "📘": self = .DEBUG
            default: self = .LOG
            }
        }
    }
    
    private func writeToFile(_ value: Any) {
        guard let message = value as? String else {
            debugPrint("Invalid log type")
            return
        }
        
        let date = Date().toString(dateFormat: "dd-MM-YYYY HH:mm:ss")
        let level = LevelType(flag: message.first).rawValue
        var log = ""
        if let range = message.range(of: ": ") {
            log = message[range.upperBound...].string
        }
        let finalLog = "\(date) - \(level) : \(log)\n"
        
        guard let data = finalLog.data(using: String.Encoding.utf8) else {
            debugPrint("Log writing failed")
            return
        }
        
        let rootPath = getDocumentsDirectory()
        let nestedPath = rootPath.appendingPathComponent("\(folderName)/logs")
        let filePath = nestedPath.appendingPathComponent(fileName).appendingPathExtension("txt")
        
        do {
            if !fileManager.fileExists(atPath: filePath.relativePath) {
                try fileManager.createDirectory(at: nestedPath, withIntermediateDirectories: true)
            }
            
            if let fileHandle = try? FileHandle(forWritingTo: filePath) {
                self.fileHandle = fileHandle
                fileHandle.seekToEndOfFile()
                fileHandle.write(data)
            } else {
                try data.write(to: filePath, options: .atomic)
            }
        } catch {
            debugPrint("Log writing failed")
        }
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

extension LoggingMessageHandler: WKScriptMessageHandler {
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if Bundle.environment != .PROD && message.name == "logging" {
            writeToFile(message.body)
            debugPrint(message.body)
        }
    }
}

extension LoggingMessageHandler: LoggingMessageProtocol {
    public func saveFile(completion: @escaping (URL?) -> Void) {
        fileHandle?.closeFile()
        let rootPath = getDocumentsDirectory()
        let nestedPath = rootPath.appendingPathComponent("\(folderName)/logs")
        let filePath = nestedPath.appendingPathComponent(fileName).appendingPathExtension("txt")
        let zipPath = nestedPath.appendingPathComponent(fileName).appendingPathExtension("zip")

        if fileManager.fileExists(atPath: filePath.relativePath) {
            do {
                if fileManager.fileExists(atPath: zipPath.relativePath) {
                    try fileManager.removeItem(at: zipPath)
                }
                
                try fileManager.zipItem(at: filePath, to: zipPath)
                completion(zipPath)
            } catch {
                if Bundle.environment != .PROD {
                    debugPrint("File archiving failed")
                    completion(nil)
                }
            }
        } else {
            completion(nil)
        }
    }
    
    public func saveFolder(completion: @escaping (URL?) -> Void) {
        fileHandle?.closeFile()
        let rootPath = getDocumentsDirectory()
        let folderPath = rootPath.appendingPathComponent("\(folderName)/logs")
        let zipPath = rootPath.appendingPathComponent(folderName).appendingPathComponent("logs").appendingPathExtension("zip")

        if fileManager.fileExists(atPath: folderPath.relativePath) {
            do {
                if fileManager.fileExists(atPath: zipPath.relativePath) {
                    try fileManager.removeItem(at: zipPath)
                }
                
                try fileManager.zipItem(at: folderPath, to: zipPath)
                var zipPathLast = zipPath.absoluteString
                let _ = zipPathLast.popLast()
                let zipURL = URL(string: zipPathLast)
                completion(zipURL)
            } catch {
                if Bundle.environment != .PROD {
                    debugPrint("File archiving failed")
                    completion(nil)
                }
            }
        } else {
            completion(nil)
        }
    }
    
    public func closeFile() {
        fileHandle?.closeFile()
    }
    
    public func removeZipFiles() {
        let rootPath = getDocumentsDirectory()
        let nestedPath = rootPath.appendingPathComponent("\(folderName)/logs")
        let zipFilePath = nestedPath.appendingPathComponent(fileName).appendingPathExtension("zip")
        let zipFolderPath = rootPath.appendingPathComponent(folderName).appendingPathComponent("logs").appendingPathExtension("zip")
        
        if fileManager.fileExists(atPath: zipFilePath.relativePath) {
            do {
                try fileManager.removeItem(at: zipFilePath)
            } catch {
                if Bundle.environment != .PROD {
                    debugPrint("Zip file removing failed")
                }
            }
        }
        
        if fileManager.fileExists(atPath: zipFolderPath.relativePath) {
            do {
                try fileManager.removeItem(at: zipFolderPath)
            } catch {
                if Bundle.environment != .PROD {
                    debugPrint("Zip folder removing failed")
                }
            }
        }
    }
}
