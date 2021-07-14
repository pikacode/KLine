//
//  KLMarker.swift
//  KLine
//
//  Created by aax1 on 2021/7/12.
//

import Foundation
import CoreGraphics
import Charts

#if canImport(AppKit)
import AppKit
#endif
class KLMarker: NSUIView, IMarker {
    open var offset: CGPoint = CGPoint()
    
    @objc open weak var chartView: ChartViewBase?
    
    open func offsetForDrawing(atPoint point: CGPoint) -> CGPoint
    {
        guard let chart = chartView else { return self.offset }
        
        var offset = self.offset
        
        let width = self.bounds.size.width
        let height = self.bounds.size.height

        if point.x < width + 20 {
            offset.x = point.x + 10
        }else{
            offset.x = point.x - width - 10
        }
        
        let chartH = chart.bounds.size.height
        
        if point.y > chartH - height / 2 {
            offset.y = chartH - height
        }else if point.y < height / 2{
            offset.y = 10
        }else{
            offset.y = point.y - height / 2
        }

        return offset
    }
    
    open func refreshContent(entry: ChartDataEntry, highlight: Highlight)
    {
        // Do nothing here...
    }
    
    open func draw(context: CGContext, point: CGPoint)
    {
        let offset = self.offsetForDrawing(atPoint: point)
        
        context.saveGState()
        context.translateBy(x: offset.x,
                              y:  offset.y)
        UIGraphicsPushContext(context)
        self.layer.render(in: context)
        UIGraphicsPopContext()
        context.restoreGState()
    }
    
    @objc
    open class func viewFromXib(in bundle: Bundle = .main) -> MarkerView?
    {
        #if !os(OSX)
        
        return bundle.loadNibNamed(
            String(describing: self),
            owner: nil,
            options: nil)?[0] as? MarkerView
        #else
        
        var loadedObjects: NSArray? = NSArray()
        
        if bundle.loadNibNamed(
            NSNib.Name(String(describing: self)),
            owner: nil,
            topLevelObjects: &loadedObjects)
        {
            return loadedObjects?[0] as? MarkerView
        }
        
        return nil
        #endif
    }
}
