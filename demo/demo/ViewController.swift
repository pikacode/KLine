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

    lazy var klineView = KLineView([[Candle.self, MA.self],
                                    [MA.self],
                                    [MA.self]])

    let data: [KLineData] = {
        let start: TimeInterval = 1623749243
        let count = 30
        var temp = [KLineData]()
        for i in 0..<count {
            let v = Double.random(in: 500000...3000000)
            let t = start + TimeInterval(i * 60 * 60 * 24)
            let base0: Double
            let base1: Double
            let o: Double
            if i > 0 {
                o = temp[i-1].close
                base0 = o - 20
                base1 = o + 20
            } else {
                base0 = 380
                base1 = 420
                o = Double.random(in: base0...base1)
            }
            let c = Double.random(in: base0...base1)
            let h = Double.random(in: (base0 + 20)...(base1 + 20))
            let l = Double.random(in: (base0 - 20)...(base1 - 20))
            let d = KLineData(o: o, c: c, h: h, l: l, v: v, t: t)
            temp.append(d)
        }
        return temp
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        contentView.addSubview(klineView)
        klineView.frame = contentView.bounds

        klineView.data = data


    }

    @IBAction func action(_ sender: Any) {
        present(CombinedChartViewController(), animated: true, completion: nil)
    }

}

