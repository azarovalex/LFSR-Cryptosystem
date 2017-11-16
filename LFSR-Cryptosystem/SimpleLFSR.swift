//
//  LFSR-Simple.swift
//  LFSR-Cryptosystem
//
//  Created by Alex Azarov on 30/10/2017.
//  Copyright © 2017 Alex Azarov. All rights reserved.
//

import Cocoa

func dialogError(question: String, text: String) {
    let alert = NSAlert()
    alert.messageText = question
    alert.informativeText = text
    alert.alertStyle = .critical
    alert.addButton(withTitle: "OK")
    alert.runModal()
}

func browseFile() -> String {
    
    let dialog = NSOpenPanel();
    
    dialog.title                   = "Choose a file";
    dialog.showsResizeIndicator    = true;
    dialog.showsHiddenFiles        = false;
    dialog.canChooseDirectories    = true;
    dialog.canCreateDirectories    = true;
    dialog.allowsMultipleSelection = false;
    
    if (dialog.runModal() == NSApplication.ModalResponse.OK) {
        let result = dialog.url
        
        if (result != nil) {
            return result!.path
        }
    } else { return "" }
    return ""
}

class SimpleLFSR: NSViewController {

    @IBOutlet var binaryFile: NSTextView!
    @IBOutlet var keyValue: NSTextView!
    @IBOutlet var outputFile: NSTextView!
    
    @IBOutlet var initLFSR: NSTextField!
    
    var path = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        binaryFile.font = NSFont(name: "Courier New", size: 13)
        keyValue.font = NSFont(name: "Courier New", size: 13)
        outputFile.font = NSFont(name: "Courier New", size: 13)
    }
    
    @IBAction func loadFile(_ sender: NSButton) {
        path = browseFile()
        var fileSize : UInt64
        do {
            let attr = try FileManager.default.attributesOfItem(atPath: path)
            fileSize = attr[FileAttributeKey.size] as! UInt64
            
            //if you convert to NSDictionary, you can get file size old way as well.
            let dict = attr as NSDictionary
            fileSize = dict.fileSize()
            if (fileSize == 0) {
                dialogError(question: "Failed reading from URL: \(path)", text: "The file is too small!")
                return
            }
        } catch {
            print("Error: \(error)")
        }
        
        LoadFile(path)
        switch sender.tag {
        case 1:
            do {
                binaryFile.string = try String(contentsOf: URL(fileURLWithPath: path + ".load"), encoding: .ascii)
            } catch {
                dialogError(question: "Failed reading from URL: \(path).load", text: "Error: " + error.localizedDescription)
            }
        case 2:
            do {
                outputFile.string = try String(contentsOf: URL(fileURLWithPath: path + ".load"), encoding: .ascii)
            } catch {
                dialogError(question: "Failed reading from URL: \(path).load", text: "Error: " + error.localizedDescription)
            }
        default:
            break
        }
        let fileManager = FileManager.default
        do {
            try fileManager.removeItem(atPath: path + ".load")
        }
        catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
        }
    }
    
    @IBAction func generateKey(_ sender: Any) {
        let keyLength = Int32(binaryFile.string.lengthOfBytes(using: .ascii))
        
        if keyLength == 0 {
            dialogError(question: "Failed creating an LSFR key.", text: "Please specify a length of the key.")
            return
        }
        
        initLFSR.stringValue = initLFSR.stringValue.components(separatedBy: CharacterSet.init(charactersIn: "01").inverted).joined()
        if initLFSR.stringValue.lengthOfBytes(using: .ascii) != 26 {
            dialogError(question: "Failed creating an LSFR key.", text: "Please specify a correct initial state of the LSFR.")
            return
        }
        
        GenerateLSFRKey(UInt(initLFSR.stringValue, radix: 2)!, path)
        LoadFile(path + ".key")
        do {
            keyValue.string = try String(contentsOf: URL(fileURLWithPath: path + ".key.load"), encoding: .ascii)
        } catch {
            dialogError(question: "Failed reading from URL: \(path)", text: "Error: " + error.localizedDescription)
        }
        
        let fileManager = FileManager.default
        do {
            try fileManager.removeItem(atPath: path + ".key.load")
        }
        catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
        }
    }
    
    @IBAction func encipher(_ sender: Any) {
        if (keyValue.string.lengthOfBytes(using: .ascii) == 0 || binaryFile.string.lengthOfBytes(using: .ascii) == 0) {
            dialogError(question: "Cannot encipher the file!",
                        text: "Please specify binary representation of the file and generate the LFSR key!")
            return
        }
        Encipher(path)
        LoadFile(path + ".xor")
        do {
            outputFile.string = try String(contentsOf: URL(fileURLWithPath: path + ".xor.load"), encoding: .ascii)
        } catch {
            dialogError(question: "Failed reading from URL: \(path)", text: "Error: " + error.localizedDescription)
        }
        
        let fileManager = FileManager.default
        do {
            try fileManager.removeItem(atPath: path + ".xor.load")
        }
        catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
        }
    }
    
}
