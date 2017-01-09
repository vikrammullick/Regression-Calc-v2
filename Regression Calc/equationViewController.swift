//
//  equationViewController.swift
//  Regression Calc
//
//  Created by Vikram Mullick on 1/8/17.
//  Copyright © 2017 Vikram Mullick. All rights reserved.
//

import UIKit

class equationViewController: UIViewController {
    
    var rsquaredText = String()
    
    var equationText = String()

    var valuesText = String()
    
    @IBOutlet weak var equationLabel: UILabel!
  
    @IBOutlet weak var valuesTextView: UITextView!
    
    @IBOutlet weak var rsquaredLabel: UILabel!
    
    override func viewDidLoad()
    {
        
    }
    override func viewDidAppear(_ animated: Bool)
    {
        
        rsquaredLabel.adjustsFontSizeToFitWidth = true
        rsquaredLabel.text = exponentize(str: "r^2: ") + self.rsquaredText
        
        equationLabel.adjustsFontSizeToFitWidth = true
        equationLabel.text = "y=" + self.equationText
        
        valuesTextView.text = self.valuesText

    }
    
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: false, completion: {})
    }
    
        
    func exponentize(str: String) -> String
    {
        
        let supers = [
            "1": "\u{00B9}",
            "2": "\u{00B2}",
            "3": "\u{00B3}",
            "4": "\u{2074}",
            "5": "\u{2075}",
            "6": "\u{2076}",
            "7": "\u{2077}",
            "8": "\u{2078}",
            "9": "\u{2079}"]
        
        var newStr = ""
        var isExp = false
        for (_, char) in str.characters.enumerated() {
            if char == "^" {
                isExp = true
            } else {
                if isExp {
                    let key = String(char)
                    if supers.keys.contains(key) {
                        newStr.append(Character(supers[key]!))
                    } else {
                        isExp = false
                        newStr.append(char)
                    }
                } else {
                    newStr.append(char)
                }
            }
        }
        return newStr
    }
    
}
