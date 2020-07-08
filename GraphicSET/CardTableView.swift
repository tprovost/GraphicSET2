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
        static let arrangeDuration = 2.0
        static let dealInterval = 0.5
        static let flipDuration = 0.5
        static let discardSpacing = 1.0
        static let flyawayDuration = 2.0
    }
    
    var cards = [SetCard]()
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
//            print("grid count changed")
            setNeedsLayout()
        }
    }
    
    lazy var animator = UIDynamicAnimator(referenceView: self)
    
    lazy var cardBehavior = CardBehavior(in: animator)
    
    private func createCardView(forCard theCard: SetCard) -> SetCardView {
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
    
    private func getCardView(forCard: SetCard) -> SetCardView? {
        return cardViews.first(where: {$0.card == forCard})
    }
    private func getCardViewIndex(forCard: SetCard) -> Int? {
        return cardViews.firstIndex(where: {$0.card == forCard})
    }
    private func cardIndex(forCard: SetCard) -> Int? {
        return cards.firstIndex(where: {$0 == forCard})
    }
    func addCardtoTable(forCard: SetCard) {
        let newView = createCardView(forCard: forCard)
        
        // TODO: not this simple, need to add at a position
        cardViews.append(newView)
    }
    
    func addCards(addedCards: [SetCard]) {
        var cardPos = gridCount
        gridCount += addedCards.count
        layoutIfNeeded()
        var startDelay : Double = 0.0
        for eachcard in addedCards {
            let newView = createCardView(forCard: eachcard)
            cardViews.append(newView)
            configureAndDisplayCardView(cardView: newView, atPosition: cardGrid[cardPos]!, animationDelay: startDelay, shouldFlip: true)
            cardPos += 1
            startDelay += animationConstant.dealInterval
        }
    }
    
    private func flyAwayCard(forCard card: SetCard, inDirection: CardBehavior.pushDirection) {
        if let flyCard = getCardView(forCard: card)
        {
            cardBehavior.addItem(flyCard, inDirection: inDirection)
        }
    }
    
    // TODO: Fix discard pile frame so it works when the device is rotated
    
    
    private func sendCardtoDiscard(cardView: SetCardView, withDelay: Double) {
        let discardOrigin =  CGPoint(x: cardDecks!.frame.origin.x + discardLabel!.frame.origin.x, y: cardDecks!.frame.origin.y)
        let discardFrame = CGRect(origin: discardOrigin, size: discardLabel!.frame.size)
        
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: animationConstant.arrangeDuration,
            delay: withDelay,
            options: UIView.AnimationOptions.curveEaseOut,
            animations: {cardView.frame = discardFrame},
            completion: {finished in
                UIView.transition(with: cardView, duration: animationConstant.flipDuration, options: [.transitionFlipFromTop], animations: {cardView.isFaceUp = false})
                cardView.isHidden = true
    //            cardView.removeFromSuperview()
                }
        )
    }
    
//    func removeCardfromTable(forCard: Card, delayAnimationFor animDelay: Double) {
//        if let removeIndex = getCardViewIndex(forCard: forCard) {
//            cardViews.remove(at: removeIndex)
//        }
//    }
    
   
    
    @objc func animFinish(theTimer: Timer) {
       cardBehavior.collisionBehavior.collisionMode.update(with: UICollisionBehavior.Mode.boundaries)
        var animDelay = animationConstant.discardSpacing
        if let cardViews:[SetCardView] = theTimer.userInfo as? [SetCardView] {
            for view in cardViews {
                cardBehavior.removeItem(view)
                sendCardtoDiscard(cardView: view, withDelay: animDelay)
                animDelay += animationConstant.discardSpacing
            }
        }
    }
    
    func removeCards(theseCards removedCards: [SetCard]) {
        var flyDirection: CardBehavior.pushDirection = .left
        var removedViews = [SetCardView]()
        for eachCard in removedCards {
            if let removedIndex = getCardViewIndex(forCard: eachCard) {
                removedViews.append(cardViews[removedIndex])
            }
            flyAwayCard(forCard: eachCard, inDirection: flyDirection)
               flyDirection = flyDirection.next()
            
            if let removeIndex = getCardViewIndex(forCard: eachCard) {
                cardViews.remove(at: removeIndex)
            }
//            removeCardfromTable(forCard: eachCard, delayAnimationFor: 0.0)
        }
        
        _ = Timer.scheduledTimer(timeInterval: animationConstant.flyawayDuration, target: self, selector: #selector(animFinish), userInfo: removedViews, repeats: false)

        
        gridCount -= removedCards.count
        layoutIfNeeded()
        
        // TODO: check this and replace when doing the discard animation
        // it will be in the closing function for the animation
        //                cardViews[removeIndex].removeFromSuperview()
        //                cardViews.remove(at: removeIndex)
    }
    
    func showSelectedandHighlighted(forSelected selectedCards: [SetCard], cardsMatch: Bool){
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
    
    func shuffle(theCards: [SetCard]) -> [SetCard] {
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
        
        cardGrid.cellCount = gridCount

        for index in 0..<cardViews.count {
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
