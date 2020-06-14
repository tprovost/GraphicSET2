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
        static let dealInterval = 1.0
        static let flipDuration = 1.0
    }
    
    var cards = [Card]()
    var cardViews = [SetCardView]()
    var touchDelegate : HandleTouchedCard? = nil
    var gridFrame = CGRect()
    var cardDecks: UIStackView?
    var deckButton: UIButton?
    var discardLabel:UILabel?
    var dealDeckFrame = CGRect()
    var discardDeckFrame = CGRect()
    var dealDeckHeight : CGFloat = 0.0
    var gridCount : Int = 0 {
        didSet {
            print("grid count changed")
            setNeedsLayout()
        }
    }
    
    
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
        cardView.isFaceUp = false
        //print("Card View created: \(cardView.symbol), \(cardView.color), \(cardView.shadng), \(cardView.number)")
        let tap = UITapGestureRecognizer(target: self, action: #selector(touchCard))
        cardView.addGestureRecognizer(tap)
        // create card view initially at the deal deck location and size
        cardView.frame = CGRect(origin: cardDecks!.frame.origin, size: dealDeckFrame.size)
//        cardView.frame = dealDeckFrame
        // when ready, start facedown
//        cardView.isFaceUp = false
        return cardView
    }
    
    private func dealNewCard(newCard: SetCardView, toPosition: CGRect) {
        // animate the new card view from the deal deck to its new position
        
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
    private func cardIndex(forCard: Card) -> Int? {
        return cards.firstIndex(where: {$0 == forCard})
    }
    func addCardtoTable(forCard: Card) {
        let newView = createCardView(forCard: forCard)
        
        // TODO: not this simple, need to add at a position
        cardViews.append(newView)
    }
    
 
    
    func addCards(addedCards: [Card], addPositionIndex: [Int], needsRelayout: Bool) {
        var posIndex: Int = 0
        print("---- Add Cards ----")
        if needsRelayout {
            gridCount += addedCards.count
//            setNeedsLayout()
            layoutIfNeeded()
        }
        var startDelay : Double = 0.0
        for eachcard in addedCards {
            cards.append(eachcard)
            let newView = createCardView(forCard: eachcard)
            // TODO: add at index, not just append?? or is this grid position?
            cardViews.append(newView)
            if let cardPos = cardGrid[addPositionIndex[posIndex]] {
                configureAndDisplayCardView(cardView: newView, atPosition: cardPos, animationDelay: startDelay, shouldFlip: true)
            }
            posIndex += 1
            startDelay += animationConstant.dealInterval
            
//            addCardtoTable(forCard: eachcard)
//            let newView = createCardView(forCard: eachcard)
//            cardViews.append(newView)
        }
//        setNeedsLayout()
    }
   func removeCardfromTable(forCard: Card) {
        if let removeIndex = getCardViewIndex(forCard: forCard) {
            let cardView = cardViews[removeIndex]
            let discardOrigin =  CGPoint(x: cardDecks!.frame.origin.x + discardLabel!.frame.origin.x, y: cardDecks!.frame.origin.y)
            let discardFrame = CGRect(origin: discardOrigin, size: discardLabel!.frame.size)
            print("-- Remove card \(forCard.description) to \(discardFrame)")
            UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: animationConstant.arrangeDuration,
                delay: 0.0,
                options: UIView.AnimationOptions.curveEaseOut,
                animations: {cardView.frame = discardFrame},
                completion: {finished in
                    UIView.transition(with: cardView, duration: animationConstant.flipDuration, options: [.transitionFlipFromTop], animations: {cardView.isFaceUp = false})}
                )
            }
        // TODO: check this and replace when doing the discard animation
        // it will be in the closing function for the animation
//            cardViews[removeIndex].isHidden = true
//            cardViews[removeIndex].isUserInteractionEnabled = false
//            cardViews[removeIndex].isFaceUp = false
//          cardViews[removeIndex].removeFromSuperview()
//          cardViews.remove(at: removeIndex)
//            setNeedsDisplay()
    }

    func removeCards(theseCards removedCards: [Card]) -> [Int]? {
        var cardPosition: [Int] = []
        // get the positions of the cards removed
        print("----- Remove Cards")
        for eachCard in removedCards {
            if let pos = getCardViewIndex(forCard: eachCard) {
                cardPosition.append(pos)
            }
        }
        for eachCard in removedCards {
            removeCardfromTable(forCard: eachCard)
            if let index = cardIndex(forCard: eachCard) {
                cards.remove(at: index)
            }
        }
        return cardPosition
        
        // TODO: check this and replace when doing the discard animation
        // it will be in the closing function for the animation
        //                cardViews[removeIndex].removeFromSuperview()
        //                cardViews.remove(at: removeIndex)
    }
    
    func showSelectedandHighlighted(forSelected selectedCards: [Card], cardsMatch: Bool){
        for view in cardViews {
            if selectedCards.contains(view.card!) {
                view.selected()
                if cardsMatch {
//                    view.cardBackground = UIColor.cyan
                    view.highlighted()
                }
            } else {
                // unselect
                view.unselect()
            }
        }
    }
    
    private func configureAndDisplayCardView(cardView: SetCardView, atPosition position: CGRect, animationDelay: Double, shouldFlip: Bool) {
        let insetOrigin = CGPoint(x: position.origin.x+tableConstant.cardInset, y: position.origin.y+tableConstant.cardInset)
        let insetSize = CGSize(width: position.width-(2*tableConstant.cardInset), height: position.height-(2*tableConstant.cardInset))

        cardView.isHidden = false
//        cardView.isFaceUp = true
        
        // animate the arrangment
        
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: animationConstant.arrangeDuration,
            delay: animationDelay,
            options: UIView.AnimationOptions.curveEaseIn,
            animations: {cardView.frame = CGRect(origin: insetOrigin, size: insetSize)},
            completion: {finished in
                if shouldFlip {UIView.transition(with: cardView, duration: animationConstant.flipDuration, options: [.transitionFlipFromTop], animations: {cardView.isFaceUp = true})}
            })
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
        cardGrid.frame = CGRect(x: self.bounds.minX, y: self.bounds.minY, width: self.bounds.width, height: cardDecks!.frame.origin.y - tableConstant.extraHeightGap)
//        cardGrid.cellCount = cards.count
        
        print("Layout table with \(gridCount) cells and \(cards.count) cards")
        cardGrid.cellCount = gridCount

        
        // TODO: rethink layout based on needing to fill new cards into specific positions
        for index in 0..<cards.count {
            if let cardPos = cardGrid[index] {
                configureAndDisplayCardView(cardView: cardViews[index], atPosition: cardPos, animationDelay: 0.0, shouldFlip: false)
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
