//
//  NDRangeBarView.swift
//  QooTmp
//
//  Created by giggs on 2022/3/14.
//

import Foundation
import UIKit

@IBDesignable class NDRangeBarView: UIView {
    
    // MARK: - Inspeactable var
    @IBInspectable var maxValue: CGFloat = 100.0 {
        didSet {
            let lowerRatio = (lowerValue - minValue) / (oldValue - minValue)
            let upperRatio = (upperValue - minValue) / (oldValue - minValue)
            
            lowerValue = (maxValue - minValue) * lowerRatio
            upperValue = (maxValue - minValue) * upperRatio
        }
    }
    
    @IBInspectable var minValue: CGFloat = 0.0 {
        didSet {
            let lowerRatio = (lowerValue - minValue) / (maxValue - oldValue)
            let upperRatio = (upperValue - minValue) / (maxValue - oldValue)
            
            lowerValue = (maxValue - minValue) * lowerRatio
            upperValue = (maxValue - minValue) * upperRatio
        }
    }
    
    @IBInspectable var lowerValue: CGFloat = 30.0 {
        didSet {
            updateLayers()
        }
    }
    
    @IBInspectable var lowerTextPattern: String = "%.1f" {
        didSet {
            updateLayers()
        }
    }
    
    @IBInspectable var upperValue: CGFloat = 70.0 {
        didSet {
            updateLayers()
        }
    }
    
    @IBInspectable var upperTextPattern: String = "%.1f" {
        didSet {
            updateLayers()
        }
    }
    
    @IBInspectable var fontName: String = "Roboto-Regular" {
        didSet {
            invalidateIntrinsicContentSize()
            updateLayers()
        }
    }
    
    @IBInspectable var fontSize: CGFloat = 11.0 {
        didSet {
            invalidateIntrinsicContentSize()
            updateLayers()
        }
    }
    
    @IBInspectable var fontColor: UIColor = .white {
        didSet {
            updateLayers()
        }
    }
    
    @IBInspectable var trackHeight: CGFloat = 16.0 {
        didSet {
            invalidateIntrinsicContentSize()
            updateLayers()
        }
    }
    
    // #Pricing Title
    @IBInspectable var trackBackgroundColor: UIColor = UIColor(0x6b5774FF) {
        didSet {
            updateLayers()
        }
    }
    
    @IBInspectable var trackFillStartColor: UIColor = UIColor(0xff8432FF) {
        didSet {
            updateLayers()
        }
    }
    
    @IBInspectable var trackFillEndColor: UIColor = UIColor(0xff6906FF) {
        didSet {
            updateLayers()
        }
    }
    
    @IBInspectable var thumbWidth: CGFloat = 6.0 {
        didSet {
            updateLayers()
        }
    }
    
    @IBInspectable var thumbBorderWidth: CGFloat = 1.0 {
        didSet {
            updateLayers()
        }
    }
    
    @IBInspectable var thumbInsetYFromTrack: CGFloat = -4.0 {
        didSet {
            updateLayers()
        }
    }
    
    @IBInspectable var thumbBorderColor: UIColor = UIColor(0xffffffff) {
        didSet {
            updateLayers()
        }
    }
    
    // #brightOrange
    @IBInspectable var thumbFillColor: UIColor = UIColor(0xff6600ff) {
        didSet {
            updateLayers()
        }
    }
    
    @IBInspectable var textPaddingFromTrack: CGFloat = 8.0 {
        didSet {
            invalidateIntrinsicContentSize()
            updateLayers()
        }
    }
    
    // MARK: - Override var
    override open var frame: CGRect {
        didSet {
            updateLayers()
        }
    }
    
    override open var bounds: CGRect {
        didSet {
            updateLayers()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        let h = trackHeight + (textPaddingFromTrack * 2.0) + lowerTextStr.size().height + upperTextStr.size().height
        return CGSize(width: UIView.noIntrinsicMetric, height: h)
    }
    
    // MARK: - SubLayers
    
    private lazy var trackLayer = createTrackLayer()
    private lazy var lowerThumbLayer = createThumbLayer()
    private lazy var upperThumbLayer = createThumbLayer()
    private lazy var lowerTextLayer = createTextLayer()
    private lazy var upperTextLayer = createTextLayer()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    private func setup() -> Void {
        layer.addSublayer(trackLayer)
        layer.addSublayer(upperThumbLayer)
        layer.addSublayer(lowerThumbLayer)
        layer.addSublayer(upperTextLayer)
        layer.addSublayer(lowerTextLayer)
    }
    
}

private extension NDRangeBarView {
    enum Direction {
        case top, bottom
    }
    
