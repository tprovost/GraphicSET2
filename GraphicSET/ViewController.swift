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
    @IBAction func dealButton(_ sender: UIButton) {
    }
    @IBOutlet weak var deckButton: UIButton!
    @IBOutlet weak var discardDeck: UILabel!
    
    @IBOutlet weak var CardDecks: UIStackView!
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBAction func newGameButton(_ sender: UIButton) {
        theGame = SetGame()
        setUpGame()
        UpdateViewFromModel()
    }
    
    private struct displayConstant {
            static let initialDeal = 6
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
    var setsMatched = 0
    
    override func viewDidLoad() {
       super.viewDidLoad()
        
        
        cardTable.touchDelegate = self
        cardTable.cardDecks = CardDecks
        cardTable.dealDeckFrame = deckButton.frame
        cardTable.discardDeckFrame = discardDeck.frame
        cardTable.dealDeckHeight = deckButton.frame.height
        cardTable.deckButton = deckButton
        cardTable.discardLabel = discardDeck
//        cardTable.gridFrame = CGRect(x: cardTable.frame.origin.x, y: cardTable.frame.origin.y, width: cardTable.frame.width, height: cardTable.frame.height - discardDeck.frame.height)
        // adjust height to allow for deal and discard decks
        setUpGame()
        UpdateViewFromModel()
    }

    private func UpdateViewFromModel() {
        
        cardTable.showSelectedandHighlighted(forSelected: theGame.cardsSelected, cardsMatch: theGame.selectedCardsAreAMatch)

        // update the score and set labels
        
        scoreLabel.text = "Score: \(theGame.theScore)"
        discardDeck.text  = "\(setsMatched) Sets"
    }
    
    private func setUpGame() {

        cardsInPlay.removeAll()     // clear all the cards from the table
        
        // deal the intial 12 cards to start the game
        var cardPosition: [Int] = []
        for cardCount in 0..<displayConstant.initialDeal {
            if let newCard = theGame.nextCard() {
                cardPosition.append(cardCount)
                cardsInPlay.append(newCard)
            } else {
                    // should not happen on initial deal
                    print("Not enough cards for initial deal at card number: \(cardCount)")
                }
            }
        cardTable.addCards(addedCards: cardsInPlay)
        setsMatched = 0
    }
    
    private func getThreeNewCards() -> [Card]? {
        var newCards: [Card] = []
        var index = 0
        repeat {
            if let newCard = theGame.nextCard() {
                newCards.append(newCard)
                index += 1
            }
        } while (index < 3)
        
        return newCards
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
            if let addCards = getThreeNewCards() {
                cardsInPlay.append(contentsOf: addCards)
                cardTable.addCards(addedCards: addCards)
            } else {  // no more cards
                //disable swipe for new cards
                if swipe != nil {
                    cardTable.removeGestureRecognizer(swipe!)
                }
            }
        }
    }
    
    func thisCardTouched(_ sender: SetCardView) {
//      print("Card touched: \(sender.card?.description ?? "no card")")
        if sender.card != nil, let cardsMatched = theGame.chooseCard(forCard: sender.card!) {
            cardTable.removeCards(theseCards: cardsMatched)
            setsMatched += 1
            if let newCards = getThreeNewCards() {
                cardTable.addCards(addedCards: newCards)
            }
            clearMatchedCards(theCards: cardsMatched)
//            dealThreeCards(nil)
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
       // remove them from the card table
//        cardTable.removeCards(forCards: theCards)
//        cardsInPlay = cardsInPlay.subtracting(from: theCards)
//       for theCard in theCards {
//           if let crdIndex = cardsInPlay.firstIndex(of: theCard) {
//            cardsInPlay.remove(at: crdIndex)
//           }
//       }
    }
}

