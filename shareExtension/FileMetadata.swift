//
//  FileMetadata.swift
//  shareExtension
//
//  Created by Martin Zörfuss on 09.11.19.
//  Copyright © 2019 Martin Zörfuss. All rights reserved.
//

import Foundation


class FileMetadata {
    var metadata : [String: String] = [String:String]()
    var url : URL! {
        didSet(oldUrl) {
            if self.url != oldUrl {
                self.fetchMetadata()
            }
        }
    }
    
    var callback : (()->Void)?
    
    func fetchMetadata(){
        self.metadata["lat"] = "36.2318793"
        self.metadata["lng"] = "18.73281"
        self.metadata["url"] = self.url.absoluteString
        self.callback?()
    }
    
}
