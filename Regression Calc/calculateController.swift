//
//  calculateController.swift
//  Regression Calc
//
//  Created by Vikram Mullick on 1/8/17.
//  Copyright © 2017 Vikram Mullick. All rights reserved.
//

import UIKit

class calculateController: UIViewController {
   
    var mainCont : ViewController = ViewController()
   
    var numUniqueX = 0
    var xNonPositive = false
    var yNonPositive = false
    
    @IBOutlet weak var lin: UIButton!
    @IBOutlet weak var quad: UIButton!
    @IBOutlet weak var cub: UIButton!
    @IBOutlet weak var quar: UIButton!
    @IBOutlet weak var quin: UIButton!
    @IBOutlet weak var expon: UIButton!
    @IBOutlet weak var log: UIButton!
    @IBOutlet weak var pow: UIButton!
    
    @IBOutlet weak var poly: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        
        switch (numUniqueX){
        case _ where numUniqueX == 0 || numUniqueX == 1:
            self.lin.isEnabled = false
            self.quad.isEnabled = false
            self.cub.isEnabled = false
            self.quar.isEnabled = false
            self.quin.isEnabled = false
            self.expon.isEnabled = false
            self.log.isEnabled = false
            self.pow.isEnabled = false
            self.poly.isEnabled = false
        case _ where numUniqueX == 2:
            self.quad.isEnabled = false
            self.cub.isEnabled = false
            self.quar.isEnabled = false
            self.quin.isEnabled = false
            self.poly.isEnabled = false
        case _ where numUniqueX == 3:
            self.cub.isEnabled = false
            self.quar.isEnabled = false
            self.quin.isEnabled = false
            self.poly.isEnabled = false
        case _ where numUniqueX == 4:
            self.quar.isEnabled = false
            self.quin.isEnabled = false
            self.poly.isEnabled = false
        case _ where numUniqueX == 5:
            self.quin.isEnabled = false
            self.poly.isEnabled = false
        case _ where numUniqueX == 6:
            self.poly.isEnabled = false
        default: break}
        
        if xNonPositive
        {
            self.pow.isEnabled = false
            self.log.isEnabled = false
        }
        if yNonPositive
        {
            self.pow.isEnabled = false
            self.expon.isEnabled = false
        }

    }
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: false, completion: {})
    }
        
    @IBAction func linear(_ sender: Any) {
        self.dismiss(animated: true, completion: {})
        mainCont.polynomial(exponent: 1)
        mainCont.drawGridandAxis()
    }
    @IBAction func quadratic(_ sender: Any) {
        self.dismiss(animated: true, completion: {})
        mainCont.polynomial(exponent: 2)
        mainCont.drawGridandAxis()

    }
    @IBAction func cubic(_ sender: Any) {
        self.dismiss(animated: true, completion: {})
        mainCont.polynomial(exponent: 3)
        mainCont.drawGridandAxis()

    }
    @IBAction func quartic(_ sender: Any) {
        self.dismiss(animated: true, completion: {})
        mainCont.polynomial(exponent: 4)
        mainCont.drawGridandAxis()

    }
    @IBAction func quintic(_ sender: Any) {
        self.dismiss(animated: true, completion: {})
        mainCont.polynomial(exponent: 5)
        mainCont.drawGridandAxis()

    }
    @IBAction func exponential(_ sender: Any) {
        self.dismiss(animated: true, completion: {})
        mainCont.exponential()
        mainCont.drawGridandAxis()

    }
    @IBAction func logarithmic(_ sender: Any) {
        self.dismiss(animated: true, completion: {})
        mainCont.logarithmic()
        mainCont.drawGridandAxis()

    }
    @IBAction func power(_ sender: Any) {
        self.dismiss(animated: true, completion: {})
        mainCont.power()
        mainCont.drawGridandAxis()

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination : polynomialRegressionViewController = segue.destination as? polynomialRegressionViewController
        {
            destination.numUniqueX = self.numUniqueX
            destination.mainCont = self.mainCont
            destination.calcCont = self
        }
    }

    
}
