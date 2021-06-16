//
//  ViewController.swift
//  demo
//
//  Created by pikacode on 2021/6/1.
//

import UIKit
import KLine

class ViewController: UIViewController {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentHeight: NSLayoutConstraint!

    lazy var klineView = KLineView([KLSection([Candle.self, MA.self], 300),
                                    KLSection([MA.self], 74),
                                    KLSection([MA.self], 74)])

    let data: [KLineData] = {
        let start: TimeInterval = 1623749243
        let count = 10
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
                       Double.random(in: (o*0.95)...(o*1.05)),
                       Double.random(in: (o*0.95)...(o*1.05)),
                       Double.random(in: (o*0.95)...(o*1.05))].sorted()
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

    }

    override func viewDidLayoutSubviews() {
        klineView.frame = contentView.bounds
        contentHeight.constant = klineView.needHeight
    }

    @IBAction func test(_ sender: Any) {
        
    }

    @IBAction func action(_ sender: Any) {
        present(CombinedChartViewController(), animated: true, completion: nil)
    }

}

