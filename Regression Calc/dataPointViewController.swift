//
//  dataPointViewController.swift
//  Regression Calc
//
//  Created by Vikram Mullick on 1/6/17.
//  Copyright © 2017 Vikram Mullick. All rights reserved.
//

import UIKit

class dataPointViewController: UIViewController, UITextFieldDelegate {
    
    var mainCont : ViewController = ViewController()
    var xs: [Double] = []
    var ys: [Double] = []
    
    var activeTextField : UITextField?

    @IBOutlet weak var er: UIImageView!
    @IBOutlet weak var xyStackView: UIStackView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var baseView: UIView!
    var xFields: [UITextField] = []
    var yFields: [UITextField] = []
    var delButtons: [delButton] = []
    var scrollViewWidth : CGFloat = CGFloat()
    var scrollViewWidthFull : CGFloat = CGFloat()
    let cellHeight = 40
    let deleteDiameter = 34
    let addButton : UIButton = UIButton(type: .custom)
    let numInitial = 3
    override func viewDidLoad() {
        super.viewDidLoad()
        baseView.layer.borderWidth = 0.5;
        baseView.layer.borderColor = UIColor.black.cgColor
        scrollView.layer.borderWidth = 0.5;
        scrollView.layer.borderColor = UIColor.black.cgColor
        er.isHidden = true
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dataPointViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        

 
    }
    func dismissKeyboard() {
        view.endEditing(true)
    }
  
    override func viewDidAppear(_ animated: Bool) {
        self.scrollViewWidth = self.xyStackView.frame.width
        self.scrollViewWidthFull = self.scrollView.frame.width
        
        for _ in 0..<numInitial
        {
            self.newPoint()
        }
        for i in 0..<xs.count
        {
            xFields[i].text = String(xs[i])
            yFields[i].text = String(ys[i])
            if(i>=numInitial-1)
            {
                self.newPoint()
            }

        }
        self.createAddButton()
    }
    func createAddButton()
    {
  
        //self.addButton.setImage(UIImage(named: "plus")!, for: .normal)
        self.addButton.setTitle("Add Point", for: .normal)
        self.addButton.titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: UIFontWeightThin)

        self.addButton.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        self.addButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
        addButton.frame = CGRect(x: Int(scrollViewWidth/2-self.scrollViewWidth/4), y: 5+(cellHeight+5)*xFields.count, width: Int(self.scrollViewWidth/2), height: cellHeight)
        addButton.clipsToBounds =  true
        //addButton.layer.cornerRadius = CGFloat(cellHeight/2)
        addButton.layer.backgroundColor=UIColor(red: 0.0, green: 0.5, blue: 1, alpha: 0.5).cgColor
        //addButton.layer.borderColor=UIColor.white.cgColor
        addButton.layer.borderWidth=1.0
        self.scrollView.addSubview(addButton)
        
