//
//  ViewController.swift
//  Regression Calc
//
//  Created by Vikram Mullick on 1/5/17.
//  Copyright © 2017 Vikram Mullick. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var graphLayer = CAShapeLayer()
    
    var centerX : CGFloat = 0
    var centerY : CGFloat = 0
    
    @IBOutlet weak var intervalLabel: UILabel!
    var regressionType = String()
    var ansMatrix = Matrix(rows: 0, columns: 0)
    var interval : Double = Double()
    var numUniqueX = 0
    var equationText = ""
    var rsquaredText = ""
    @IBOutlet weak var rsqrd: UILabel!
    var xs: [Double] = []
    var ys: [Double] = []
    var xNonPositive = false
    var yNonPositive = false
    var gridLen : Double = 0
    var maxDouble : Double = 0
    var currentGrid: CGFloat = 22
    @IBOutlet weak var calculateButton: UIButton!
    @IBOutlet weak var eqnButton: UIButton!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var tableButton: UIButton!
    var lines: [CAShapeLayer] = []
    var points: [CAShapeLayer] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        

        drawGridandAxis()
        buttonText()

        
       
      

    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    func buttonText()
    {
        eqnButton.titleLabel?.adjustsFontSizeToFitWidth = true
        rsqrd.adjustsFontSizeToFitWidth = true
        updateEqn()
        updateR2()
    }
    func updateEqn()
    {
        eqnButton.setTitle("  y = \(equationText)", for: .normal)
    }
    func updateR2()
    {
        rsqrd.text = exponentize(str: "r^2: \(rsquaredText)")
    }
    @IBAction func tableButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "segue", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination : dataPointViewController = segue.destination as? dataPointViewController
        {
            destination.xs = self.xs
            destination.ys = self.ys
            destination.mainCont = self
        }
        if let destination : calculateController = segue.destination as? calculateController
        {
            destination.mainCont = self
            destination.xNonPositive = self.xNonPositive
            destination.yNonPositive = self.yNonPositive
            destination.numUniqueX = self.numUniqueX
        }
        if let destination : equationViewController = segue.destination as? equationViewController
        {
            let startingValue = Int(("a" as UnicodeScalar).value)
            
            destination.rsquaredText = self.rsquaredText
            for i in 0..<self.ansMatrix.rows
            {
                destination.valuesText += String(Character(UnicodeScalar(startingValue+i)!)) + " = \(round(10000000000.0 * ansMatrix[i,0]) / 10000000000.0)\n"
            }
            
            switch (regressionType){
            case _ where regressionType == "polynomial":
                destination.equationText = "a+bx"
                for i in 2..<self.ansMatrix.rows
                {
                    destination.equationText += "+"+String(Character(UnicodeScalar(startingValue+i)!))+exponentize(str: "x^\(i)")
                }
            case _ where regressionType == "exponential":
                destination.equationText = "a*b^x"
            case _ where regressionType == "logarithmic":
                destination.equationText = "a+b*log(x)"
            case _ where regressionType == "power":
                destination.equationText = "a*x^b"
            default:
                break
            }
           
        }
    }
    func polynomial(exponent : Int)
    {

        var A = Matrix(rows: self.xs.count, columns: exponent+1)
        var b = Matrix(rows: self.xs.count, columns: 1)
        
        for i in 0..<self.xs.count
        {
            b[i,0]=ys[i]
            for i in 0..<self.xs.count
            {
                for k in 0...exponent
                {
                    A[i,k]=pow(xs[i],Double(k))
                }
            }
            
        }
        
        let ans = multMat(mat1: invertMat(mat: multMat(mat1: transposeMat(mat: A), mat2: A)), mat2: multMat(mat1: transposeMat(mat: A), mat2: b))
        
        self.equationText = ""
        var isFirst = true
        for i in 0...exponent
        {
            let next = round(100.0 * ans[i,0]) / 100.0
            let nextString = String(format: "%.02f", next)
            if next != 0
            {
                var xponString = String()
                if i == 0
                {
                    xponString = ""
                }
                if i == 1
                {
                    xponString = "x"
                }
                if i > 1
                {
                    xponString = exponentize(str:"x^\(i)")
                }
                if(isFirst)
                {
                    self.equationText+="\(nextString)\(xponString)"
                    isFirst = false
                }
                else
                {
                    if(next>0)
                    {
                        self.equationText+="+\(nextString)\(xponString)"
                    }
                    else
                    {
                        self.equationText+="\(nextString)\(xponString)"
                    }
                }
                
            }
        }
        updateEqn()
        regressionType = "polynomial"
        ansMatrix = ans
        
        var yhat : Double = 0
        for temp in 0..<self.ys.count
        {
            yhat += ys[temp]
        }
        yhat/=Double(self.ys.count)
        
        var yvariance : Double = 0
        for temp in 0..<self.ys.count
        {
            yvariance+=pow((ys[temp]-yhat),2)
        }
        
        var top : Double = 0
        for temp in 0..<self.ys.count
        {
            var yval : Double = 0
            for i in 0..<ans.rows
            {
                yval += ans[i,0]*pow(xs[temp],Double(i))
            }
            top+=pow((ys[temp]-yval),2)
        }
        
        let rsqrd : Double = 1-top/yvariance
        self.rsquaredText = String(format: "%.06f", rsqrd)
        updateR2()
        
    }
    func exponential()
    {
        var A = Matrix(rows: self.xs.count, columns: 2)
        var b = Matrix(rows: self.xs.count, columns: 1)
        
        for i in 0..<self.xs.count
        {
            b[i,0]=log(ys[i])
            for i in 0..<self.xs.count
            {
                for k in 0...1
                {
                    A[i,k]=pow(xs[i],Double(k))
                }
            }
            
        }
        
        var ans = multMat(mat1: invertMat(mat: multMat(mat1: transposeMat(mat: A), mat2: A)), mat2: multMat(mat1: transposeMat(mat: A), mat2: b))
        ans[0,0] = pow(M_E,ans[0,0])
        ans[1,0] = pow(M_E,ans[1,0])
        self.equationText = ""
        
        let next1 = round(100.0 * ans[0,0]) / 100.0
        let nextString1 = String(format: "%.02f", next1)
        let next2 = round(100.0 * ans[1,0]) / 100.0
        let nextString2 = String(format: "%.02f", next2)
        
        if(next1 != 1)
        {
            self.equationText+=nextString1+"*"
        }
        if(next2 != 1)
        {
            self.equationText+="\(nextString2)^x"
        }
        else
        {
            self.equationText=nextString1
        }
        if (equationText.characters.count == 0)
        {
            self.equationText = "1.00"
        }
        updateEqn()
        regressionType = "exponential"
        ansMatrix = ans

        
        var yhat : Double = 0
        for temp in 0..<self.ys.count
        {
            yhat += log(ys[temp])
        }
        yhat/=Double(self.ys.count)
        
        var yvariance : Double = 0
        for temp in 0..<self.ys.count
        {
            yvariance+=pow((log(ys[temp])-yhat),2)
        }
        
        var top : Double = 0
        for temp in 0..<self.ys.count
        {
            let yval : Double = log(ans[0,0])+log(ans[1,0])*xs[temp]
            top+=pow((log(ys[temp])-yval),2)
        }
        
        let rsqrd : Double = 1-top/yvariance
        
        self.rsquaredText = String(format: "%.06f", rsqrd)
        updateR2()
        
     

    }
    func logarithmic()
    {
        var A = Matrix(rows: self.xs.count, columns: 2)
        var b = Matrix(rows: self.xs.count, columns: 1)
        
        for i in 0..<self.xs.count
        {
            b[i,0]=ys[i]
            for i in 0..<self.xs.count
            {
                for k in 0...1
                {
                    A[i,k]=pow(log(xs[i]),Double(k))
                }
            }
            
        }
        
        var ans = multMat(mat1: invertMat(mat: multMat(mat1: transposeMat(mat: A), mat2: A)), mat2: multMat(mat1: transposeMat(mat: A), mat2: b))
        
        self.equationText = ""
        
        let next1 = round(100.0 * ans[0,0]) / 100.0
        let nextString1 = String(format: "%.02f", next1)
        let next2 = round(100.0 * ans[1,0]) / 100.0
        let nextString2 = String(format: "%.02f", next2)
        
        if(next1 != 0)
        {
            equationText += nextString1
        }
        if(next2 != 0)
        {
        
            if(next2 == 1)
            {
                if(equationText.characters.count != 0)
                {
                    equationText += "+"
                }
                equationText += "log(x)"
            }
            else
            {
                if(next2 < 0)
                {
                    equationText += nextString2 + "*log(x)"
                }
                else
                {
                    if(equationText.characters.count != 0)
                    {
                        equationText += "+"
                    }
                    equationText += nextString2 + "*log(x)"
                }
            }
        }
        updateEqn()
        regressionType = "logarithmic"
        ansMatrix = ans

        var yhat : Double = 0
        for temp in 0..<self.ys.count
        {
            yhat += ys[temp]
        }
        yhat/=Double(self.ys.count)
        
        var yvariance : Double = 0
        for temp in 0..<self.ys.count
        {
            yvariance+=pow((ys[temp]-yhat),2)
        }
        
        var top : Double = 0
        for temp in 0..<self.ys.count
        {
            let yval : Double = ans[0,0]+ans[1,0]*log(xs[temp])
            top+=pow((ys[temp]-yval),2)
        }
        
        let rsqrd : Double = 1-top/yvariance
        
        self.rsquaredText = String(format: "%.06f", rsqrd)
        updateR2()
       
    }
    func power()
    {
        var A = Matrix(rows: self.xs.count, columns: 2)
        var b = Matrix(rows: self.xs.count, columns: 1)
        
        for i in 0..<self.xs.count
        {
            b[i,0]=log(ys[i])
            for i in 0..<self.xs.count
            {
                for k in 0...1
                {
                    A[i,k]=pow(log(xs[i]),Double(k))
                }
            }
            
        }
        
        var ans = multMat(mat1: invertMat(mat: multMat(mat1: transposeMat(mat: A), mat2: A)), mat2: multMat(mat1: transposeMat(mat: A), mat2: b))
        ans[0,0] = pow(M_E,ans[0,0])
        self.equationText = ""
        
        let next1 = round(100.0 * ans[0,0]) / 100.0
        let nextString1 = String(format: "%.02f", next1)
        let next2 = round(100.0 * ans[1,0]) / 100.0
        let nextString2 = String(format: "%.02f", next2)
        
        if(next1 != 1)
        {
            self.equationText+=nextString1+"*"
        }
        if(next2 != 1 && next2 != 0)
        {
            self.equationText+="x^\(nextString2)"
        }
        else
        {
            if(next2 == 0 && next1 == 1)
            {
                self.equationText = "1.00"
            }
            if(next2 == 0 && next1 != 1)
            {
                self.equationText = nextString1
            }
            if(next2 == 1)
            {
                self.equationText+="x"
            }
        }
        updateEqn()
        regressionType = "power"
        ansMatrix = ans

        var yhat : Double = 0
        for temp in 0..<self.ys.count
        {
            yhat += log(ys[temp])
        }
        yhat/=Double(self.ys.count)
        
        var yvariance : Double = 0
        for temp in 0..<self.ys.count
        {
            yvariance+=pow((log(ys[temp])-yhat),2)
        }
        
        var top : Double = 0
        for temp in 0..<self.ys.count
        {
            let yval : Double = log(ans[0,0])+ans[1,0]*log(xs[temp])
            top+=pow((log(ys[temp])-yval),2)
        }
        
        let rsqrd : Double = 1-top/yvariance
        
        self.rsquaredText = String(format: "%.06f", rsqrd)
        updateR2()
    }
 
    func drawPoints()
    {
        for pnt in points
        {
            pnt.removeFromSuperlayer()
        }
        points.removeAll()
        
        for i in 0..<xs.count
        {
            let layer = CAShapeLayer()
            
            let xxx = CGFloat(xs[i]/self.interval)*self.view.frame.size.width/self.currentGrid
            let yyy = CGFloat(ys[i]/self.interval)*self.view.frame.size.width/self.currentGrid
            let diameter = CGFloat(1/pow((self.currentGrid-2),0.25)*30)
            
            layer.path = UIBezierPath(ovalIn: CGRect(x:xxx+self.centerX-diameter/2, y:-yyy+self.centerY-diameter/2, width:diameter, height:diameter)).cgPath
            
            self.view.layer.addSublayer(layer)
            points.append(layer)
        }
      


        topView.superview?.bringSubview(toFront: topView)
        
        eqnButton.superview?.bringSubview(toFront: eqnButton)
        calculateButton.superview?.bringSubview(toFront: calculateButton)
        
        eqnButton.layer.borderWidth = 0.5;
        eqnButton.layer.borderColor = UIColor.black.cgColor
        
        calculateButton.layer.borderWidth = 0.5;
        calculateButton.layer.borderColor = UIColor.black.cgColor
        
        rsqrd.superview?.bringSubview(toFront: rsqrd)
    }
    func drawGridandAxis()
    {
        for lne in lines 
        {
            lne.removeFromSuperlayer()
        }
        lines.removeAll()
        
        let x = self.view.frame.size.width
        let y = self.view.frame.size.height
        let interval = x/currentGrid
        
        var num : CGFloat = 0;
        for temp in stride(from: 0, to: x, by: interval) {
            drawLine(x1: temp,y1: 0,x2: temp,y2: y, lineWidth: 1, color: UIColor(red: 0, green: 0.25, blue: 0.5, alpha: 0.1).cgColor)
        }
        for temp in stride(from: 0, to: y, by: interval) {
            drawLine(x1: 0,y1: temp,x2: x,y2: temp, lineWidth: 1, color: UIColor(red: 0, green: 0.25, blue: 0.5, alpha: 0.1).cgColor)
            num=num+1
        }
        let n:CGFloat = interval
        drawLine(x1: n, y1: interval*round(num/2), x2: x-n, y2: interval*round(num/2), lineWidth: 2, color: UIColor.black.cgColor)
        drawLine(x1: x/2, y1: interval*round(num/2)+n-x/2, x2: x/2, y2: interval*round(num/2)-n+x/2, lineWidth: 2, color: UIColor.black.cgColor)
        
        centerX = x/2
        centerY = interval*round(num/2)
        
        let graphPath = UIBezierPath()
        if(self.regressionType != "")
        {
            if(self.regressionType == "polynomial" || self.regressionType == "exponential")
            {
                graphPath.move(to: CGPoint(x: -1,y: Double(centerY)-getY(x: -gridLen-1)))
                for temp in stride(from: 0, to: x, by: 5)
                {
                    let ycoord : Double = getY(x: (Double(temp)-Double(centerX))/Double(centerX)*Double(currentGrid/2)*Double(self.interval))
                    graphPath.addLine(to: CGPoint(x: Double(temp),y: Double(centerY)-ycoord))
                    
                    
                }
                
            }
            if(self.regressionType == "power" || self.regressionType == "logarithmic")
            {
                graphPath.move(to: CGPoint(x: Double(x/2+1),y: Double(centerY)-getY(x: Double(0.001))))
                for temp in stride(from: x/2+1, to: x, by: 5)
                {
                    let ycoord : Double = getY(x: (Double(temp)-Double(centerX))/Double(centerX)*Double(currentGrid/2)*Double(self.interval))
                    graphPath.addLine(to: CGPoint(x: Double(temp),y: Double(centerY)-ycoord))
                    
                    
                }
                
            }
        }

        graphLayer.path = graphPath.cgPath
        graphLayer.strokeColor = UIColor.green.cgColor
        graphLayer.fillColor = UIColor.clear.cgColor
        graphLayer.lineWidth = 2
        view.layer.addSublayer(graphLayer)
        self.view.layer.addSublayer(graphLayer)

        
        drawPoints()

       
    }
    func getY(x: Double) -> Double
    {
        if(self.regressionType == "polynomial")
        {
            var out : Double = 0
            for i in 0..<ansMatrix.rows
            {
                out += ansMatrix[i,0]*pow(x,Double(i))
            }
            return out/self.interval*Double(self.view.frame.size.width)/Double(self.currentGrid)

        }
        if(self.regressionType == "exponential")
        {
            let out : Double = ansMatrix[0,0]*pow(ansMatrix[1,0],x)
            
            return out/self.interval*Double(self.view.frame.size.width)/Double(self.currentGrid)
            
        }
        if(self.regressionType == "power")
        {
            let out : Double = ansMatrix[0,0]*pow(x,ansMatrix[1,0])
            return out/self.interval*Double(self.view.frame.size.width)/Double(self.currentGrid)
            
        }
        if(self.regressionType == "logarithmic")
        {
            let out : Double = ansMatrix[0,0]+log(x)*ansMatrix[1,0]

            return out/self.interval*Double(self.view.frame.size.width)/Double(self.currentGrid)
            
        }
        return 0

    }
    func drawLine(x1: CGFloat, y1: CGFloat, x2: CGFloat, y2: CGFloat, lineWidth: CGFloat, color: CGColor)
    {
        let shape = UIBezierPath()
        shape.move(to: CGPoint(x: x1,y: y1))
        shape.addLine(to: CGPoint(x: x2,y: y2))
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = shape.cgPath
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = lineWidth
        view.layer.addSublayer(shapeLayer)
        lines.append(shapeLayer)
    }
    func transposeMat(mat: Matrix) -> Matrix
    {
        var out = Matrix(rows: mat.columns, columns: mat.rows)
        
        for k in stride(from: 0, to: mat.rows, by: 1)
        {
            for l in stride(from: 0, to: mat.columns, by: 1)
            {
                out[l,k] = mat[k,l]
            }
        }
        
        return out
    }
    func multMat(mat1: Matrix, mat2: Matrix) -> Matrix
    {
        var out = Matrix(rows: mat1.rows, columns: mat2.columns)

        for k in stride(from: 0, to: mat1.rows, by: 1)
        {
            for l in stride(from: 0, to: mat1.columns, by: 1)
            {
                for m in stride(from: 0, to: mat2.columns, by: 1)
                {
                    out[k,m]+=mat1[k,l]*mat2[l,m]
                }
            }
        }
        
        return out
    }
    func invertMat(mat: Matrix) -> Matrix
    {
        var rrefMat = Matrix(rows: mat.rows, columns: mat.rows*2)
        for k in stride(from: 0, to: mat.rows, by: 1) {
            for l in stride(from: 0, to: mat.columns, by: 1) {
                rrefMat[k,l] = mat[k,l]
                rrefMat[k,k+mat.rows]=1
            }
        }
        
        for lead in stride(from: 0, to: mat.rows, by: 1)
        {
            let leadingterm: Double = rrefMat[lead,lead]
            for aa in stride(from: lead, to: 2*mat.rows, by: 1)
            {
                rrefMat[lead,aa]=rrefMat[lead,aa]/leadingterm
            }
            for bb in stride(from: lead+1, to: mat.rows, by: 1)
            {
                let newLead : Double = rrefMat[bb,lead]
                for cc in stride(from: 0, to: 2*mat.rows, by: 1)
                {
                    rrefMat[bb,cc]=rrefMat[bb,cc]-newLead*rrefMat[lead,cc]
                }
            }
        }
        for aa in stride(from: 0, to: mat.rows-1, by: 1)
        {
            for bb in stride(from: aa+1, to: mat.rows, by: 1)
            {
                let leadingTerm : Double = rrefMat[aa,bb]
                for cc in stride(from: 0, to: 2*mat.rows, by: 1)
                {
                    rrefMat[aa,cc]=rrefMat[aa,cc]-leadingTerm*rrefMat[bb,cc]
                }
            }
        }
        
       
        var out = Matrix(rows: mat.rows, columns: mat.columns)
        for k in stride(from: 0, to: mat.rows, by: 1)
        {
            for l in stride(from: 0, to: mat.columns, by: 1)
            {
                out[k,l]=rrefMat[k,l+mat.rows]
            }
        }
        return out
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func exponentize(str: String) -> String
    {
        
        let supers = [
            "-": "\u{207B}",
            "0": "\u{2070}",
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
struct Matrix {
    let rows: Int, columns: Int
    var grid: [Double]
    init(rows: Int, columns: Int) {
        self.rows = rows
        self.columns = columns
        grid = Array(repeating: 0.0, count: rows * columns)
    }
    func indexIsValid(row: Int, column: Int) -> Bool {
        return row >= 0 && row < rows && column >= 0 && column < columns
    }
    subscript(row: Int, column: Int) -> Double {
        get {
            assert(indexIsValid(row: row, column: column), "Index out of range")
            return grid[(row * columns) + column]
        }
        set {
            assert(indexIsValid(row: row, column: column), "Index out of range")
            grid[(row * columns) + column] = newValue
        }
    }
}
