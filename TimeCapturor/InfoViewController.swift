//
//  InfoViewController.swift
//  TimeCapturor
//
//  Created by YangTengfei on 1/5/16.
//  Copyright © 2016 TengfeiYang. All rights reserved.
//

import UIKit
import MessageUI

class InfoViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var mailButton: UIButton!
    @IBOutlet weak var linkedinButton: UIButton!
    @IBOutlet weak var weiboButton: UIButton!
    
    @IBOutlet weak var namelable: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    var items: [String] = ["How to use", "Any issue or idear", "Rate in App Store","Tell your friend","version 1.0.0"]
    
    @IBAction func mailAction(sender: UIButton) {
        
        if( MFMailComposeViewController.canSendMail() ) {
            print("Can send email.")
            
            let mailComposer = MFMailComposeViewController()
            mailComposer.mailComposeDelegate = self
            //Set the subject and message of the email
            mailComposer.setToRecipients(["tengfeiyang2010@gmail.com"])
            mailComposer.setSubject("TimeCapturor Feedback")
            mailComposer.setMessageBody("I am using TimeCapturor version 1.0.0", isHTML: false)
            self.presentViewController(mailComposer, animated: true, completion: nil)
            
        }else{
            SweetAlert().showAlert("Email not setup", subTitle: "Please setup your email account in system", style: AlertStyle.Error)
        }
        
        
    }
    
    @IBAction func linkedinAction(sender: UIButton) {
        UIApplication.sharedApplication().openURL(NSURL(string: "https://www.linkedin.com/in/tengfei-yang-57870594")!)
    }
    
    @IBAction func weiboAction(sender: UIButton) {
        
        UIApplication.sharedApplication().openURL(NSURL(string: "http://weibo.com/tengfeiyang")!)

    }
    
    func backMain(sender:UIButton){
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backBtton = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        backBtton.setImage(UIImage(named: "ic_back"), forState: UIControlState.Normal)
        backBtton.addTarget(self, action: Selector("backMain:"), forControlEvents:  UIControlEvents.TouchUpInside)
        let item = UIBarButtonItem(customView: backBtton)
        self.navigationItem.leftBarButtonItem = item
        
        
        namelable.textColor = UIColor(red: 236 / 255.0, green: 240 / 255.0, blue: 241 / 255.0, alpha: 1)  //rgb(236, 240, 241)
        
        mailButton.layer.cornerRadius = 25
        mailButton.layer.masksToBounds = true
        mailButton.tintColor = UIColor.whiteColor()
        mailButton.layer.backgroundColor =  UIColor(red: 187 / 255.0, green: 84 / 255.0, blue: 181 / 255.0, alpha: 1).CGColor
        mailButton.setImage(UIImage(named: "ic_mail"), forState: .Normal)
        
        linkedinButton.layer.cornerRadius = 25
        linkedinButton.layer.masksToBounds = true
        linkedinButton.tintColor = UIColor.whiteColor()
        linkedinButton.layer.backgroundColor =  UIColor(red: 0 / 255.0, green: 119 / 255.0, blue: 181 / 255.0, alpha: 1).CGColor
        linkedinButton.setImage(UIImage(named: "ic_linkedin"), forState: .Normal)
        
        
        weiboButton.layer.cornerRadius = 25
        weiboButton.layer.masksToBounds = true
        weiboButton.tintColor = UIColor.whiteColor()
        weiboButton.layer.backgroundColor =  UIColor(red: 230 / 255.0, green: 22 / 255.0, blue: 45 / 255.0, alpha: 1).CGColor
        weiboButton.setImage(UIImage(named: "ic_weibo"), forState: .Normal)
        
        
        
        let statusHeight = UIApplication.sharedApplication().statusBarFrame.size.height
        let statusView = UIView(frame:
            CGRect(x: 0.0, y: 0.0, width: UIScreen.mainScreen().bounds.size.width, height:statusHeight) )
        statusView.backgroundColor = UIColor(red: 231 / 255.0, green: 76 / 255.0, blue: 60 / 255.0, alpha: 0.97)
        self.view.addSubview(statusView)
        
        view.backgroundColor =  UIColor(red: 29 / 255.0, green: 78 / 255.0, blue: 111 / 255.0, alpha: 1)
        
        
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        
        cell.textLabel?.text = self.items[indexPath.row]
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("You selected cell #\(indexPath.row)!")
    }
    
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
