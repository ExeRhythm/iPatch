//
//  ViewController.swift
//  iPatch
//
//  Created by Матвей Анисович on 4/9/21.
//

import Cocoa

class ViewController: NSViewController {
    
    var ipaURL:URL?
    var debURL:URL?

    @IBOutlet weak var ipaFileNameText: NSTextField!
    @IBOutlet weak var debFileNameText: NSTextField!
    @IBOutlet weak var displayNameTextField: NSTextField!
    @IBOutlet weak var injectSubstrateButton: NSButton!
    @IBOutlet weak var patchButton: NSButton!
    
    @IBAction func selectIPA(_ sender: NSButton) {
        let panel: NSOpenPanel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        panel.canChooseFiles = true
        panel.isFloatingPanel = false
        panel.allowedFileTypes = ["ipa"]
        panel.beginSheetModal(for: self.view.window!, completionHandler: { response in
            if response == NSApplication.ModalResponse.OK {
                self.ipaURL = panel.url
                self.updateUI()
            }
        })
    }
    
    @IBAction func selectDeb(_ sender: NSButton) {
        let panel: NSOpenPanel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        panel.canChooseFiles = true
        panel.isFloatingPanel = false
        panel.allowedFileTypes = ["deb"]
        panel.beginSheetModal(for: self.view.window!, completionHandler: { response in
            if response == NSApplication.ModalResponse.OK {
                self.debURL = panel.url
                self.updateUI()
            }
        })
    }
    @IBAction func patchButtonClicked(_ sender: NSButton) {
        // TODO: Some stuff here...
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        patchButton.isEnabled = false
    }
    
    func updateUI() {
        if ipaURL != nil, debURL != nil {
            patchButton.isEnabled = true
        }
        ipaFileNameText.stringValue = ipaURL?.lastPathComponent ?? "None selected"
        debFileNameText.stringValue = debURL?.lastPathComponent ?? "None selected"
        displayNameTextField.stringValue = (ipaURL?.lastPathComponent ?? "").components(separatedBy: " ").first ?? ""
    }

}

