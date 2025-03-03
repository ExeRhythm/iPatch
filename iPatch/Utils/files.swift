//
//  files.swift
//  iPatch
//
//  Created by Eamon Tracey.
//

import AppKit

let fileManager = FileManager.default
let tmpURL: URL = URL(string: ".")!
let tmp = try! fileManager.url(for: .itemReplacementDirectory, in: .userDomainMask, appropriateFor: tmpURL, create: true)

func extractDylibFromDeb(_ debURL: URL) -> URL {
    let debDir = tmp.appendingPathComponent("deb")
    let debDebURL = debDir.appendingPathComponent("deb.deb")
    fatalTry("Failed to copy debian package \(debURL) to temporary deb directory \(debDir.path)") {
        try fileManager.createDirectory(at: debDir, withIntermediateDirectories: false, attributes: .none)
        try fileManager.copyItem(at: debURL, to: debDebURL)
    }
    fileManager.changeCurrentDirectoryPath(debDir.path)
    shell(launchPath: AR, arguments: ["-x", debDebURL.path])
    shell(launchPath: TAR, arguments: ["-xf", "data.tar.lzma"])
    let dylibDirPath = debDir.appendingPathComponent("Library/MobileSubstrate/DynamicLibraries").path
    guard let dylibDirEnum = fileManager.enumerator(atPath: dylibDirPath) else {
        fatalExit("Malformed tweak debian package at \(debURL.path). The package does not contain a Library/MobileSubstrate/DynamicLibraries directory.")
    }
    guard let dylibPath = (dylibDirEnum.allObjects.filter {
        ($0 as! String).hasSuffix(".dylib")
    }.first as? String) else {
        fatalExit("Malformed tweak debian package at \(debURL.path). No .dylib was found in \(dylibDirPath).")
    }
    return URL(fileURLWithPath: "\(dylibDirPath)/\(dylibPath)")
}

func extractAppFromIPA(_ ipaURL: URL) -> URL {
    let oldIPADir = tmp.appendingPathComponent("oldipa")
    shell(launchPath: UNZIP, arguments: [ipaURL.path, "-d", oldIPADir.path])
    let payloadDirPath = oldIPADir.appendingPathComponent("Payload").path
    guard let payloadDirEnum = fileManager.enumerator(atPath: payloadDirPath) else {
        fatalExit("Malformed IPA file \(ipaURL.path). The IPA does not contain a Payload directory.")
    }
    guard let appPath = (payloadDirEnum.allObjects.filter {
        ($0 as! String).hasSuffix(".app")
    }.first as? String) else {
        fatalExit("Malformed IPA file \(ipaURL.path). No .app was found in \(payloadDirPath).")
    }
    return URL(fileURLWithPath: "\(payloadDirPath)/\(appPath)")
}

func extractBinaryFromApp(_ appURL: URL) -> URL {
    let infoURL = appURL.appendingPathComponent("Info.plist")
    let info = NSDictionary(contentsOf: infoURL)!
    let executableName = info["CFBundleExecutable"] as! String
    return appURL.appendingPathComponent(executableName)
}

func appToIPA(_ appURL: URL) -> URL {
    let newIPADir = tmp.appendingPathComponent("newipa")
    let payloadDir = newIPADir.appendingPathComponent("Payload")
    fatalTry("Failed to copy app \(appURL.path) to new IPA payload directory \(payloadDir.path).") {
        try fileManager.createDirectory(at: payloadDir, withIntermediateDirectories: true, attributes: .none)
        try fileManager.copyItem(at: appURL, to: payloadDir.appendingPathComponent(appURL.lastPathComponent))
    }
    fileManager.changeCurrentDirectoryPath(newIPADir.path )
    shell(launchPath: ZIP, arguments: ["-r", "newipa.ipa", "Payload"])
    return newIPADir.appendingPathComponent("newipa.ipa")
}

func saveFile(url: URL, withPotentialName potentialName: String, allowedFileTypes: [String]) {
    let savePanel = NSSavePanel()
    savePanel.nameFieldStringValue = potentialName
    savePanel.allowedFileTypes = allowedFileTypes
    savePanel.begin { result in
        if result == .OK {
            fatalTry("Failed to move IPA file \(url.path) to desired location \(savePanel.url!.path).") {
                try fileManager.moveItem(at: url, to: savePanel.url!)
            }
        }
    }
}
