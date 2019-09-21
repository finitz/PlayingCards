//
//  ViewController.swift
//  PlayingCards
//
//  Created by 17 on 9/18/19.
//  Copyright © 2019 17. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private(set) var deck = PlayingCardsDeck()
    
    @IBAction func flipCard(_ sender: UITapGestureRecognizer) {
        cardView.isFlipped = !cardView.isFlipped
    }
    
    @IBOutlet weak var cardView: PlayingCardView! {
        didSet {
            let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
            swipeGesture.direction = [.left, .right]
            cardView.addGestureRecognizer(swipeGesture)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @objc func swiped() {
        guard let card = deck.takeRandomCard(), !cardView.isFlipped else {
            return
        }
        cardView.card = card
    }
    
}

