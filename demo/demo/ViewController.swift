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

    override func viewDidLoad() {
        super.viewDidLoad()

        contentView.addSubview(klineView)
        klineView.frame = contentView.bounds
        

    }

    @IBAction func action(_ sender: Any) {
        present(CombinedChartViewController(), animated: true, completion: nil)
    }

}