    struct TextRenderInfo {
        let str: NSAttributedString
        let dir: Direction
        let centerX: CGFloat
    }
}

private extension NDRangeBarView {
    
    var valueWidth: CGFloat {
        bounds.width - (clipsToBounds ? thumbWidth : 0.0)
    }
    
    var thumbXOffset: CGFloat {
        clipsToBounds ? (thumbWidth * 0.5) : 0.0
    }
    
    var lowerX: CGFloat {
        (lowerValue - minValue) / (maxValue - minValue) * valueWidth + thumbXOffset
    }
    
    var upperX: CGFloat {
        (upperValue - minValue) / (maxValue - minValue) * valueWidth + thumbXOffset
    }
    
    var lowerTextStr: NSAttributedString {
        createAttrString(value: lowerValue, pattern: lowerTextPattern)
    }
    
    var upperTextStr: NSAttributedString {
        createAttrString(value: upperValue, pattern: upperTextPattern)
    }
    
    var fontAttrs: [NSAttributedString.Key: Any] {
        let font = UIFont(name: fontName, size: fontSize) ?? .systemFont(ofSize: fontSize)
        
        return [
            .font: font,
            .foregroundColor: fontColor
        ]
    }
    
}

private extension NDRangeBarView {
    
    func createTrackLayer() -> NDRangeViewTrackLayer {
        let l = NDRangeViewTrackLayer()
        l.layerDelegate = self
        l.contentsScale = UIScreen.main.scale
        
        return l
    }
    
    func createThumbLayer() -> NDRangeViewThumbLayer {
        let l = NDRangeViewThumbLayer()
        l.layerDelegate = self
        l.contentsScale = UIScreen.main.scale
        
        return l
    }
    
    func createTextLayer() -> CATextLayer {
        let l = CATextLayer()
        l.contentsScale = UIScreen.main.scale
        l.alignmentMode = .center
        
        return l
    }
    
    func createAttrString(value: CGFloat, pattern: String) -> NSAttributedString {
        let s = String(format: pattern, value)
        return NSAttributedString(string: s, attributes: fontAttrs)
    }
    
    func updateLayers() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        let trackInset = bounds.height - trackHeight
        let trackFrame = bounds.insetBy(dx: 0.0, dy: trackInset * 0.5)
        
        let thumbHeight = trackFrame.height - thumbInsetYFromTrack
        let thumbY = trackFrame.minY + (thumbInsetYFromTrack * 0.5)
        
        let lowerThumbX = lowerX - (thumbWidth * 0.5)
        let upperThumbX = upperX - (thumbWidth * 0.5)
        
        let lowerThumbFrame = CGRect(x: lowerThumbX, y: thumbY, width: thumbWidth, height: thumbHeight)
        let upperThumbFrame = CGRect(x: upperThumbX, y: thumbY, width: thumbWidth, height: thumbHeight)
        
        trackLayer.frame = trackFrame
        trackLayer.setNeedsDisplay()
        
        lowerThumbLayer.frame = lowerThumbFrame
        lowerThumbLayer.setNeedsDisplay()
        
        upperThumbLayer.frame = upperThumbFrame
        upperThumbLayer.setNeedsDisplay()
        
        updateTextLayer(upperTextLayer)
        updateTextLayer(lowerTextLayer)
        
        CATransaction.commit()
    }
    
    func updateTextLayer(_ layer: CATextLayer) -> Void {
        guard let info = renderInfo(of: layer) else {
            return
        }
        
        let size = info.str.size()
        
        let x: CGFloat = {
            var o = info.centerX - (size.width * 0.5)
            o = min(o, trackLayer.frame.maxX - size.width)
            o = max(o, 0.0)
            return o
        }()
        
        let y: CGFloat = {
            let halfTrackHeight = trackLayer.frame.size.height * 0.5
            
            switch info.dir {
                case .top:
                    return trackLayer.frame.midY - (halfTrackHeight + textPaddingFromTrack + size.height)
                case .bottom:
                    return trackLayer.frame.midY + halfTrackHeight + textPaddingFromTrack
            }
        }()
        
        layer.string = info.str
        layer.frame = CGRect(origin: CGPoint(x: x, y: y), size: size)
        
        setNeedsLayout()
    }
    
