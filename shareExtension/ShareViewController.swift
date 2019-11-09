//
//  ShareViewController.swift
//  shareExtension
//
//  Created by Martin Zörfuss on 09.11.19.
//  Copyright © 2019 Martin Zörfuss. All rights reserved.
//

import UIKit
import Social
import MobileCoreServices

/*class ShareViewController: SLComposeServiceViewController {

    override func viewDidLoad(){
        super.viewDidLoad()
        if let context = self.extensionContext?.inputItems.first as? NSExtensionItem
        {
            print("TEST")
            print(context)
            for attachment in (context.attachments) ?? [NSItemProvider]() {
                /*if attachment.hasItemConformingToTypeIdentifier((kUTTypeFileURL as String)) {
                    attachment.load
                }*/
                for type in attachment.registeredTypeIdentifiers {
                    attachment.loadItem(forTypeIdentifier: type, options: nil) { (result, error) in
                        
                        print("test2")
                        print(result)
                    }
                }
            }
        }
    }
    
    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }

    override func didSelectPost() {
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
    
        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
        
    }

    override func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return []
    }

}*/

class ShareViewController : UITableViewController {
    
    @IBOutlet weak var imgView: UIImageView!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        if let context = self.extensionContext?.inputItems.first as? NSExtensionItem
        {
            print(context)
            for attachment in (context.attachments) ?? [NSItemProvider]() {
                for type in attachment.registeredTypeIdentifiers {
                    if (attachment.hasItemConformingToTypeIdentifier(type)) {
                        attachment.loadItem(forTypeIdentifier: type, options: nil) { (result, error) in
                            
                            print("test2")
                            print(type)
                            print(result) // url to document
                            if (type == kUTTypeJPEG as String) {
                                print("is image")
                                if let data = try? Data(contentsOf: result as! URL) {
                                    if let image = UIImage(data: data) {
                                        DispatchQueue.main.async {
                                            self.imgView.image = image
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

}
