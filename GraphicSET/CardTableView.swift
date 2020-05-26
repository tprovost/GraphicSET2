//
//  CardTableView.swift
//  GraphicSET
//
//  Created by J Thomas Provost on 5/8/20.
//  Copyright © 2020 J Thomas Provost. All rights reserved.
//

import UIKit

protocol HandleTouchedCard {
    func thisCardTouched(_ sender : SetCardView)
}

class CardTableView: UIView {

    
    // this view class will be used to manage the arrangement of cards (their layout) on
    // a card table surface.  Will need to adjust for orientation and number of cards being
    // displayed.
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    // Constants
    
    private struct tableConstant {
        static let aspectRatio: CGFloat = 1.60  // 8:5
        static let cardInset: CGFloat = 5.0
    }
    
    var cards = [Card]()
    var cardViews = [SetCardView]()
    var touchDelegate : HandleTouchedCard? = nil
    
    private func createCardView(forCard theCard: Card) -> SetCardView {
        let cardView = SetCardView()
        cardView.symbol = theCard.symbol
        cardView.shading = theCard.shading
        cardView.number = theCard.number
        cardView.color = theCard.color
        cardView.card = theCard
        cardView.backgroundColor = UIColor.clear
        cardView.contentMode = UIView.ContentMode.redraw
        cardView.unselect()
        addSubview(cardView)
        cardView.isHidden = true
        //print("Card View created: \(cardView.symbol), \(cardView.color), \(cardView.shadng), \(cardView.number)")
        let tap = UITapGestureRecognizer(target: self, action: #selector(touchCard))
        cardView.addGestureRecognizer(tap)
        return cardView
    }
    
    
    
    @objc func touchCard(sender: UITapGestureRecognizer) {
//           print("CardView TouchCard \(String(describing: sender.view))")
        switch sender.state {
        case .ended:
            let thisView = sender.view as? SetCardView
            //        print("CT: Card touched: \(thisView.card!.description)")
            if thisView != nil {
                touchDelegate?.thisCardTouched(thisView!)
            }
        case .cancelled:
            break
        default:
            break
        }
    }
    
    func setUpCardViews(with newCards: [Card], selectedCards: [Card], cardsMatch : Bool) {
        // set up views for new cards
        if newCards.count > cards.count {
            // we have new cards
            let addedCards = newCards.subtracting(from: cards)
            for eachcard in addedCards {
                let newView = createCardView(forCard: eachcard)
                cardViews.append(newView)
            }
        }
        
        // check to see if any cards/views are selected and/or matched
        for view in  cardViews {
            if selectedCards.contains(view.card!) {
                view.selected()
                if cardsMatch {
                    view.cardBackground = UIColor.cyan
                }
            } else {
                // unselect
                view.unselect()
            }
        }
    }
    
    func clearCardViews(with newCards: [Card]){
        // find the difference in the card decks and deal with those only
        // compare our cards variable with the newCards
        
        if newCards.count < cards.count {
            // removed cards
            let removedCards = cards.subtracting(from: newCards)
            for eachCard in removedCards {
                if let removeIndex = cardViews.firstIndex(where: {$0.card == eachCard}) {
                    cardViews.remove(at: removeIndex)
                }
            }
        }
        
//        for cardView in self.subviews {
//            if let gestureRecognizers = cardView.gestureRecognizers {
//                for gestureRecognizer in gestureRecognizers {
//                    cardView.removeGestureRecognizer(gestureRecognizer)
//                }
//            }
//            cardView.removeFromSuperview()
//        }
//        cardViews.removeAll()
    }
    
//    private func configureAndDisplayCardView(cardView: SetCardView, atOrigin: CGPoint, withSize: CGSize) {
//        cardView.frame = CGRect(origin: atOrigin, size: withSize)
//        cardView.isHidden = false
//    }
    
    private func configureAndDisplayCardView(cardView: SetCardView, atPosition position: CGRect) {
        let insetOrigin = CGPoint(x: position.origin.x+tableConstant.cardInset, y: position.origin.y+tableConstant.cardInset)
        let insetSize = CGSize(width: position.width-(2*tableConstant.cardInset), height: position.height-(2*tableConstant.cardInset))
        cardView.frame = CGRect(origin: insetOrigin, size: insetSize)
        
        cardView.isHidden = false
    }
    
    /*
     set up the grid to display the cards.  Use the Grid structure to
     determine the best layout for the number of cards to display
     */
    
    private var cardGrid = Grid(layout: Grid.Layout.aspectRatio(tableConstant.aspectRatio))
    
    func shuffle(theCards: [Card]) -> [Card] {
        //  shuffle the cards and return the shuffled cards using Fisher-Yates algorithm
        var shuffledCards = theCards
        var cardIndex = shuffledCards.count - 1
        while cardIndex > 0 {
            let switchIndex = Int(arc4random_uniform(UInt32(cardIndex)))
            let tempCard = shuffledCards[cardIndex]
            shuffledCards[cardIndex] = shuffledCards[switchIndex]
            shuffledCards[switchIndex] = tempCard
            cardIndex -= 1
        }
        
        return shuffledCards
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        // setUpCardViews()
        cardGrid.frame = self.bounds
        cardGrid.cellCount = cards.count
        
        for index in 0..<cards.count {
            if let cardPos = cardGrid[index] {
                configureAndDisplayCardView(cardView: cardViews[index], atPosition: cardPos)
            }
        }
        
    }
}

extension Array where Element: Hashable {
    func subtracting(from other: [Element]) -> [Element] {
        let thisSet = Set(self)
        let otherSet = Set(other)
        return Array(thisSet.subtracting(otherSet))
    }
}
