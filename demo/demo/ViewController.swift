//
//  ViewController.swift
//  demo
//
//  Created by pikacode on 2021/6/1.
//

import UIKit
import KLine

enum DateFormat: String {
    case min = "mm:ss"
    case hour = "dd-MM hh:mm"
    case day = "yyyy-MM-dd"
}

class ViewController: UIViewController {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentHeight: NSLayoutConstraint!

    var depthContenView = UIView.init(frame: CGRect.init(x: 0, y: 500, width: UIScreen.main.bounds.size.width, height: 300))
    var depthKLineView: KLineView!
    var klineView: KLineView!

    // 👉 create demo data, in real project you may create it by request
    // 👉 the type [KLineData] can be customed to [Any]
    let data: [KLineData] = {
        let start: TimeInterval = 1623749243
        let count = 360
        var temp = [KLineData]()
        for i in 0..<count {
            let v = Double.random(in: 500000...3000000)
            let t = start + TimeInterval(i * 60 * 60 * 24)
            let o: Double
            if i > 0 {
                o = temp[i-1].close
            } else {
                o = Double.random(in: 380...400)
            }
            var arr = [o,
                       Double.random(in: (o*0.92)...(o*1.08)),
                       Double.random(in: (o*0.92)...(o*1.08)),
                       Double.random(in: (o*0.92)...(o*1.08))].sorted()
            let h = arr.removeLast()
            let l = arr.removeFirst()
            let c = arr[0] == o ? arr[1] : arr[0]
            let d = KLineData(o: o, c: c, h: h, l: l, v: v, t: t)
            temp.append(d)
        }
        return temp
    }()
    
    let depthData: [KLDepthPoint] = {
        let start: TimeInterval = 1623749243
        let count = 40
        var temp = [KLDepthPoint]()
        let path = Bundle.main.path(forResource: "depth", ofType: "json")
        let url = URL(fileURLWithPath: path!)
        do{
            let jsonData:Any = try JSONSerialization.jsonObject(with: Data(contentsOf: url), options: JSONSerialization.ReadingOptions.mutableContainers)
            let jsonArr = jsonData as? NSDictionary
            let asks = jsonArr?["asks"] as? NSArray
            let bids = jsonArr?["bids"] as? NSArray
        
            if let asks = jsonArr?["bids"] as? NSArray{
                for item in asks {
                    if let item = item as? NSArray {
                        let type = KLDepthPoint.TradingType.buy
                        let p = item.firstObject as? Double ?? 0
                        let a = item.lastObject as? Double ?? 0
                        let d = KLDepthPoint.init(p: p, t: type, a: a)
                        temp.append(d)
                        
                    }
                }
            }
            
            if let bids = jsonArr?["asks"] as? NSArray{
                for item in bids {
                    if let item = item as? NSArray {
                        let type = KLDepthPoint.TradingType.sell
                        let p = item.firstObject as? Double ?? 0
                        let a = item.lastObject as? Double ?? 0
                        let d = KLDepthPoint.init(p: p, t: type, a: a)
                        temp.append(d)
                    }
                }
            }
            
        
        }catch {
            print("12333  error")
        }
        return temp
      
    }()
    
    let settingsView: ChartSettingsView = {
        let view = Bundle.main.loadNibNamed("\(ChartSettingsView.self)", owner: nil, options: nil)?.last as! ChartSettingsView
        UIApplication.shared.keyWindow?.addSubview(view)
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        //---------------- ⭐️ Easy Use ----------------//

        // 👉 1. create KLineView by sections
        // 👉 sections can be modified after
        let candleSection = KLSection([Candle(), MA()], 300)
        
        klineView = KLineView([candleSection,
                               KLSection([MAVOL()], 74),
                               KLSection([MACD()], 74)])
        
        contentView.addSubview(klineView)
        contentHeight.constant = klineView.neededHeight
        
        // 👉 2. set data
        klineView.data = data
        klineView.moveToXMax() // if u append new data and want to scroll to the end of th chart


        // 👉 3. set x date formatter for first section
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormat.day.rawValue
        klineView.sections.first?.xValueFormatter = KLDateFormatter(formatter)


        // 👉 4. config tap marker
        let markView = MarkerView(frame: CGRect(x: 0, y: 0, width: 130, height: 173))
        candleSection.markView = markView
        klineView.highlightedChanged = { [weak self] (index) in
            if #available(iOS 10.0, *) {
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            }
            guard let strongSelf = self else {
                return
            }
            let dd = strongSelf.data[index]
            markView.updateValue(model: dd)
        }
        
        //---------------- ⭐️⭐️ Advanced ----------------//

        // 👉 [Advanced]: change settings of klineView
        ChartSettings.shared.changed(dependence: self) { (settings) in

            //---------------- 1. create main section ----------------//

            // 👉 append candle
            var mainIndicators = [KLIndicator]()
            mainIndicators.append(Candle())

            // 👉 append main indicators (MA/EMA/BOLL)
            let mains = settings.mainIndicators.filter{ $0.on }.map{ $0.indicator }
            mainIndicators.append(contentsOf: mains)

            // 👉 append limit lines to main section
            let lines = self.createLimitLines()
            mainIndicators.append(contentsOf: lines)

            // 👉 set indicators to main section
            let mainSection = self.klineView.sections.first!
            mainSection.indicators = mainIndicators
            mainSection.height = settings.mainHeight

            //---------------- 2. create other sections ----------------//
            let others = settings.otherIndicators.filter{ $0.on }.map{ $0.indicator }
            let othersSections = others.map{ KLSection([$0], 74) }


            //---------------- 3. set sections to klineView ----------------//
            var sections = [KLSection]()
            sections.append(mainSection)
            sections.append(contentsOf: othersSections)
            self.klineView.sections = sections


            // 👉 config contentView's height, which decided by each section's height
            // 👉 if u use frame instead of AutoLayout just set contentView.size.height = klineView.neededHeight
            self.contentHeight.constant = self.klineView.neededHeight

        }
        addDepthView()

    }

    
    
    func addDepthView() {
        view.addSubview(depthContenView)
        depthContenView.backgroundColor = .red
        depthKLineView = KLineView([KLSection([Depth()], 200)])
//        depthKLineView.legend.direction = .RightToLeft
        depthKLineView.frame = depthContenView.bounds
        depthKLineView.backgroundColor = .green
        depthContenView.addSubview(depthKLineView)
        depthKLineView.data = depthData
        
    }
    
    func createLimitLines() -> [LimitLine] {
        let pls = settingsView.settings.priceLines
        var lines = [LimitLine]()
        for i in 0..<pls.count {
            let pl = pls[i]
            if pl.enabled {
                let line = LimitLine(pl.value, .horizontal)
                line.label.text = pl.label + String(format: " %.2f", pl.value)
                line.style.lineColor1 = UIColor(kl_hex: pl.color)
                line.label.bgColor = line.style.lineColor1
                line.label.color = UIColor.black
                lines.append(line)
            }
        }
        return lines
//        return settingsView.settings.priceLines.filter { $0.enabled }.map { (pl) -> LimitLine in
//            let line = LimitLine(pl.value, .horizontal)
//            line.label.text = pl.label
//            line.style.lineColor1 = UIColor(kl_hex: pl.color)
//            line.label.bgColor = line.style.lineColor1
//            line.label.color = UIColor.black
//            return line
//        }
    }

    override func viewDidLayoutSubviews() {
        klineView.frame = contentView.bounds
    }

    @IBAction func settingsAction(_ sender: Any) {
        settingsView.show()
    }

}

