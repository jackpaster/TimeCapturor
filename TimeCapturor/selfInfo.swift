//
//  self.swift
//  TimeCapturor
//
//  Created by YangTengfei on 1/7/16.
//  Copyright © 2016 TengfeiYang. All rights reserved.
//

import UIKit

protocol superViewController:class{
    func getSuperViewController(sender:UIView)->UIViewController?
}

class selfInfo:UIView{
    
    weak var viewController : superViewController?
    
    override init(frame: CGRect) {
        
        super.init(frame: CGRectMake(0, frame.origin.y + 44, frame.size.width, frame.size.height-44))
        setBlur()
        addChart()
        createButton()
        
        var launchtime = 0
        var photonumber = 0
        var firstmoments = "No Record"
        let defaults = NSUserDefaults.standardUserDefaults()
        if let launch = defaults.valueForKey("launchTimes") as? Int
        {
            launchtime = launch
        }
        if let photos = defaults.valueForKey("photoNumber") as? Int
        {
            photonumber = photos
        }
        
        if let first = defaults.valueForKey("firstMoment") as? String
        {
            firstmoments = first
        }
         if(screenHeight == 736){
            self.addSubview( labelCreator( " First captured moment : \(firstmoments)", yPosition: 340) )
            self.addSubview( labelCreator(" Total launching time : \(launchtime)", yPosition: 410) )
            self.addSubview( labelCreator( " Total captured moments : \(photonumber)", yPosition: 480) )
            
         }else{
            
        self.addSubview( labelCreator( " First captured moment : \(firstmoments)", yPosition: 340) )
         self.addSubview( labelCreator(" Total launching time : \(launchtime)", yPosition: 380) )
        self.addSubview( labelCreator( " Total captured moments : \(photonumber)", yPosition: 420) )
            
        }
        
      }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createButton(){
        let returnButton = UIButton(frame: CGRectMake(0, 0, 100, 40) )
        returnButton.center = CGPointMake(screenWidth/2.0, self.frame.size.height - 40 )
        returnButton.setTitle("Return", forState: .Normal)
        returnButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        returnButton.layer.cornerRadius = 20
        returnButton.layer.borderWidth = 0.5
        returnButton.layer.borderColor = UIColor.whiteColor().CGColor
        returnButton.addTarget(self, action: "Return", forControlEvents: UIControlEvents.TouchUpInside)

        self.addSubview(returnButton)
        
    }
    
    func Return(){

        UIView.animateWithDuration(0.5,
            animations: {
                self.alpha = 0
            }, completion: {_ in
                print(self.viewController?.getSuperViewController(self))
                self.viewController?.getSuperViewController(self)?.navigationController?.hidesBarsOnSwipe = true
                self.removeFromSuperview()})
        
    }
    
    func setBlur(){
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame =  self.bounds
        self.addSubview(blurEffectView)
        
        // Vibrancy Effect
        let vibrancyEffect = UIVibrancyEffect(forBlurEffect: blurEffect)
        let vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)
        vibrancyEffectView.frame = self.bounds
        
        // Label for vibrant text
        let vibrantLabel = UILabel()
        vibrantLabel.text = "Vibrant"
        
        // Add label to the vibrancy view
        vibrancyEffectView.contentView.addSubview(vibrantLabel)
        
        // Add the vibrancy view to the blur view
        blurEffectView.contentView.addSubview(vibrancyEffectView)
    
    }
    
    func labelCreator(labelText:String,yPosition:CGFloat) -> UILabel{
       
        if(screenHeight == 736){
            let label = UILabel(frame: CGRectMake(0, 0, screenWidth-40, 50) )
            label.center = CGPointMake(screenWidth/2.0, yPosition)
            label.textAlignment = NSTextAlignment.Left
            label.text = labelText
            label.textColor = UIColor.whiteColor()
            label.font =  UIFont(name: label.font.fontName, size: 16)
            label.layer.masksToBounds = true
            label.layer.cornerRadius = 5
            //label.layer.backgroundColor = UIColor(red: 46/255.0, green: 204/255.0, blue: 113/255.0, alpha: 0.4).CGColor//rgb(46, 204, 113)
            label.layer.borderColor = UIColor.whiteColor().CGColor
            label.layer.borderWidth = 0.8
            return label
            
        }else{
             let label = UILabel(frame: CGRectMake(0, 0, screenWidth-40, 30) )
            label.center = CGPointMake(screenWidth/2.0, yPosition)
            label.textAlignment = NSTextAlignment.Left
            label.text = labelText
            label.textColor = UIColor.whiteColor()
            label.font =  UIFont(name: label.font.fontName, size: 13)
            label.layer.masksToBounds = true
            label.layer.cornerRadius = 3
            //label.layer.backgroundColor = UIColor(red: 46/255.0, green: 204/255.0, blue: 113/255.0, alpha: 0.4).CGColor//rgb(46, 204, 113)
            label.layer.borderColor = UIColor.whiteColor().CGColor
            label.layer.borderWidth = 0.4
            return label
        }
        
        
        
    }
    
    func addChart(){
        
        let weekdays: [Int: String] = [1: "Mon.",
            2: "Tue.",
            3: "Wed.",
            4: "Thu.",
            5: "Fri.",
            6: "Sat.",
            7: "Sun."
        ]
        
        let cal = NSCalendar.currentCalendar()
        // start with today
        var date = cal.startOfDayForDate(NSDate())
        var days = [String]()
        var daysValue = [Int]()
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if var WeekCountDic = defaults.dictionaryForKey("WeekCountDic") as? [String:String]
        {
            for _ in 1 ... 7 {
                // get day component:
                let day = cal.component(.Weekday, fromDate: date)
                days.append(weekdays[day]!)
                let dayString = String(day)
                let count = (WeekCountDic[dayString]! as NSString).intValue
                daysValue.append(Int(count))
                // move back in time by one day:
                date = cal.dateByAddingUnit(.Weekday, value: -1, toDate: date, options: NSCalendarOptions(rawValue: 0))!
            }
            print(days)
            print(daysValue)
        }else{
            
            for _ in 1 ... 7 {
                // get day component:
                let day = cal.component(.Weekday, fromDate: date)
                days.append(weekdays[day]!)
                daysValue.append(0)
                // move back in time by one day:
                date = cal.dateByAddingUnit(.Weekday, value: -1, toDate: date, options: NSCalendarOptions(rawValue: 0))!
            }
        }
    
        
        let ChartLabel:UILabel = UILabel(frame: CGRectMake(0, 50, screenWidth, 30))
        ChartLabel.text = "Past 7 days captured"
        ChartLabel.textColor = UIColor.whiteColor()
        ChartLabel.textAlignment = NSTextAlignment.Center
        ChartLabel.font = UIFont.boldSystemFontOfSize(15.0)
        let barChart = PNBarChart(frame: CGRectMake(0, 80.0, screenWidth, 220.0))
        barChart.backgroundColor = UIColor.clearColor()
        // remove for default animation (all bars animate at once)
        barChart.animationType = .Waterfall
        
        barChart.yLabelFormatter = ({(yValue: CGFloat) -> NSString in
            let yValueParsed:CGFloat = yValue
            let labelText:NSString = NSString(format:"%1.f",yValueParsed)
            return labelText;
        })
        days[0] = "Today"
        barChart.labelMarginTop = 5.0
        barChart.xLabels = days
        barChart.yValues = daysValue
        barChart.showChartBorder = true
        barChart.strokeChart()
        
        self.addSubview(ChartLabel)
        self.addSubview(barChart)
        

    }

}
