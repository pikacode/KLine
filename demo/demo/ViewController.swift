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
        klineView = KLineView([KLSection([Candle(), MA()], 300),
                               KLSection([MAVOL()], 74),
                               KLSection([MACD()], 74)])

        contentView.addSubview(klineView)

        // 👉 2. set data
        klineView.data = data

        // 👉 3. set x date formatter for first section
        KLDateFormatter.format = DateFormat.day.rawValue
        klineView.sections.first?.xAxis.valueFormatter = KLDateFormatter()





        //---------------- ⭐️⭐️ Advanced ----------------//

        // 👉 [Advanced]: change settings of klineView
        ChartSettings.shared.changed = { (settings) in

            //---------------- 1. create main section ----------------//

            // 👉 append candle
            var mainIndicators = [KLIndicator]()
            mainIndicators.append(Candle())

            // 👉 append main indicators (MA/EMA/BOLL)
            let mains = settings.mainIndicators.filter{ $0.on }.map{ $0.indicator }
            mainIndicators.append(contentsOf: mains)

            // 👉 append a limit line
            let line: LimitLine = {
                let line = LimitLine(300, .horizontal)
                line.label.text = "pikacode"
                line.label.color = UIColor.white
                line.label.bgColor = line.style.lineColor1
                return line
            }()
            mainIndicators.append(line)

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

    }

    override func viewDidLayoutSubviews() {
        klineView.frame = contentView.bounds
    }

    @IBAction func settingsAction(_ sender: Any) {
        settingsView.show()
    }

}

