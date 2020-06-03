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
        static let extraHeightGap: CGFloat = 10.0
    }
    
    private struct animationConstant {
        static let arrangeDuration = 3.0
    }
    
    var cards = [Card]()
    var cardViews = [SetCardView]()
    var touchDelegate : HandleTouchedCard? = nil
    var gridFrame = CGRect()
    var dealDeckFrame = CGRect()
    var discardDeckFrame = CGRect()
    var dealDeckHeight : CGFloat = 0.0
    var gridCount : Int = 0
    
    
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
    
    private func getCardView(forCard: Card) -> SetCardView? {
        return cardViews.first(where: {$0.card == forCard})
    }
    private func getCardViewIndex(forCard: Card) -> Int? {
        return cardViews.firstIndex(where: {$0.card == forCard})
    }
    
    func addCardtoTable(forCard: Card) {
        let newView = createCardView(forCard: forCard)
        cardViews.append(newView)
    }
    
    func removeCardfromTable(forCard: Card) {
        if let removeIndex = getCardViewIndex(forCard: forCard) {
        // TODO: check this and replace when doing the discard animation
        // it will be in the closing function for the animation
                        cardViews[removeIndex].removeFromSuperview()
                        cardViews.remove(at: removeIndex)
                    }
    }
    
    func addCards(addedCards: [Card]) {
        for eachcard in addedCards {
            addCardtoTable(forCard: eachcard)
//            let newView = createCardView(forCard: eachcard)
//            cardViews.append(newView)
        }
    }
    
    func removeCards(forCards removedCards: [Card]) {
        for eachCard in removedCards {
            removeCardfromTable(forCard: eachCard)
//            if let removeIndex = getCardViewIndex(forCard: eachCard) {
// TODO: check this and replace when doing the discard animation
// it will be in the closing function for the animation
//                cardViews[removeIndex].removeFromSuperview()
//                cardViews.remove(at: removeIndex)
//            }
        }
    }
    
    func setUpCardViews(with newCards: [Card], selectedCards: [Card], cardsMatch : Bool) {
        // set up views for new cards
        if newCards.count > cards.count {
            // we have new cards
            let addedCards = newCards.subtracting(from: cards)
            addCards(addedCards: addedCards)
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
            removeCards(forCards: removedCards)
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
    
    
    
    
    private func configureAndDisplayCardView(cardView: SetCardView, atPosition position: CGRect) {
        let insetOrigin = CGPoint(x: position.origin.x+tableConstant.cardInset, y: position.origin.y+tableConstant.cardInset)
        let insetSize = CGSize(width: position.width-(2*tableConstant.cardInset), height: position.height-(2*tableConstant.cardInset))

        cardView.isHidden = false
        
        // animate the arrangment
        
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: animationConstant.arrangeDuration,
            delay: 0.0,
            options: UIView.AnimationOptions.curveEaseIn,
            animations: {cardView.frame = CGRect(origin: insetOrigin, size: insetSize)})
        
//        UIView.transition(with: cardView,
//                          duration: animationConstant.arrangeDuration,
//                          options: UIView.AnimationOptions.curveEaseIn, animations: {cardView.frame = CGRect(origin: insetOrigin, size: insetSize)})
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
        
        // layout the cards in the proper positions
//        cardGrid.frame = self.bounds
        cardGrid.frame = CGRect(x: self.bounds.minX, y: self.bounds.minY, width: self.bounds.width, height: self.bounds.height - dealDeckHeight - tableConstant.extraHeightGap)
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