        addButton.addTarget(self, action: #selector(add), for: .touchUpInside)

    }
    @IBAction func doneButton(_ sender: Any)
    {
        var isDone = true
        for i in 0..<delButtons.count
        {
            let txtX = xFields[i].text!
            let txtY = yFields[i].text!

            if(txtY != "" || txtX != "")
            {
                let xNum = Double(txtX)
                let yNum = Double(txtY)
                if(xNum == nil)
                {
                    xFields[i].backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.5)
                    er.isHidden = false
                    isDone = false
                }
                else
                {
                    xFields[i].backgroundColor = UIColor.white
                }
                if(yNum == nil)
                {
                    yFields[i].backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.5)
                    er.isHidden = false
                    isDone = false
                }
                else
                {
                    yFields[i].backgroundColor = UIColor.white
                }
            }
        }
        if isDone
        {
            var numUniqueX = 0
            self.mainCont.maxDouble = 0
            self.xs.removeAll()
            self.ys.removeAll()
            mainCont.xNonPositive = false
            mainCont.yNonPositive = false
            for i in 0..<xFields.count
            {
                if let x = Double(xFields[i].text!)
                {
                    if let y = Double(yFields[i].text!)
                    {
                        if(!xs.contains(x))
                        {
                            numUniqueX+=1
                        }
                        self.xs.append(x)
                        self.ys.append(y)
                        if(abs(x) > self.mainCont.maxDouble)
                        {
                            self.mainCont.maxDouble = abs(x)
                        }
                        if(abs(y) > self.mainCont.maxDouble)
                        {
                            self.mainCont.maxDouble = abs(y)
                        }
                        if(x<=0)
                        {
                            mainCont.xNonPositive = true
                        }
                        if(y<=0)
                        {
                            mainCont.yNonPositive = true
                        }

                    }
                }
            }
            mainCont.xs = self.xs
            mainCont.ys = self.ys
            mainCont.numUniqueX = numUniqueX
            var interval : Double = 0
            
            if(self.mainCont.maxDouble <= 10)
            {
                interval = 1
            }
            else
            {
                if(11 <= self.mainCont.maxDouble && self.mainCont.maxDouble <= 30)
                {
                    interval = 3
                }
                else
                {
                    if(31 <= self.mainCont.maxDouble && self.mainCont.maxDouble <= 50)
                    {
                        interval = 5
                    }
                    else
                    {
                        var temp : Double = 50
                        while((2*temp)<self.mainCont.maxDouble)
                        {
                            temp*=2
                        }
                        interval = 2*temp/10
                    }
                }
            }
            self.mainCont.interval = interval
            self.mainCont.intervalLabel.text = "graph square interval: \(interval)"
            
            var numLines : Double = 0
            while(numLines*interval < self.mainCont.maxDouble)
            {
                numLines+=1
            }
            if numLines == 0
            {
                numLines = 1
            }
            
            self.mainCont.gridLen = numLines*interval
            self.mainCont.currentGrid = CGFloat(numLines*2+2)
            self.mainCont.drawGridandAxis()

            
        
            self.dismiss(animated: false, completion: {});
        }
    }
    func add(sender:UIButton!)
    {
        newPoint()
        if scrollView.contentSize.height - scrollView.bounds.size.height > 0
        {
            let bottomOffset = CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.bounds.size.height)
            scrollView.setContentOffset(bottomOffset, animated: true)
        }
    }
    func del(sender:delButton!)
    {
        let ind = sender.index
        delButtons.remove(at:ind).removeFromSuperview()
        xFields.remove(at:ind).removeFromSuperview()
        yFields.remove(at:ind).removeFromSuperview()
     
        for i in ind..<delButtons.count {
            delButtons[i].index = i
            UIView.animate(withDuration: 0.05, delay: 0.15, options: .curveEaseOut, animations: {
                
                self.xFields[i].frame = CGRect(x: self.xFields[i].frame.origin.x, y: self.xFields[i].frame.origin.y-CGFloat(self.cellHeight)-5, width: self.xFields[i].frame.width, height: self.xFields[i].frame.height)
                self.yFields[i].frame = CGRect(x: self.yFields[i].frame.origin.x, y: self.yFields[i].frame.origin.y-CGFloat(self.cellHeight)-5, width: self.yFields[i].frame.width, height: self.yFields[i].frame.height)
                self.delButtons[i].frame = CGRect(x: self.delButtons[i].frame.origin.x, y: self.delButtons[i].frame.origin.y-CGFloat(self.cellHeight)-5, width: self.delButtons[i].frame.width, height: self.delButtons[i].frame.height)
                
            }, completion: { finished in})
            
        }
        UIView.animate(withDuration: 0.05, delay: 0.15, options: .curveEaseOut, animations: {

            self.addButton.frame = CGRect(x: self.addButton.frame.origin.x, y: self.addButton.frame.origin.y-CGFloat(self.cellHeight)-5, width: self.addButton.frame.width, height: self.addButton.frame.height)
            
        }, completion: { finished in
            
            UIView.animate(withDuration: 0.05, delay: 0.15, options: .curveEaseOut, animations: {

                self.scrollView.contentSize = CGSize(width: self.scrollViewWidth, height: CGFloat(5+(self.cellHeight+5)*(self.xFields.count+1)))
            }, completion: { finished in })


        })


        
    }
    func newPoint()
    {
        let x = UITextField()
        x.frame = CGRect(x: 5, y: 5+(cellHeight+5)*xFields.count, width: Int(scrollViewWidth/2-10), height: cellHeight)
        x.placeholder = "x"
        setStyle(field: x)
        
        let y = UITextField()
        y.frame = CGRect(x: Int(5+scrollViewWidth/2), y: 5+(cellHeight+5)*xFields.count, width: Int(scrollViewWidth/2-10), height: cellHeight)
        y.placeholder = "y"
        setStyle(field: y)
        
        let delBut : delButton = delButton(type: .custom)
        delBut.index = xFields.count
        delBut.frame = CGRect(x: Int(scrollViewWidthFull)-deleteDiameter*5/8-Int(scrollViewWidthFull-scrollViewWidth)/2, y: (cellHeight-deleteDiameter)/2+5+(cellHeight+5)*xFields.count, width: deleteDiameter, height: deleteDiameter)
        setStyle(button: delBut)
        
        
        delButtons.append(delBut)
        xFields.append(x)
        yFields.append(y)
        
        self.scrollView.contentSize = CGSize(width: scrollViewWidth, height: CGFloat(5+(cellHeight+5)*(xFields.count+1)))
        addButton.frame = CGRect(x: Int(scrollViewWidth/2-self.scrollViewWidth/4), y: 5+(cellHeight+5)*xFields.count, width: Int(self.scrollViewWidth/2), height: cellHeight)



    }
   
    func setStyle(field : UITextField)
    {
        field.font = UIFont.systemFont(ofSize: 15)
        field.textColor = UIColor.black
        field.borderStyle = UITextBorderStyle.line
        field.autocorrectionType = UITextAutocorrectionType.no
        field.keyboardType = UIKeyboardType.default
        field.returnKeyType = UIReturnKeyType.done
        field.clearButtonMode = UITextFieldViewMode.whileEditing;
        field.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        field.backgroundColor = UIColor.white
        if let objects = Bundle.main.loadNibNamed("numberBoard", owner: self, options: nil) {
            field.inputView = objects[0] as? UIView
        }
        field.delegate = self
        self.scrollView.addSubview(field)
    }
    func setStyle(button : delButton)
    {
        button.setImage(UIImage(named: "xxx")!, for: .normal)
        button.contentMode = .scaleAspectFit
        button.clipsToBounds =  true
        button.layer.cornerRadius = CGFloat(deleteDiameter/2)
        button.layer.backgroundColor=UIColor.clear.cgColor
        button.layer.borderWidth=0.0
        button.addTarget(self, action: #selector(del), for: .touchUpInside)
        self.scrollView.addSubview(button)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: false, completion: {})
    }
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        activeTextField = textField
    }
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        activeTextField = nil
    }
    @IBAction func one(_ sender: Any) {
        self.activeTextField?.text = (self.activeTextField?.text)! + "1"
    }
    @IBAction func two(_ sender: Any) {
        self.activeTextField?.text = (self.activeTextField?.text)! + "2"
    }
    @IBAction func three(_ sender: Any) {
        self.activeTextField?.text = (self.activeTextField?.text)! + "3"
    }
    @IBAction func four(_ sender: Any) {
        self.activeTextField?.text = (self.activeTextField?.text)! + "4"
    }
    @IBAction func five(_ sender: Any) {
        self.activeTextField?.text = (self.activeTextField?.text)! + "5"
    }
    @IBAction func six(_ sender: Any) {
        self.activeTextField?.text = (self.activeTextField?.text)! + "6"
    }
    @IBAction func seven(_ sender: Any) {
        self.activeTextField?.text = (self.activeTextField?.text)! + "7"
    }
    @IBAction func eight(_ sender: Any) {
        self.activeTextField?.text = (self.activeTextField?.text)! + "8"
    }
    @IBAction func nine(_ sender: Any) {
        self.activeTextField?.text = (self.activeTextField?.text)! + "9"
    }
    @IBAction func zero(_ sender: Any) {
        self.activeTextField?.text = (self.activeTextField?.text)! + "0"
    }
    @IBAction func decimal(_ sender: Any) {
        self.activeTextField?.text = (self.activeTextField?.text)! + "."
    }
    @IBAction func negative(_ sender: Any) {
        self.activeTextField?.text = (self.activeTextField?.text)! + "-"
    }
    @IBAction func delet(_ sender: Any) {

        let currentText = (self.activeTextField?.text)!
        if !currentText.isEmpty
        {
            let fin = currentText.characters.count-1
            let index = currentText.index(currentText.startIndex, offsetBy: fin)
            self.activeTextField?.text = currentText.substring(to: index)
        }


    }
    

    
    
}
