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
    var metadata = FileMetadata()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.metadata.callback = {self.tableView.reloadData()}
        
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
                                self.metadata.url = result as! URL
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.metadata.metadata.count
        }
            
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let key = Array(self.metadata.metadata.keys)[indexPath.row]
        let value = Array(self.metadata.metadata.values)[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "metaCell") as? UITableViewCell ?? UITableViewCell(style: .value1, reuseIdentifier: "metaCell")
        
        cell.textLabel?.text = key
        cell.detailTextLabel?.text = value
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            
            self.metadata.metadata.removeValue(forKey: Array(self.metadata.metadata.keys)[indexPath.row])
            tableView.deleteRows(at: [indexPath], with: .automatic)        }
        
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
            // share item at indexPath
            let key = Array(self.metadata.metadata.keys)[indexPath.row]
            let alert = UIAlertController(title: "Edit Value", message: "Change the value for Key \(key)", preferredStyle: .alert)
            alert.addTextField { (txtFld) in
                txtFld.text = Array(self.metadata.metadata.values)[indexPath.row]
            }
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                DispatchQueue.main.async {
                    self.metadata.metadata[key] = alert.textFields?.first?.text ?? "N/A"
                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
                }
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
        edit.backgroundColor = .systemOrange
        
        return [delete, edit]
    }
    
    
    @IBAction func editPressed(_ sender: UIBarButtonItem) {
        self.tableView.setEditing(!self.tableView.isEditing, animated: true)
        if self.tableView.isEditing {
            sender.title = "Done"
            sender.style = .done
        } else {
            sender.title = "Edit"
            sender.style = .plain
        }
        
    }
    
    @IBAction func sharePressed(_ sender: UIBarButtonItem) {
        let activityController = UIActivityViewController(activityItems: [self.metadata.url as Any], applicationActivities: nil)
//        self.presentViewController(activityViewController, animated: true, completion: nil)
        self.present(activityController, animated: true, completion: nil)

    }
}
