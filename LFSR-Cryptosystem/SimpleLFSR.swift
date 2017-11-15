//
//  LFSR-Simple.swift
//  LFSR-Cryptosystem
//
//  Created by Alex Azarov on 30/10/2017.
//  Copyright © 2017 Alex Azarov. All rights reserved.
//

import Cocoa

// MARK: Ulitily functions

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
    
    dialog.title                   = "Choose a .txt file";
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
        
        GenerateLSFRKey(Int32(initLFSR.stringValue, radix: 2)!, keyLength, path)
        do {
            keyValue.string = try String(contentsOf: URL(fileURLWithPath: path + ".key"), encoding: .ascii)
        } catch {
            dialogError(question: "Failed reading from URL: \(path)", text: "Error: " + error.localizedDescription)
        }
        
    }
    @IBAction func decipher(_ sender: Any) {
        if (keyValue.string.lengthOfBytes(using: .ascii) == 0 || outputFile.string.lengthOfBytes(using: .ascii) == 0) {
            dialogError(question: "Cannot encipher the file!",
                        text: "Please specify binary representation of the encoded file and generate the LFSR key!")
            return
        }
        binaryFile.string = String(cString: Encipher(outputFile.string, keyValue.string))
    }
    
    @IBAction func encipher(_ sender: Any) {
        if (keyValue.string.lengthOfBytes(using: .ascii) == 0 || binaryFile.string.lengthOfBytes(using: .ascii) == 0) {
            dialogError(question: "Cannot encipher the file!",
                        text: "Please specify binary representation of the file and generate the LFSR key!")
            return
        }
        
        outputFile.string = String(cString: Encipher(binaryFile.string, keyValue.string))
    }
    
}
