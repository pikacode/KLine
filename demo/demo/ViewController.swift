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

    lazy var klineView = KLineView(sections: [section1,
                                              section2,
                                              section3])

    var section1 = KLSection([Candle.self, MA.self], 280)
    var section2 = KLSection([MA.self], 74)
    var section3 = KLSection([MA.self], 74)

    override func viewDidLoad() {
        super.viewDidLoad()

        contentView.addSubview(klineView)
        klineView.frame = contentView.bounds


    }

    @IBAction func action(_ sender: Any) {
        present(CombinedChartViewController(), animated: true, completion: nil)
    }

}

