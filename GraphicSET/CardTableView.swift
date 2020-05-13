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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpCardViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpCardViews()
        
    }
    
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
    private var cardViews = [SetCardView]()
    
    //[Card(color: Card.ShapeColor.red
//    , symbol: Card.Symbol.diamond, shading: Card.Shading.solid, number: 2),Card(color: Card.ShapeColor.purple
//    , symbol: Card.Symbol.oval, shading: Card.Shading.open, number: 3))]
    
//    private var card1 = Card(color: Card.ShapeColor.red
//        , symbol: Card.Symbol.diamond, shading: Card.Shading.solid, number: 2)
//    private var card2 = Card(color: Card.ShapeColor.purple
//    , symbol: Card.Symbol.oval, shading: Card.Shading.open, number: 3)
//
//    private var cardView1 = SetCardView()
//    private var cardView2 = SetCardView()
    
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
        cardViews.append(cardView)
        cardView.isHidden = true
        
        return cardView
    }
    
    private func setUpCardViews() {
        for card in cards {
        let _ = createCardView(forCard: card)
        }
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
    
    
    override func draw(_ rect: CGRect) {
//        cards.append(card1)
//        cards.append(card2)
        
//        cardView1 = createCardView(forCard: card1)
//        cardView2 = createCardView(forCard: card2)
        }

    override func layoutSubviews() {
        super.layoutSubviews()
        
//        let o1 = CGPoint(x: 10.10, y: 25.0)
//        let s1 = CGSize(width: 200, height: 80)
//        let o2 = CGPoint(x: 50.0, y: 300)
//        let s2 = CGSize(width: 100, height: 40)
//
//        configureAndDisplayCardView(cardView: cardView1, atOrigin: o1, withSize: s1)
//        configureAndDisplayCardView(cardView: cardView2, atOrigin: o2, withSize: s2)
        
        setUpCardViews()
        
        cardGrid.frame = self.bounds
        cardGrid.cellCount = cards.count
        
        for index in 0..<cards.count {
            if let cardPos = cardGrid[index] {
                configureAndDisplayCardView(cardView: cardViews[index], atPosition: cardPos)
            }
        }
        
//        var orig = CGPoint(x: 20.0, y: 50.0)
//        let cardSize = CGSize(width: 120, height: 70)
//
//        for cv in cardViews {
//            let posRect = CGRect(origin: orig, size: cardSize)
//            configureAndDisplayCardView(cardView: cv, atPosition: posRect)
//            orig = orig.offsetBy(dx: 10.0, dy: cardSize.height + 10.0)
//        }
    }
}
