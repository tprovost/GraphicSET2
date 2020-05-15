//
//  SetCardView.swift
//  GraphicSET
//
//  Created by J Thomas Provost on 5/7/20.
//  Copyright © 2020 J Thomas Provost. All rights reserved.
//

import UIKit

//@IBDesignable
class SetCardView: UIView {

    private struct displayConst {
        static let cardBackground : UIColor = UIColor.white
    }
//    @IBInspectable
    var symbol : Int = SymbolView.Symbol.diamond.rawValue {
        didSet { setNeedsDisplay(); setNeedsLayout() }
    }
//    @IBInspectable
    var shadng : Int = SymbolView.Shading.open.rawValue {
        didSet { setNeedsDisplay(); setNeedsLayout() }
    }
//    @IBInspectable
    var color : UIColor = UIColor.black {
        didSet { setNeedsDisplay(); setNeedsLayout() }
    }
//    @IBInspectable
    var number : Int = 2 {
        didSet { setNeedsDisplay(); setNeedsLayout() }
    }
//    @IBInspectable
    var backColor : UIColor = UIColor.white {
        didSet { setNeedsDisplay(); setNeedsLayout() }
    }
 
    private func createSymbol() -> SymbolView {
        let symbol = SymbolView()
        symbol.shading = self.shadng
        symbol.symbol = self.symbol
        symbol.color = self.color
        symbol.bounds = CGRect(x: 0.0, y: 0.0, width: symbolWidth, height: symbolHeight)
        symbol.backgroundColor = backColor
        addSubview(symbol)
        symbol.isHidden = true
        return symbol
    }
    
    private func configureSymbol(theSymbol:SymbolView, origin: CGPoint) {
        theSymbol.frame = CGRect(origin: origin, size: symbolSize)
        theSymbol.isHidden = false
//        print("Configure symbol \(theSymbol) at \(theSymbol.frame)")
        
    }
    

    
    override func draw(_ rect: CGRect) {
        // Draw card background with rounded corners
    print("--- Draw Set Card with \(self.number) symbols")
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        roundedRect.addClip()
        displayConst.cardBackground.setFill()
        roundedRect.fill()
        
        let symbolToDraw: SymbolView = createSymbol()
//        let symb2  : SymbolView = createSymbol()
//        let symb3 : SymbolView = createSymbol()
        
        switch self.number {
        case 1:
            configureSymbol(theSymbol: symbolToDraw, origin: Origin2)
        case 2:
            configureSymbol(theSymbol: symbolToDraw, origin: Origin21)
            let symb2  : SymbolView = createSymbol()
            configureSymbol(theSymbol: symb2, origin: Origin22)
        case 3:
            configureSymbol(theSymbol: symbolToDraw, origin: Origin1)
            let symb2  : SymbolView = createSymbol()
            configureSymbol(theSymbol: symb2, origin: Origin2)
            let symb3 : SymbolView = createSymbol()
            configureSymbol(theSymbol: symb3, origin: Origin3)
        default:
            break
        }
        
    }

//    private lazy var symbolToDraw: SymbolView = createSymbol()
//    private lazy var symb2  : SymbolView = createSymbol()
//    private lazy var symb3 : SymbolView = createSymbol()

    
//    override func layoutSubviews() {
//           super.layoutSubviews()
//
//        switch number {
//        case 1:
//            configureSymbol(theSymbol: symbolToDraw, origin: Origin2)
//        case 2:
//            configureSymbol(theSymbol: symbolToDraw, origin: Origin21)
//            configureSymbol(theSymbol: symb2, origin: Origin22)
//        case 3:
//            configureSymbol(theSymbol: symbolToDraw, origin: Origin1)
//            configureSymbol(theSymbol: symb2, origin: Origin2)
//            configureSymbol(theSymbol: symb3, origin: Origin3)
//        default:
//            break
//        }

}



extension SetCardView {
    private struct SizeRatio {
        static let cornerFontSizeToBoundsHeight: CGFloat = 0.085
        static let cornerRadiusToBoundsHeight: CGFloat = 0.06
        static let cornerOffsetToCornerRadius: CGFloat = 0.33
        static let faceCardImageSizeToBoundsSize: CGFloat = 0.75
        
        static let symbolWidthtoBoundsWidth: CGFloat = 0.25
        static let symbolHeighttoBoundsHeight: CGFloat = 0.80
        static let gapWidthRatio: CGFloat = 0.0625
        static let gapHeightRatio: CGFloat = 0.10
        
    }
    
    private var symbolWidth: CGFloat {
        return bounds.size.width * SizeRatio.symbolWidthtoBoundsWidth
    }
    private var symbolHeight: CGFloat {
        return bounds.size.height * SizeRatio.symbolHeighttoBoundsHeight
    }
    private var symbolSize: CGSize {
        return CGSize(width: symbolWidth, height: symbolHeight)
    }
    private var gapWidth: CGFloat {
        return bounds.size.width * SizeRatio.gapWidthRatio
    }
    private var gapHeight: CGFloat {
        return bounds.size.height * SizeRatio.gapHeightRatio
    }
    private var Origin1: CGPoint {
        return CGPoint(x:gapWidth, y:gapHeight)
    }
    private var Origin2: CGPoint {
        return Origin1.offsetBy(dx: symbolWidth + gapWidth, dy: 0.0)
    }
    private var Origin3: CGPoint {
        return Origin2.offsetBy(dx: symbolWidth + gapWidth, dy: 0.0)
    }
    private var Origin21: CGPoint {
        return CGPoint(x:bounds.size.width / 2.0 - gapWidth - symbolWidth, y:gapHeight)
    }
    private var Origin22: CGPoint {
        return Origin21.offsetBy(dx: symbolWidth+gapWidth, dy: 0.0)
    }
    private var widthBetweenSymbols: CGFloat {
        return symbolWidth + gapWidth
    }
    
    
    
    private var cornerRadius: CGFloat {
        return bounds.size.height * SizeRatio.cornerRadiusToBoundsHeight
    }
    private var cornerOffset: CGFloat {
        return cornerRadius * SizeRatio.cornerOffsetToCornerRadius
    }
    private var cornerFontSize: CGFloat {
        return bounds.size.height * SizeRatio.cornerFontSizeToBoundsHeight
    }
//    private var rankString: String {
//        switch rank {
//        case 1: return "A"
//        case 2...10: return String(rank)
//        case 11: return "J"
//        case 12: return "Q"
//        case 13: return "K"
//        default: return "?"
//        }
//    }
}

extension CGRect {
    var leftHalf: CGRect {
        return CGRect(x: minX, y: minY, width: width/2, height: height)
    }
    var rightHalf: CGRect {
        return CGRect(x: midX, y: minY, width: width/2, height: height)
    }
    func inset(by size: CGSize) -> CGRect {
        return insetBy(dx: size.width, dy: size.height)
    }
    func sized(to size: CGSize) -> CGRect {
        return CGRect(origin: origin, size: size)
    }
    func zoom(by scale: CGFloat) -> CGRect {
        let newWidth = width * scale
        let newHeight = height * scale
        return insetBy(dx: (width - newWidth) / 2, dy: (height - newHeight) / 2)
    }
}

extension CGPoint {
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: x+dx, y: y+dy)
    }
}

