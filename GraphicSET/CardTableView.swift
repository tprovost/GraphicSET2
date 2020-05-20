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
        addSubview(cardView)
        cardView.isHidden = true
        //print("Card View created: \(cardView.symbol), \(cardView.color), \(cardView.shadng), \(cardView.number)")
        let tap = UITapGestureRecognizer(target: self, action: #selector(touchCard))
        cardView.addGestureRecognizer(tap)
        return cardView
    }
    
    
    
    @objc func touchCard(sender: UITapGestureRecognizer) {
//           print("CardView TouchCard \(String(describing: sender.view))")
        let thisView = sender.view as! SetCardView
        print("CT: Card touched: \(thisView.card!.description)")
        touchDelegate?.thisCardTouched(thisView)
        }
    
    func setUpCardViews() {
        for index in 0..<cards.count {
            let newView = createCardView(forCard: cards[index])
            cardViews.append(newView)
        }
    }
    
    func clearCardViews(){
        for cardView in self.subviews {
            if let gestureRecognizers = cardView.gestureRecognizers {
                for gestureRecognizer in gestureRecognizers {
                    cardView.removeGestureRecognizer(gestureRecognizer)
                }
            }
            cardView.removeFromSuperview()
        }
        cardViews.removeAll()
    }
    
    private func configureAndDisplayCardView(cardView: SetCardView, atOrigin: CGPoint, withSize: CGSize) {
        cardView.frame = CGRect(origin: atOrigin, size: withSize)
        cardView.isHidden = false
    }
    
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
    
    
//    override func draw(_ rect: CGRect) {
//
//        // setUpCardViews()
//
//        cardGrid.frame = self.bounds
//        cardGrid.cellCount = cards.count
//
//        for index in 0..<cards.count {
//            if let cardPos = cardGrid[index] {
//                configureAndDisplayCardView(cardView: cardViews[index], atPosition: cardPos)
//            }
//        }
//        }

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
