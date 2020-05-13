//
//  ViewController.swift
//  GraphicSET
//
//  Created by J Thomas Provost on 5/7/20.
//  Copyright © 2020 J Thomas Provost. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var cardTable: CardTableView!
    
    @IBOutlet weak var setCard: SetCardView!
    
    
    @IBOutlet weak var hardSymbol: SymbolView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
    // test set up
        cardTable.contentMode = UIView.ContentMode.redraw
        cardTable.cards.append(Card(color: Card.ShapeColor.red
        , symbol: Card.Symbol.diamond, shading: Card.Shading.solid, number: 2))
        cardTable.cards.append(Card(color: Card.ShapeColor.purple
        , symbol: Card.Symbol.oval, shading: Card.Shading.open, number: 3))
        cardTable.cards.append(Card(color: Card.ShapeColor.green
        , symbol: Card.Symbol.squiggle, shading: Card.Shading.striped, number: 1))
        
        cardTable.setNeedsDisplay()
    }


}

