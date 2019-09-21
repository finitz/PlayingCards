//
//  PLayingCardsView.swift
//  PlayingCards
//
//  Created by 17 on 9/18/19.
//  Copyright © 2019 17. All rights reserved.
//

import UIKit

class PlayingCardView: UIView {
    
    var card: PlayingCard = PlayingCard(suit: .clubs, rank: .five) {
        didSet {
            setNeedsLayout()
            setNeedsDisplay()
        }
    }
    
    lazy var upperLeftLabel :UILabel = createLabel()
    lazy var lowerRightLabel :UILabel = createLabel()
    
    var isFlipped: Bool = false {
        didSet {
            setNeedsLayout()
            setNeedsDisplay()
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setNeedsLayout()
        setNeedsDisplay()
    }
    
    func createLabel()-> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        addSubview(label)
        
        return label
    }
    
    private func centeredAttributedString(_ string: String, fontSize: CGFloat) -> NSAttributedString {
        var font = UIFont.preferredFont(forTextStyle: .body).withSize(fontSize)
        font = UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        return NSAttributedString(string: string, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle, .font: font])
    }
    
    private var cornerString: NSAttributedString {
        return centeredAttributedString(card.description, fontSize: 0.0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let fontSize : CGFloat = 0.1 * self.bounds.width
        let attributedString = centeredAttributedString(card.description, fontSize: fontSize)
        
        let offset : CGFloat = 20
        upperLeftLabel.attributedText = attributedString
        upperLeftLabel.frame = CGRect.zero
        upperLeftLabel.sizeToFit()
        upperLeftLabel.frame = CGRect(x: offset, y: offset, width: upperLeftLabel.frame.width, height: upperLeftLabel.frame.height)
        upperLeftLabel.isHidden = isFlipped
        
        
        lowerRightLabel.attributedText = attributedString
        lowerRightLabel.frame = CGRect.zero
        lowerRightLabel.sizeToFit()
        lowerRightLabel.frame = CGRect(x: bounds.maxX - offset - lowerRightLabel.frame.width, y: bounds.maxY - offset - lowerRightLabel.frame.height, width: upperLeftLabel.frame.width, height: upperLeftLabel.frame.height)
        lowerRightLabel.transform = CGAffineTransform.identity.rotated(by: CGFloat.pi)
        lowerRightLabel.isHidden = isFlipped
    }
    
    override func draw(_ rect: CGRect) {
        let roundRect = UIBezierPath(roundedRect: bounds, cornerRadius: 14.0)
        roundRect.addClip()
        UIColor.white.setFill()
        roundRect.fill()
        
        if isFlipped {
            let img = UIImage(named: "cardBack")!
            img.draw(in: bounds)
        } else {
            if let faceCardImage = UIImage(named: card.rank.description + card.suit.description) {
                faceCardImage.draw(in: bounds.zoom(by: CGFloat(0.75)))
            }
            else {
                drawPips()
            }
        }
        
    }
    
    private func drawPips()
    {
        let pipsPerRowForRank = [[0], [1], [1,1], [1,1,1], [2,2], [2,1,2], [2,2,2], [2,1,2,2], [2,2,2,2], [2,2,1,2,2], [2,2,2,2,2]]

        func createPipString(thatFits pipRect: CGRect) -> NSAttributedString {
            let maxVerticalPipCount = CGFloat(pipsPerRowForRank.reduce(0) { max($1.count, $0)})
            let maxHorizontalPipCount = CGFloat(pipsPerRowForRank.reduce(0) { max($1.max() ?? 0, $0)})
            let verticalPipRowSpacing = pipRect.size.height / maxVerticalPipCount
            let attemptedPipString = centeredAttributedString(card.suit.description, fontSize: verticalPipRowSpacing)
            let probablyOkayPipStringFontSize = verticalPipRowSpacing / (attemptedPipString.size().height / verticalPipRowSpacing)
            let probablyOkayPipString = centeredAttributedString(card.suit.description, fontSize: probablyOkayPipStringFontSize)
            if probablyOkayPipString.size().width > pipRect.size.width / maxHorizontalPipCount {
                return centeredAttributedString(card.suit.description, fontSize: probablyOkayPipStringFontSize /
                    (probablyOkayPipString.size().width / (pipRect.size.width / maxHorizontalPipCount)))
            } else {
                return probablyOkayPipString
            }
        }

        if pipsPerRowForRank.indices.contains(card.rank.rawValue) {
            let pipsPerRow = pipsPerRowForRank[card.rank.rawValue]
            var pipRect = bounds.insetBy(dx: cornerOffset, dy: cornerOffset).insetBy(dx: cornerString.size().width, dy: cornerString.size().height / 2)
            let pipString = createPipString(thatFits: pipRect)
            let pipRowSpacing = pipRect.size.height / CGFloat(pipsPerRow.count)
            pipRect.size.height = pipString.size().height
            pipRect.origin.y += (pipRowSpacing - pipRect.size.height) / 2
            for pipCount in pipsPerRow {
                switch pipCount {
                case 1:
                    pipString.draw(in: pipRect)
                case 2:
                    pipString.draw(in: pipRect.leftHalf)
                    pipString.draw(in: pipRect.rightHalf)
                default:
                    break
                }
                pipRect.origin.y += pipRowSpacing
            }
        }
    }
    
    private struct SizeRatio {
        static let cornerFontSizeToBoundsHeight: CGFloat = 0.085
        static let cornerRadiusToBoundsHeight: CGFloat = 0.06
        static let cornerOffsetToCornerRadius: CGFloat = 0.33
        static let faceCardImageSizeToBoundsSize: CGFloat = 0.95
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
    func zoom(by zoomFactor: CGFloat) -> CGRect {
        let zoomedWidth = size.width * zoomFactor
        let zoomedHeight = size.height * zoomFactor
        let originX = origin.x + (size.width - zoomedWidth) / 2
        let originY = origin.y + (size.height - zoomedHeight) / 2
        return CGRect(origin: CGPoint(x: originX,y: originY) , size: CGSize(width: zoomedWidth, height: zoomedHeight))
    }
    
    var leftHalf: CGRect {
        let width = size.width / 2
        return CGRect(origin: origin, size: CGSize(width: width, height: size.height))
    }
    
    var rightHalf: CGRect {
        let width = size.width / 2
        return CGRect(origin: CGPoint(x: origin.x + width, y: origin.y), size: CGSize(width: width, height: size.height))
    }
}
