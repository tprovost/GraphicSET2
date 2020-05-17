//
//  ViewController.swift
//  GraphicSET
//
//  Created by J Thomas Provost on 5/7/20.
//  Copyright © 2020 J Thomas Provost. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var cardTable: CardTableView! {
        didSet {
            // set up swipe gesture for getting new cards
            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(dealThreeCards))
            swipe.direction = [.up]
            cardTable.addGestureRecognizer(swipe)
        }
    }
    
    private struct displayConstant {
            static let initialDeal = 12
            static let selectBorderWidth: CGFloat =  3.0
            static let normalBorderWidth: CGFloat = 0.0
            static let selectBorderColor = UIColor.blue.cgColor
            static let normalBorderColor = UIColor.black.cgColor
            static let highlightColor = UIColor.cyan
            static let buttonBackground = UIColor.white
    }
    
    var cardsInPlay = [Card]()
    private lazy var theGame = SetGame()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpGame()
        UpdateViewFromModel()
    }

    private func UpdateViewFromModel() {
        
        cardTable.clearCardViews()
        cardTable.cards = cardsInPlay
        cardTable.setUpCardViews()
        cardTable.setNeedsDisplay()
    }
    
    private func setUpGame() {
//
        
//       cardsInPlay.append(Card(color: Card.ShapeColor.green, symbol: Card.Symbol.oval, shading: Card.Shading.open, number: 3))
//        cardsInPlay.append(Card(color: Card.ShapeColor.red, symbol: Card.Symbol.diamond, shading: Card.Shading.solid, number: 2))
//       cardsInPlay.append(Card(color: Card.ShapeColor.purple, symbol: Card.Symbol.squiggle, shading: Card.Shading.striped, number: 3))
//
        // deal the intial 12 cards to start the game

        for cardCount in 0..<displayConstant.initialDeal {
            if let newCard = theGame.nextCard() {
                cardsInPlay.append(newCard)
            } else {
                    // should not happen on initial deal
                    print("Not enough cards for initial deal at card number: \(cardCount)")
                }
            }
    }
    
    // this function will attempt to deal 3 new cards based
    // on available space and available cards
    @objc func dealThreeCards() {
        var index = 0
        repeat {
            if let newCard = theGame.nextCard() {
                cardsInPlay.append(newCard)
            } else {  // no more cards
                //disable swipe for new cards
            }
            index += 1
        } while (index < 3)
        
        UpdateViewFromModel()
    }
}

