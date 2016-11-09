//
//  File.swift
//  DeckOfCards
//
//  Created by Felicity Johnson on 11/8/16.
//  Copyright © 2016 Gamesmith, LLC. All rights reserved.
//

import Foundation
import UIKit

class Card {

    let imageURLString: String
    let url: URL?
    let code: String
    var image: UIImage?
    let value: String
    let suit: String
    let apiClient = CardAPIClient.shared
    var isDownloading = false
    
    
    init(dict: [String: Any]) {
        imageURLString = dict["image"] as! String
        url = URL(string: imageURLString)!
        code = dict["code"] as! String
        value = dict["value"] as! String
        suit = dict["suit"] as! String
    }
    
    func downloadImage(with handler: @escaping (Bool) -> Void) {
        
        apiClient.downloadImage(at: url!) { (true, sentImage) in
            self.image = sentImage
            handler(true)
        }
        
        
        
    }
    
    
    
    
}
