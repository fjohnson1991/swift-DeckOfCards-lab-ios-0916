//
//  Deck.swift
//  DeckOfCards
//
//  Created by Felicity Johnson on 11/8/16.
//  Copyright © 2016 Gamesmith, LLC. All rights reserved.
//

import Foundation


class Deck {
    
    var success : Bool!
    var deck_id: String!
    var shuffled: Bool!
    var remaining: Int = 0
    var apiClient = CardAPIClient.shared
    var cards: [Card] = []

    
    func newDeck(with completionHandler: @escaping (Bool) -> Void) {
        print("1. \(remaining)")
        apiClient.newDeckShuffled { (jsonResponse) in
            self.success = jsonResponse["success"] as! Bool
            self.deck_id = jsonResponse["deck_id"] as! String
            if self.success == true {
                self.shuffled = true
                
            }
            self.remaining = jsonResponse["remaining"] as! Int
            print("2. \(self.remaining)")
            completionHandler(true)
        }
        
    }
    
    
    func drawCards(numberOfCards count: Int, handler: @escaping (Bool, [Card]?) -> Void) {
        cards.removeAll()
        if count < remaining {
            apiClient.drawCards(count: count, with: { (cards) in
                self.remaining -= count
                for card in cards {
                    let addedCard = Card(dict: card)
                    self.cards.append(addedCard)
                }
                
                handler(true, self.cards)
            })
        } else {
            
            print("can't draw")
        }
        
    }
}
