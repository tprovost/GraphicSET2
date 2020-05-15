//
//  CardTableView.swift
//  GraphicSET
//
//  Created by J Thomas Provost on 5/8/20.
//  Copyright © 2020 J Thomas Provost. All rights reserved.
//

import UIKit

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
    
    // variables for testing.  once coded, these values will come from the
    // view controller
    
    var cards = [Card]()
    var cardViews = [SetCardView]()
    
    
    
    private func createCardView(forCard theCard: Card) -> SetCardView {
        let cardView = SetCardView()
        cardView.symbol = theCard.symbol.rawValue
        cardView.shadng = theCard.shading.rawValue
        cardView.number = theCard.number
        switch theCard.color {
        case .red :
            cardView.color = UIColor.red
        case .green:
            cardView.color = UIColor.green
        case .purple:
            cardView.color = UIColor.purple
        }
        cardView.backgroundColor = UIColor.clear
        cardView.contentMode = UIView.ContentMode.redraw
        addSubview(cardView)
        cardView.isHidden = true
        //print("Card View created: \(cardView.symbol), \(cardView.color), \(cardView.shadng), \(cardView.number)")
        return cardView
    }
    
    func setUpCardViews() {
        print("--- Set up Card views")
        for index in 0..<cards.count {
            let newView = createCardView(forCard: cards[index])
            cardViews.append(newView)
        }
    }
    
    func clearCardViews(){
       print("- Clear Card Views")
        for cardView in self.subviews {
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
        print(" Layout Card Table")
        cardGrid.frame = self.bounds
        cardGrid.cellCount = cards.count
        
        for index in 0..<cards.count {
            if let cardPos = cardGrid[index] {
                configureAndDisplayCardView(cardView: cardViews[index], atPosition: cardPos)
            }
        }
        
    }
}
