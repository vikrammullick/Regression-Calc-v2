//
//  polynomialRegressionViewController.swift
//  Regression Calc
//
//  Created by Vikram Mullick on 1/10/17.
//  Copyright © 2017 Vikram Mullick. All rights reserved.
//

import UIKit

class polynomialRegressionViewController: UIViewController {
    var power = 6
    @IBOutlet weak var powerLabel: UILabel!
    @IBOutlet weak var polyLabel: UILabel!
    var mainCont : ViewController = ViewController()
    var calcCont : calculateController = calculateController()
    var numUniqueX = 0

    @IBOutlet weak var plus: UIButton!
    @IBOutlet weak var minus: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        polyLabel.adjustsFontSizeToFitWidth = true
        powerLabel.adjustsFontSizeToFitWidth = true

        polyLabel.text = "enter power between 6 and \(numUniqueX-1)"
        
        plus.backgroundColor = .clear
        plus.layer.cornerRadius = plus.layer.frame.size.height/2
        plus.layer.borderWidth = 1
        plus.layer.borderColor = plus.currentTitleColor.cgColor
        
        minus.backgroundColor = .clear
        minus.layer.cornerRadius = plus.layer.frame.size.height/2
        minus.layer.borderWidth = 1
        minus.layer.borderColor = plus.currentTitleColor.cgColor

        plus.titleLabel?.textAlignment = NSTextAlignment.center
        
        checkEnabled()
        
        
    }
    @IBAction func add(_ sender: Any) {
        power += 1
        powerLabel.text = "\(power)"
        checkEnabled()
    }
    @IBAction func subtract(_ sender: Any) {
        power -= 1
        powerLabel.text = "\(power)"
        checkEnabled()
    }
    func checkEnabled()
    {
        if power == 6
        {
            minus.isEnabled = false
        }
        else
        {
            minus.isEnabled = true
        }
        if power == numUniqueX-1
        {
            plus.isEnabled = false
        }
        else
        {
            plus.isEnabled = true
        }
    }
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: false, completion: {})
    }
    @IBAction func calculate(_ sender: Any) {
        
        self.dismiss(animated: false, completion: {})
        calcCont.dismiss(animated: false, completion: {})
        mainCont.polynomial(exponent: power)
        mainCont.drawGridandAxis(showAnimation: true)


    }
    
    
}
