//
//  SymbolView.swift
//  GraphicSET
//
//  Created by J Thomas Provost on 5/9/20.
//  Copyright © 2020 J Thomas Provost. All rights reserved.
//

import UIKit

@IBDesignable
class SymbolView: UIView {

    /*
     This view will be used to display a single SET symbol on a SET card
     */
    
    enum Symbol : Int {
        case oval = 2
        case diamond = 1
        case squiggle = 3
    }
    
    enum Shading : Int {
        case open = 2
        case striped = 3
        case solid = 1
    }
    
    
    @IBInspectable var shading : Int = SymbolView.Shading.open.rawValue
    @IBInspectable var symbol : Int = SymbolView.Symbol.diamond.rawValue
    @IBInspectable var color : UIColor = UIColor.black
    
    var midWidth : CGFloat {
        return bounds.size.width / 2.0
    }
    
    var midHeight : CGFloat {
        return bounds.size.height / 2.0
    }
    
    var symbolHeight : CGFloat {
        return bounds.size.height
    }
    var symbolWidth : CGFloat {
        return bounds.size.width
    }
    
    private struct symbolValues {
        static let ovalCurve : CGFloat = 0.50
        static let lineWidth : CGFloat = 3.0
        static let backColor : UIColor = UIColor.white
        static let stripeColor : UIColor = UIColor.green  // for testing
    }
    

    override func draw(_ rect: CGRect) {
         // Drawing code
    
        //self.backgroundColor = symbolValues.backColor
        
        var symbolPath = UIBezierPath()
        
        switch symbol {
        case SymbolView.Symbol.diamond.rawValue:
            symbolPath = UIBezierPath()
            symbolPath.move(to: CGPoint(x: midWidth, y: 0.0))
            symbolPath.addLine(to: CGPoint(x: bounds.size.width, y: midHeight))
            symbolPath.addLine(to: CGPoint(x: midWidth, y: bounds.size.height))
            symbolPath.addLine(to: CGPoint(x: 0.0, y: midHeight))
            symbolPath.close()
        case SymbolView.Symbol.oval.rawValue:
            symbolPath = UIBezierPath(roundedRect: bounds, cornerRadius: bounds.size.width * symbolValues.ovalCurve)
        case SymbolView.Symbol.squiggle.rawValue:
            symbolPath = UIBezierPath()
            symbolPath.move(to: CGPoint(x: 0.0, y: 0.0))
            symbolPath.addLine(to: CGPoint(x: 0.75*symbolWidth, y: 0.32*symbolHeight))
            symbolPath.addLine(to: CGPoint(x: 0.70*symbolWidth, y: 0.68*symbolHeight))
            symbolPath.addLine(to: CGPoint(x: symbolWidth, y: symbolHeight))
            symbolPath.addLine(to: CGPoint(x: 0.20*symbolWidth, y: 0.68*symbolHeight))
            symbolPath.addLine(to: CGPoint(x: 0.32*symbolWidth, y: 0.32*symbolHeight))
            symbolPath.close()
        default:
            break
        }
        symbolPath.addClip()
        symbolPath.lineWidth = symbolValues.lineWidth
        color.setStroke()
        
        switch shading {
        case SymbolView.Shading.solid.rawValue:
            color.setFill()
        case SymbolView.Shading.striped.rawValue:
            symbolValues.stripeColor.setFill()
        case SymbolView.Shading.open.rawValue:
            symbolValues.backColor.setFill()
        default:
            break
        }
        
        symbolPath.fill()
        symbolPath.stroke()
        
    }
    
    

}