    func renderInfo(of layer: CATextLayer) -> TextRenderInfo? {
        switch layer {
            case lowerTextLayer:
                return TextRenderInfo(str: lowerTextStr, dir: .top, centerX: lowerX)
            case upperTextLayer:
                return TextRenderInfo(str: upperTextStr, dir: .bottom, centerX: upperX)
            default:
                return nil
        }
    }
    
}

// MARK: - Implement delegates
extension NDRangeBarView: NDRangeViewTrackLayerDelegate, NDRangeViewThumbLayerDelegate {
    
    var trackerRadius: CGFloat {
        trackHeight * 0.5
    }
    
    var trackerLowerX: CGFloat {
        lowerX
    }
    
    var trackerUpperX: CGFloat {
        upperX
    }
    
    var thumbRadius: CGFloat {
        min(abs(thumbInsetYFromTrack * 0.5), thumbWidth * 0.5)
    }
    
}

// MARK: - NDRangeViewTrackLayer
class NDRangeViewTrackLayer: CALayer {

    weak var layerDelegate: NDRangeViewTrackLayerDelegate?
    
    private lazy var gLayer: CAGradientLayer = createGradientLayer()
    
    override public func draw(in ctx: CGContext) {
        guard let _delegate = layerDelegate else {
            return
        }
        
        // bg bar
        ctx.setFillColor(_delegate.trackBackgroundColor.cgColor)
        ctx.fill(bounds)
        
        // fill bar
        let x: CGFloat = _delegate.trackerLowerX
        let y: CGFloat = .zero
        let w: CGFloat = _delegate.trackerUpperX - _delegate.trackerLowerX
        let h: CGFloat = bounds.height
        let fillFrame = CGRect(x: x, y: y, width: w, height: h)
        
        gLayer.colors = [_delegate.trackFillStartColor.cgColor, _delegate.trackFillEndColor.cgColor]
        gLayer.frame = fillFrame
        
        cornerRadius = _delegate.trackerRadius
        masksToBounds = true
    }
    
    override func layoutSublayers() {
        super.layoutSublayers()
        
        addSublayer(gLayer)
    }
    
    private func createGradientLayer() -> CAGradientLayer {
        let l = CAGradientLayer()
        l.locations = [0.0, 1.0]
        l.startPoint = CGPoint(x: 0.0, y: 0.0)
        l.endPoint = CGPoint(x: 1.0, y: 0.0)
        
        return l
    }
    
}

protocol NDRangeViewTrackLayerDelegate: AnyObject {
    
    var trackerRadius: CGFloat { get }
    var trackerLowerX: CGFloat { get }
    var trackerUpperX: CGFloat { get }
    var trackBackgroundColor: UIColor { get }
    var trackFillStartColor: UIColor { get }
    var trackFillEndColor: UIColor { get }
    
}



// MARK: - NDRangeViewThumbLayer
class NDRangeViewThumbLayer: CALayer {
    
    weak var layerDelegate: NDRangeViewThumbLayerDelegate?
    
    override public func draw(in ctx: CGContext) {
        guard let _delegate = layerDelegate else {
            return
        }
        
        let outPath = UIBezierPath(roundedRect: bounds, cornerRadius: _delegate.thumbRadius)
        ctx.addPath(outPath.cgPath)
        ctx.setFillColor(_delegate.thumbBorderColor.cgColor)
        ctx.fillPath()
        
        let inRect = bounds.insetBy(dx: _delegate.thumbBorderWidth, dy: _delegate.thumbBorderWidth)
        let inPath = UIBezierPath(roundedRect: inRect, cornerRadius: _delegate.thumbRadius)
        ctx.addPath(inPath.cgPath)
        ctx.setFillColor(_delegate.thumbFillColor.cgColor)
        ctx.fillPath()
        
    }
    
}

protocol NDRangeViewThumbLayerDelegate: AnyObject {
    
    var thumbBorderWidth: CGFloat { get }
    var thumbRadius: CGFloat { get }
    var thumbBorderColor: UIColor { get }
    var thumbFillColor: UIColor { get }
    
}
