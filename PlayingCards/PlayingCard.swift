//
//  PlayingCard.swift
//  PlayingCards
//
//  Created by 17 on 9/18/19.
//  Copyright © 2019 17. All rights reserved.
//

import Foundation


struct PlayingCard: CustomStringConvertible {
    var description: String {
        return "\(rank)\n\(suit)"
    }
    
    
    var suit: Suit
    var rank: Rank
    
    enum Suit: String, CustomStringConvertible {
        case spades = "♠️"
        case hearts = "♥️"
        case clubs = "♣️"
        case diamonds = "♦️"
        
        static var all = [Suit.clubs, .diamonds, .hearts, .spades]
        
        var description: String {
            return rawValue
        }
    }
        
    enum Rank: Int, CustomStringConvertible, CaseIterable {
        var description: String {
            switch self {
            case .ace: return "A"
            case .jack: return "J"
            case .queen: return "Q"
            case .king: return "K"
            default: return String(rawValue)
            }
        }
        
        case ace = 0
        case one = 1
        case two = 2
        case three = 3
        case four = 4
        case five = 5
        case six = 6
        case seven = 7
        case eight = 8
        case nine = 9
        case ten = 10
        case jack = 11
        case queen = 12
        case king = 13
    }
}
