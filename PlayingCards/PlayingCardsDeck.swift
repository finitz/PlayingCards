//
//  PlayingCardsDeck.swift
//  PlayingCards
//
//  Created by 17 on 9/18/19.
//  Copyright © 2019 17. All rights reserved.
//

import Foundation

struct PlayingCardsDeck {
    
    private var cards = [PlayingCard]()
    
    init() {
        for suit in PlayingCard.Suit.all{
            for rank in PlayingCard.Rank.allCases {
                cards.append(PlayingCard(suit: suit, rank: rank))
            }
        }
    }
    
    mutating func draw() -> PlayingCard? {
        if cards.count > 0 {
            return cards.remove(at: cards.count.arc4random)
        } else {
            return nil
        }
    }
    
    mutating func takeRandomCard() -> PlayingCard? {
        guard cards.count > 0 else {
            return nil
        }
        
        let idx = Int.random(in: 0..<cards.count);
        return cards.remove(at: idx)
    }
    
}


extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}
