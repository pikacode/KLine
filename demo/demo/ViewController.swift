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

    // 👉 config each section by (elements, height), sections can be modified after
    var section1 = KLSection([Candle(), MA()], 300)
    var section2 = KLSection([MA()], 74)
    var section3 = KLSection([KDJ()], 74)

    lazy var klineView = KLineView([section1,
                                    section2,
                                    section3])

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

        contentView.addSubview(klineView)

        // 👉 set data
        klineView.data = data

        // 👉 set x date formatter
        KLDateFormatter.format = DateFormat.day.rawValue
        section1.xAxis.valueFormatter = KLDateFormatter()

        // 👉 set a limit line
        let line = LimitLine(300, .horizontal)
        section1.indicators.append(line)
        line.label.text = "pikacode"
        line.label.color = UIColor.white
        line.label.bgColor = line.style.lineColor1


        /* 👉 set data with a completion block
           👉 u can use this to handle a loading status while calculating data

         // data is [KLineData]
         klineView.setData(data) {
            //finish
         }

         // data is [Any]
         klineView.setCustomData(data) {
            //finish
         }

         */


        ChartSettings.shared.changed = { (settings) in

            self.section1.height = settings.mainHeight

            // 👉 config klinView's height, which decided by each section's height
            // 👉 if u use frame instead of AutoLayout just set contentView.size.height = klineView.neededHeight
            self.contentHeight.constant = self.klineView.neededHeight

            // 👉 tell kline to redraw
            self.klineView.draw()
        }

    }

    override func viewDidLayoutSubviews() {
        klineView.frame = contentView.bounds
    }

    @IBAction func settingsAction(_ sender: Any) {
        settingsView.show()
    }

}

