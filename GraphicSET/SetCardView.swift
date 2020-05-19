//
//  SetCardView.swift
//  GraphicSET
//
//  Created by J Thomas Provost on 5/7/20.
//  Copyright © 2020 J Thomas Provost. All rights reserved.
//

import UIKit

class SetCardView: UIView {

    private struct displayConst {
        static let cardBackground : UIColor = symbolValues.backColor
    }
    var symbol : Int = SymbolView.Symbol.diamond.rawValue {
        didSet { setNeedsDisplay(); setNeedsLayout() }
    }
    var shadng : Int = SymbolView.Shading.open.rawValue {
        didSet { setNeedsDisplay(); setNeedsLayout() }
    }
    var color : UIColor = UIColor.black {
        didSet { setNeedsDisplay(); setNeedsLayout() }
    }
    var number : Int = 2 {
        didSet { setNeedsDisplay(); setNeedsLayout() }
    }
    var backColor : UIColor = UIColor.white {
        didSet { setNeedsDisplay(); setNeedsLayout() }
    }
    var card : Card? = nil {
        didSet { setNeedsDisplay(); setNeedsLayout() }
    }
 
    private struct symbolValues {
        static let ovalCurve : CGFloat = 0.50
        static let lineWidth : CGFloat = 3.0
        static let backColor : UIColor = UIColor.white
        static let stripeColor : UIColor = UIColor.green  // for testing
        static let stripeGap : CGFloat = 6.0
    }
    
    private func drawSymbol(startingAt initOrigin: CGPoint, forCount number: Int) {
        var  minX : CGFloat = initOrigin.x
        let  minY : CGFloat = initOrigin.y
        var  midX : CGFloat  { return minX + (symbolWidth / 2.0) }
        var  midY : CGFloat  { return minY + (symbolHeight / 2.0) }
        var  maxX : CGFloat  { return minX + symbolWidth }
        let  maxY : CGFloat = minY + symbolHeight
        
        let symbolPath = UIBezierPath()
        
        if number == 1 {
            minX += widthBetweenSymbols
        } else if number == 2 {
            minX = Origin21.x
        }
        
        for _ in 0..<number {
            switch symbol {
            case Card.Symbol.diamond.rawValue:
                symbolPath.move(to: CGPoint(x: midX, y: minY))
                symbolPath.addLine(to: CGPoint(x: maxX, y: midY))
                symbolPath.addLine(to: CGPoint(x: midX, y: maxY))
                symbolPath.addLine(to: CGPoint(x: minX, y: midY))
                symbolPath.close()
                symbolPath.lineWidth = symbolValues.lineWidth
            case Card.Symbol.oval.rawValue:
                let rect = CGRect(origin: CGPoint(x: minX, y: minY), size: CGSize(width: symbolWidth, height: symbolHeight))
                let ovalPath = UIBezierPath(roundedRect: rect, cornerRadius: rect.size.width * symbolValues.ovalCurve)
                symbolPath.append(ovalPath)
            case Card.Symbol.squiggle.rawValue:
                symbolPath.move(to: CGPoint(x: minX, y: minY))
                symbolPath.addLine(to: CGPoint(x: minX + 0.75*symbolWidth, y: minY + 0.32*symbolHeight))
                symbolPath.addLine(to: CGPoint(x: minX + 0.50*symbolWidth, y: minY + 0.68*symbolHeight))
                symbolPath.addLine(to: CGPoint(x: maxX, y: maxY))
                symbolPath.addLine(to: CGPoint(x: minX + 0.20*symbolWidth, y: minY + 0.68*symbolHeight))
                symbolPath.addLine(to: CGPoint(x: minX + 0.32*symbolWidth, y: minY + 0.32*symbolHeight))
                symbolPath.close()
            default:
                break
            }
            
            minX += widthBetweenSymbols

        }
            
           symbolPath.addClip()
        
            switch shadng {
            case SymbolView.Shading.solid.rawValue:
                color.setFill()
            case SymbolView.Shading.striped.rawValue:
                var lineY : CGFloat = minY + symbolValues.stripeGap
                repeat {
                    symbolPath.move(to: CGPoint(x: initOrigin.x, y: lineY))
                    symbolPath.addLine(to: CGPoint(x: maxX, y: lineY))
                    lineY += symbolValues.stripeGap
                } while lineY < maxY
                symbolValues.backColor.setFill()
            case SymbolView.Shading.open.rawValue:
                symbolValues.backColor.setFill()
            default:
                break
            }
            
        symbolPath.lineWidth = symbolValues.lineWidth
        color.setStroke()
        symbolPath.fill()
        symbolPath.stroke()
        
    }
    
    override func draw(_ rect: CGRect) {
        // Draw card background with rounded corners
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        roundedRect.addClip()
        displayConst.cardBackground.setFill()
        roundedRect.fill()
        
        // draw the symbols in the card
        drawSymbol(startingAt: Origin1, forCount: number)
    }
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
    
    private struct cardAttributes {
        static let selectedBorderWidth: CGFloat = 5.0
        static let selectedBorderColor: CGColor = UIColor.blue.cgColor
        static let highlightBackground: UIColor = UIColor.cyan
    }
    
    private func selected() {
        self.layer.borderWidth = cardAttributes.selectedBorderWidth
        self.layer.borderColor = cardAttributes.selectedBorderColor
    }
    private func highlighted() {
        self.backColor = cardAttributes.highlightBackground
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

