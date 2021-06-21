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

    var section1 = KLSection([Candle.self, MA.self], 300)
    var section2 = KLSection([MA.self], 74)
    var section3 = KLSection([KDJ.self], 74)

    lazy var klineView = KLineView([section1,
                                    section2,
                                    section3])

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

    override func viewDidLoad() {
        super.viewDidLoad()

        contentView.addSubview(klineView)

        klineView.data = data

        KLDateFormatter.format = DateFormat.day.rawValue
        section1.xAxis.valueFormatter = KLDateFormatter()

        /* set data with a completion block

         // data is [KLineData]
         klineView.setData(data) {
            //finish
         }

         // data is [Any]
         klineView.setCustomData(data) {
            //finish
         }

         */

    }

    override func viewDidLayoutSubviews() {
        klineView.frame = contentView.bounds
        contentHeight.constant = klineView.needHeight
    }

    @IBAction func test(_ sender: Any) {
        // klineView.sections.first?.chartView

    }

    @IBAction func action(_ sender: Any) {
        present(CombinedChartViewController(), animated: true, completion: nil)
    }

}

