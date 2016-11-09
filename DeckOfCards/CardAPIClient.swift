//
//  CardAPIClient.swift
//  DeckOfCards
//
//  Created by Felicity Johnson on 11/8/16.
//  Copyright © 2016 Gamesmith, LLC. All rights reserved.
//

import Foundation
import UIKit

struct CardAPIClient {
    
    static var shared = CardAPIClient()
    var deckId: String = ""
    
    func newDeckShuffled(with completion: @escaping ([String:Any]) -> ()) {
        let url = URL(string: "https://deckofcardsapi.com/api/deck/new/shuffle/?deck_count=1")
        guard let unwrappedUrl = url else {return}
        let session = URLSession.shared
        
        let task = session.dataTask(with: unwrappedUrl) { (data, response, error) in
            
            guard let unwrappedData = data else {return}
            
            do {
                
                let jsonResponse = try JSONSerialization.jsonObject(with: unwrappedData, options: []) as! [String: Any]
                
                CardAPIClient.shared.deckId = jsonResponse["deck_id"] as! String
                completion(jsonResponse)
            } catch {}
        }
        task.resume()
    }
    
    func drawCards(count: Int, with completion: @escaping ([[String: Any]]) -> ()) {
        
        let url = URL(string: "https://deckofcardsapi.com/api/deck/\(CardAPIClient.shared.deckId)/draw/?count=\(count)")
        guard let unwrappedUrl = url else {return}
        let session = URLSession.shared
        
        let task = session.dataTask(with: unwrappedUrl) { (data, response, error) in
            guard let unwrappedData = data else {return}
            do {
                
                let jsonResponse = try JSONSerialization.jsonObject(with: unwrappedData, options: []) as! [String: Any]
                guard let cards = jsonResponse["cards"] as? [[String: Any]] else {return}
                
                completion(cards)
                
            } catch {}
        }
        
        task.resume()

    }
    
    func downloadImage(at url: URL, handler: @escaping (Bool, UIImage?) -> Void) {
        let request = URLRequest(url: url)
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            guard let unwrappedData = data else { handler(false, nil); return }

                let image = UIImage(data: unwrappedData)
                handler(true, image)
        }
        
        task.resume()
    }

}
