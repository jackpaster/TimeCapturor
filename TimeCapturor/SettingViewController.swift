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
    
    @IBOutlet weak var gifButton: UIButton!
    @IBOutlet weak var videoButton: UIButton!
    
    @IBOutlet weak var subTitle: UILabel!

    @IBOutlet weak var returnButton: UIButton!
    
    @IBAction func btnReturn(sender: UIButton) {
        
        //navigationController?.popToRootViewControllerAnimated(true)\
        //navigationController?.popViewControllerAnimated(true)
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    let backBtton = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
    func back(sender:UIButton){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func gifButton(sender: UIButton) {
       
    }
    
    @IBAction func videoButton(sender: UIButton) {
       
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // get a reference to the previous VC
        //var prevVC: UITabBarController = self.navigationController!.viewControllers[currentVCIndex - 1] as! UITabBarController
        // get the VC shown by the previous VC
        //var prevShownVC: EventInformationViewController = prevVC.selectedViewController as! EventInformationViewController
       // prevShownVC.performSelector("rateCurrentEvent:")
        
        
       // backButton.image = UIImage(named: "ic_back")
        //let backBtton = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        backBtton.setImage(UIImage(named: "ic_back"), forState: UIControlState.Normal)
        backBtton.addTarget(self, action: Selector("back:"), forControlEvents:  UIControlEvents.TouchUpInside)
        let item = UIBarButtonItem(customView: backBtton)
        self.navigationItem.leftBarButtonItem = item
        
        gifButton.layer.shadowColor = UIColor.blackColor().CGColor
        gifButton.layer.shadowOffset = CGSizeMake(0, 4)
        gifButton.layer.shadowRadius = 2
        gifButton.layer.shadowOpacity = 0.5
        gifButton.layer.masksToBounds = false
       // print(gifButton.frame)
        //gifButton.setImage(UIImage(named: "ic_gif"), forState: .Normal)
        //gifButton.centerLabelVerticallyWithPadding(0)
        gifButton.setTitleColor(UIColor(red: 231 / 255.0, green: 76 / 255.0, blue: 60 / 255.0, alpha: 1.0), forState: UIControlState.Normal)//rgb(236, 240, 241)
        gifButton.backgroundColor = UIColor(red: 236 / 255.0, green: 240 / 255.0, blue: 241 / 255.0, alpha: 1)
        gifButton.layer.cornerRadius = 25
        
        ///////////////////////////////////////////////////////////////////////////////
        
        videoButton.layer.shadowColor = UIColor.blackColor().CGColor
        videoButton.layer.shadowOffset = CGSizeMake(0, 4)
        videoButton.layer.shadowRadius = 2
        videoButton.layer.shadowOpacity = 0.5
        videoButton.layer.masksToBounds = false
        // print(gifButton.frame)
        //gifButton.setImage(UIImage(named: "ic_gif"), forState: .Normal)
        //gifButton.centerLabelVerticallyWithPadding(1)
        videoButton.setTitleColor(UIColor(red: 231 / 255.0, green: 76 / 255.0, blue: 60 / 255.0, alpha: 1.0), forState: UIControlState.Normal)//rgb(236, 240, 241)
        videoButton.backgroundColor = UIColor(red: 236 / 255.0, green: 240 / 255.0, blue: 241 / 255.0, alpha: 1)
        videoButton.layer.cornerRadius = 25
        ///////////////////////////////////////////////////////////////////////////////
        
        
        subTitle.textColor = UIColor.whiteColor()//rgb(189, 195, 199)
       
        navigationController?.navigationBar.layer.shadowColor = UIColor.blackColor().CGColor
        navigationController?.navigationBar.layer.shadowOffset = CGSizeMake(0, 4)
        navigationController?.navigationBar.layer.shadowRadius = 2
        navigationController?.navigationBar.layer.shadowOpacity = 0.5
        navigationController?.navigationBar.layer.masksToBounds = false
        let bar:UINavigationBar! =  self.navigationController?.navigationBar
        
        bar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        bar.shadowImage = UIImage()
        bar.backgroundColor = UIColor(red: 230 / 255.0, green: 75 / 255.0, blue: 85 / 255.0, alpha: 0.97)
       
        let statusHeight = UIApplication.sharedApplication().statusBarFrame.size.height
        let statusView = UIView(frame:
            CGRect(x: 0.0, y: 0.0, width: UIScreen.mainScreen().bounds.size.width, height:statusHeight) )
        statusView.backgroundColor = UIColor(red: 230 / 255.0, green: 75 / 255.0, blue: 85 / 255.0, alpha: 0.97)
        self.view.addSubview(statusView)

        view.backgroundColor =  UIColor(red: 171 / 255.0, green: 216 / 255.0, blue: 204 / 255.0, alpha: 1)
        
        var sliderFrame = CGRectMake(0, 150, UIScreen.mainScreen().bounds.width, 250);
        if(screenHeight == 736){
            sliderFrame = CGRectMake(0, 200, UIScreen.mainScreen().bounds.width, 250);

        }
        valueLable = UILabel(frame: CGRectMake(screenWidth/2.0, sliderFrame.origin.y+70, 50, 20))
        valueLable.center = CGPointMake(screenWidth/2.0, sliderFrame.origin.y+70)
        
        valueLable.textAlignment = NSTextAlignment.Center
        
        //self.view.addSubview(valueLable)
        
        //frame = CGRectMake(screenWidth/2.0,sliderFrame.height+20,50,30)
        valueLable.textColor = UIColor.whiteColor()//rgb(236, 240, 241)
        view.addSubview(valueLable)

        let circularSlider:EFCircularSlider = EFCircularSlider(frame: sliderFrame)
        //valueLable.frame = CGRectMake(250, 200, 50, 30)
        circularSlider.addTarget(self, action: "valueChanged:", forControlEvents: .ValueChanged)
    
        self.view.addSubview(circularSlider)
        //circularSlider.currentValue = 7
        let defaults = NSUserDefaults.standardUserDefaults()
        if let speed = defaults.valueForKey("speed") as? Float
        {
            circularSlider.currentValue  = speed
        }else{
            circularSlider.currentValue = 7
        }
        
        
        // Do any additional setup after loading the view.
    }
    var valueLable = UILabel()
    
    let userdefault = NSUserDefaults.standardUserDefaults()
    
    func valueChanged(slider:EFCircularSlider) {
        valueLable.text = String(Int(ceil(slider.currentValue))) + " fps"
        userdefault.setValue(slider.currentValue, forKey: "speed")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
