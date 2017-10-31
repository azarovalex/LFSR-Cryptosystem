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
    
    dialog.title                   = "Choose a .txt file";
    dialog.showsResizeIndicator    = true;
    dialog.showsHiddenFiles        = false;
    dialog.canChooseDirectories    = true;
    dialog.canCreateDirectories    = true;
    dialog.allowsMultipleSelection = false;
    //dialog.allowedFileTypes        = ["wav", "bmp", "txt", ""];
    
    if (dialog.runModal() == NSApplication.ModalResponse.OK) {
        let result = dialog.url // Pathname of the file
        
        if (result != nil) {
            return result!.path
        }
    } else {
        // User clicked on "Cancel"
        return ""
    }
    
    return ""
}

class SimpleLFSR: NSViewController {

    @IBOutlet var binaryFile: NSTextView!
    @IBOutlet var keyValue: NSTextView!
    @IBOutlet var outputFile: NSTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        binaryFile.font = NSFont(name: "Courier New", size: 13)
    }
    
    @IBAction func loadFile(_ sender: Any) {
        let path = browseFile()
        do {
            BinaryRespresentFileWithURL(path)
            binaryFile.string = try String(contentsOf: URL(fileURLWithPath: path + ".bin"), encoding: .ascii)
        } catch {
            dialogError(question: "Failed reading from URL: \(path)", text: "Error: " + error.localizedDescription)
        }
        
    }
    
    @IBAction func generateKey(_ sender: Any) {
        let keyLenght = Int32(binaryFile.string.lengthOfBytes(using: .ascii))
        
        if keyLenght == 0 {
            dialogError(question: "Failed creating an LSFR key.", text: "Please specify the length of the key.")
        }
        GenerateLSFRKey(keyLenght)
    }
}
