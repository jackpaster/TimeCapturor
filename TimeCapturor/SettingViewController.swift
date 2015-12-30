//
//  SettingViewController.swift
//  TimeCapturor
//
//  Created by YangTengfei on 12/29/15.
//  Copyright © 2015 TengfeiYang. All rights reserved.
//

import UIKit
import EFCircularSlider

class SettingViewController: UIViewController {
    
    
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var valueLable: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        subTitle.textColor = UIColor(red: 189 / 255.0, green: 195 / 255.0, blue: 199 / 255.0, alpha: 1)//rgb(189, 195, 199)
        valueLable.textColor = UIColor(red: 189 / 255.0, green: 195 / 255.0, blue: 199 / 255.0, alpha: 1)//rgb(236, 240, 241)
        
        navigationController?.navigationBar.layer.shadowColor = UIColor.blackColor().CGColor
        navigationController?.navigationBar.layer.shadowOffset = CGSizeMake(0, 4)
        navigationController?.navigationBar.layer.shadowRadius = 2
        navigationController?.navigationBar.layer.shadowOpacity = 0.5
        navigationController?.navigationBar.layer.masksToBounds = false
        let bar:UINavigationBar! =  self.navigationController?.navigationBar
        
        bar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        bar.shadowImage = UIImage()
        bar.backgroundColor = UIColor(red: 231 / 255.0, green: 76 / 255.0, blue: 60 / 255.0, alpha: 0.97)
       
        let statusHeight = UIApplication.sharedApplication().statusBarFrame.size.height
        let statusView = UIView(frame:
            CGRect(x: 0.0, y: 0.0, width: UIScreen.mainScreen().bounds.size.width, height:statusHeight) )
        statusView.backgroundColor = UIColor(red: 231 / 255.0, green: 76 / 255.0, blue: 60 / 255.0, alpha: 0.97)
        self.view.addSubview(statusView)

        view.backgroundColor = UIColor(red: 52 / 255.0, green: 73 / 255.0, blue: 94 / 255.0, alpha: 1)
        
        let sliderFrame = CGRectMake(0, 150, UIScreen.mainScreen().bounds.width, 250);
        let circularSlider:EFCircularSlider = EFCircularSlider(frame: sliderFrame)
        //valueLable.frame = CGRectMake(250, 200, 50, 30)
        circularSlider.addTarget(self, action: "valueChanged:", forControlEvents: .ValueChanged)
        
        self.view.addSubview(circularSlider)
        circularSlider.currentValue = 7
        
        // Do any additional setup after loading the view.
    }
    
    func valueChanged(slider:EFCircularSlider) {
        valueLable.text = String(Int(ceil(slider.currentValue))) + " fps"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
