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
    @IBOutlet weak var valueLable: UILabel!

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
        gifButton.layer.cornerRadius = 28
        
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
        videoButton.layer.cornerRadius = 28
        ///////////////////////////////////////////////////////////////////////////////
        
        
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
