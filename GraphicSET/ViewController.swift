//
//  ViewController.swift
//  GraphicSET
//
//  Created by J Thomas Provost on 5/7/20.
//  Copyright © 2020 J Thomas Provost. All rights reserved.
//

import UIKit

class ViewController: UIViewController, HandleTouchedCard {
    
    private var swipe : UIGestureRecognizer? = nil

    @IBOutlet weak var cardTable: CardTableView! {
        didSet {
            // set up swipe gesture for getting new cards
            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(dealThreeCards))
            swipe.direction = [.down]
            cardTable.addGestureRecognizer(swipe)
            
            let rotate = UIRotationGestureRecognizer(target: self, action: #selector(shuffleCards))
            rotate.rotation = displayConstant.rotationAmount
            cardTable.addGestureRecognizer(rotate)
        }
    }
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBAction func newGameButton(_ sender: UIButton) {
        theGame = SetGame()
        setUpGame()
        UpdateViewFromModel()
    }
    
    private struct displayConstant {
            static let initialDeal = 12
            static let selectBorderWidth: CGFloat =  3.0
            static let normalBorderWidth: CGFloat = 0.0
            static let selectBorderColor = UIColor.blue.cgColor
            static let normalBorderColor = UIColor.black.cgColor
            static let highlightColor = UIColor.cyan
            static let buttonBackground = UIColor.white
            static let rotationAmount: CGFloat = CGFloat.pi / 2.0
    }
   
    var cardsInPlay = [Card]()
    private lazy var theGame = SetGame()
    
    override func viewDidLoad() {
       super.viewDidLoad()
        
        cardTable.touchDelegate = self
        setUpGame()
        UpdateViewFromModel()
    }

    private func UpdateViewFromModel() {
        
        cardTable.clearCardViews()
        cardTable.cards = cardsInPlay
        cardTable.setUpCardViews(selectedCards: theGame.cardsSelected, cardsMatch: theGame.selectedCardsAreAMatch)
        cardTable.setNeedsDisplay()
        
        // update the score label
        
        scoreLabel.text = "Score: \(theGame.theScore)"
    }
    
    private func setUpGame() {
//
        
//       cardsInPlay.append(Card(color: Card.ShapeColor.green, symbol: Card.Symbol.oval, shading: Card.Shading.open, number: 3))
//        cardsInPlay.append(Card(color: Card.ShapeColor.red, symbol: Card.Symbol.diamond, shading: Card.Shading.solid, number: 2))
//       cardsInPlay.append(Card(color: Card.ShapeColor.purple, symbol: Card.Symbol.squiggle, shading: Card.Shading.striped, number: 3))
//
        cardsInPlay.removeAll()     // clear all the cards from the table
        
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
    @objc func dealThreeCards(_ sender:UISwipeGestureRecognizer?) {
        // need to handle both cases here, so set this var if we
        // need to deal the cards.  Only case where not, is if the swipe is
        // NOT ended properly
        
        var needCards = true
        
        switch sender?.state {
        case .ended:
            needCards = true
        case .cancelled:
            needCards = false
        default:
            needCards = false
            break
        }
        if needCards {
            var index = 0
            repeat {
                if let newCard = theGame.nextCard() {
                    cardsInPlay.append(newCard)
                } else {  // no more cards
                    //disable swipe for new cards
                    if swipe != nil {
                        cardTable.removeGestureRecognizer(swipe!)
                    }
                }
                index += 1
            } while (index < 3)
            
            UpdateViewFromModel()
        }
    }
    
    func thisCardTouched(_ sender: SetCardView) {
        if sender.card != nil, let cardsMatched = theGame.chooseCard(forCard: sender.card!) {
            clearMatchedCards(theCards: cardsMatched)
            dealThreeCards(nil)
        }
        UpdateViewFromModel()
//        print("VC Card touched: \(sender.card?.description ?? "no card")")
    }
    
    @objc func shuffleCards(_ sender:UIRotationGestureRecognizer) {
        
        switch sender.state {
        case .ended:
            cardsInPlay = cardTable.shuffle(theCards: cardsInPlay)
            UpdateViewFromModel()
        case .cancelled:
            break
        default:
            break
        }
        
    }
    
    private func clearMatchedCards(theCards:[Card]) {
           // take the matched cards and clear them as used and
           // remove them from the buttons
           for theCard in theCards {
               if let crdIndex = cardsInPlay.firstIndex(of: theCard) {
                cardsInPlay.remove(at: crdIndex)
               }
           }
       }
}

