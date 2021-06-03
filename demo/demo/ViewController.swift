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

    let klineView = KLineView(types: [[.candle, .ma],
                                      [.mavol],
                                      [.macd]])

    override func viewDidLoad() {
        super.viewDidLoad()

        contentView.addSubview(klineView)
        klineView.frame = contentView.bounds

        

    }

    @IBAction func action(_ sender: Any) {
        present(CombinedChartViewController(), animated: true, completion: nil)
    }

}

