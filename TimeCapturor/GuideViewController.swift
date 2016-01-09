//
//  GuideViewController.swift
//  TimeCapturor
//
//  Created by YangTengfei on 1/9/16.
//  Copyright © 2016 TengfeiYang. All rights reserved.
//

import UIKit

class GuideViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let statusHeight = UIApplication.sharedApplication().statusBarFrame.size.height
        let statusView = UIView(frame:
            CGRect(x: 0.0, y: 0.0, width: UIScreen.mainScreen().bounds.size.width, height:statusHeight) )
        statusView.backgroundColor = UIColor(red: 230 / 255.0, green: 75 / 255.0, blue: 85 / 255.0, alpha: 1)
        self.view.addSubview(statusView)
        
        view.backgroundColor =  UIColor(red: 171 / 255.0, green: 216 / 255.0, blue: 204 / 255.0, alpha: 1)

        
        let backBtton = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        backBtton.setImage(UIImage(named: "ic_back"), forState: UIControlState.Normal)
        backBtton.addTarget(self, action: Selector("backMain:"), forControlEvents:  UIControlEvents.TouchUpInside)
        let item = UIBarButtonItem(customView: backBtton)
        self.navigationItem.leftBarButtonItem = item
        
        let guideView = UIImageView(frame: view.frame)
        guideView.backgroundColor = UIColor.clearColor()
        guideView.image = UIImage(named: "guide")
        guideView.contentMode = .ScaleAspectFit
        
        view.addSubview(guideView)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func backMain(sender:UIButton){
        navigationController?.popViewControllerAnimated(true)
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
