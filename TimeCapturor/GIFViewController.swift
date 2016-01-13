    //
    //  RootViewController.swift
    //  SwiftGif
    //
    //  Created by Arne Bahlo on 10.06.14.
    //  Copyright (c) 2014 Arne Bahlo. All rights reserved.
    //
    
    import UIKit
    //import CoreGraphics
    import AVFoundation
    //import UCZProgressView
    // import AVKit
    // import MediaPlayer
    import KVNProgress
    import MessageUI
    
    class GIFViewController: UIViewController,AAShareBubblesDelegate,MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate {
        
        var previousPage = 0
        
        @IBOutlet weak var noFileMessage: UILabel!
        @IBOutlet weak var dateLable: UILabel!
        @IBOutlet weak var sharButton: UIButton!
        @IBOutlet weak var createNewButton: UIButton!
        @IBOutlet weak var gifimageView: UIImageView!
        
        //let progressView = UCZProgressView()
        var customConfiguration = KVNProgressConfiguration()
        
        func backMain(sender:UIButton){
            navigationController?.popToRootViewControllerAnimated(true)
        }
        
        override func viewDidLoad() {
            let defaults = NSUserDefaults.standardUserDefaults()
            if let gifURL = defaults.URLForKey("AssembedGifURL")
            {
                let fileExist = NSFileManager.defaultManager().fileExistsAtPath(gifURL.path!)
                if fileExist == true{
                    let gif = UIImage.gifWithURL(gifURL)
                    self.gifimageView.image = gif
                    
                    dateLable.hidden = false
                    noFileMessage.hidden = true
                    dateLable.text = defaults.valueForKey("GifCreatedTime") as? String
                    
                }
            }else{
                dateLable.hidden = true
                noFileMessage.hidden = false
                // previewVideoView.image = video hasn't generated'
                
            }
            
            gifimageView.backgroundColor = UIColor(red: 200 / 255.0, green: 220 / 255.0, blue: 200 / 255.0, alpha: 1)
            
            
            dateLable.font = UIFont(name: dateLable.font.fontName, size: 11) //rgb(127, 140, 141)
            dateLable.textColor = UIColor(red: 236 / 255.0, green: 240 / 255.0, blue: 241 / 255.0, alpha: 1)
            dateLable.textAlignment = .Right
            dateLable.backgroundColor = UIColor(red: 44 / 255.0, green: 62 / 255.0, blue: 80 / 255.0, alpha: 0.3)//rgb(44, 62, 80)
            view.addSubview(dateLable)
            
            
            createNewButton.layer.shadowColor = UIColor.blackColor().CGColor
            createNewButton.layer.shadowOffset = CGSizeMake(0, 4)
            createNewButton.layer.shadowRadius = 2
            createNewButton.layer.shadowOpacity = 0.5
            createNewButton.layer.masksToBounds = false
            // print(gifButton.frame)
            //gifButton.setImage(UIImage(named: "ic_gif"), forState: .Normal)
            //gifButton.centerLabelVerticallyWithPadding(0)
            createNewButton.setTitleColor(UIColor(red: 230 / 255.0, green: 75 / 255.0, blue: 85 / 255.0, alpha: 1), forState: UIControlState.Normal)//rgb(236, 240, 241)
            createNewButton.backgroundColor = UIColor(red: 236 / 255.0, green: 240 / 255.0, blue: 241 / 255.0, alpha: 1)
            createNewButton.layer.cornerRadius = 22.5
            
            
            sharButton.layer.shadowColor = UIColor.blackColor().CGColor
            sharButton.layer.shadowOffset = CGSizeMake(0, 4)
            sharButton.layer.shadowRadius = 2
            sharButton.layer.shadowOpacity = 0.5
            sharButton.layer.masksToBounds = false
            // print(gifButton.frame)
            //gifButton.setImage(UIImage(named: "ic_gif"), forState: .Normal)
            //gifButton.centerLabelVerticallyWithPadding(0)
            sharButton.setTitleColor(UIColor(red: 230 / 255.0, green: 75 / 255.0, blue: 85 / 255.0, alpha: 1) , forState: UIControlState.Normal)//rgb(236, 240, 241)
            sharButton.backgroundColor = UIColor(red: 236 / 255.0, green: 240 / 255.0, blue: 241 / 255.0, alpha: 1)
            sharButton.layer.cornerRadius = 22.5
            
            
            let statusHeight = UIApplication.sharedApplication().statusBarFrame.size.height
            let statusView = UIView(frame:
                CGRect(x: 0.0, y: 0.0, width: UIScreen.mainScreen().bounds.size.width, height:statusHeight) )
            statusView.backgroundColor = UIColor(red: 230 / 255.0, green: 75 / 255.0, blue: 85 / 255.0, alpha: 0.97)
            self.view.addSubview(statusView)
            
            view.backgroundColor =  UIColor(red: 171 / 255.0, green: 216 / 255.0, blue: 204 / 255.0, alpha: 1)
            
            if let _ = self.navigationController!.viewControllers[0] as? SettingViewController{
                let backBtton = UIButton(frame: CGRect(x: 0, y: 0, width: 90, height: 20))
                backBtton.setImage(UIImage(named: "ic_back"), forState: UIControlState.Normal)
                backBtton.addTarget(self, action: Selector("backMain:"), forControlEvents:  UIControlEvents.TouchUpInside)
                backBtton.setTitle("Setting", forState: .Normal)
                backBtton.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
                backBtton.titleLabel?.contentMode = UIViewContentMode.ScaleAspectFit
                backBtton.titleLabel?.font = UIFont(name: UILabel().font.fontName , size: 15)
                
                let spacer = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
                spacer.width = -10;
                
                let item = UIBarButtonItem(customView: backBtton)
                self.navigationItem.leftBarButtonItems = [spacer,item]
                
                //self.navigationItem.leftBarButtonItem = item
                
                
                // print("setting")
                ////////------=-=-=-=-=-=--=--=-=-==-=-=--==-=--=
                
                
            }else{
                let backBtton = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
                backBtton.setImage(UIImage(named: "ic_back"), forState: UIControlState.Normal)
                backBtton.addTarget(self, action: Selector("backMain:"), forControlEvents:  UIControlEvents.TouchUpInside)
                let item = UIBarButtonItem(customView: backBtton)
                self.navigationItem.leftBarButtonItem = item
                // print("main")
            }
            
            
            
            super.viewDidLoad()
            //  self.basicConfiguration = KVNProgressConfiguration.defaultConfiguration()
            self.customConfiguration = self.customKVNProgressUIConfiguration()
            self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
            
        }
        
        
        
        func customKVNProgressUIConfiguration() -> KVNProgressConfiguration {
            let configuration: KVNProgressConfiguration = KVNProgressConfiguration()
            // See the documentation of KVNProgressConfiguration
            configuration.statusColor = UIColor.whiteColor()
            configuration.statusFont = UIFont(name: "HelveticaNeue-Thin", size: 15.0)
            configuration.circleStrokeForegroundColor = UIColor.whiteColor()
            configuration.circleStrokeBackgroundColor = UIColor(white: 1.0, alpha: 0.3)
            configuration.circleFillBackgroundColor = UIColor(white: 1.0, alpha: 0.1)
            configuration.backgroundFillColor = UIColor(red: 0.173, green: 0.263, blue: 0.856, alpha: 0.9)
            configuration.backgroundTintColor = UIColor(red: 236/255.0, green: 240/255.0, blue: 241/255.0, alpha: 0.4)
            configuration.successColor = UIColor.whiteColor()
            configuration.errorColor = UIColor.whiteColor()
            configuration.stopColor = UIColor.whiteColor()//stop button color
            configuration.circleSize = 110.0
            configuration.fullScreen = true

            configuration.stopRelativeHeight = 0.3
  
            configuration.showStop = false
            
            return configuration
        }
        
        
        
        override func viewDidAppear(animated: Bool) {
            super.viewDidAppear(animated)
            KVNProgress.setConfiguration(self.customConfiguration)
            // btnGenerateVideo(UIButton())
        }
        
        override func viewWillAppear(animated: Bool) {
            super.viewWillAppear(animated)
            
            self.navigationController?.hidesBarsOnSwipe = false
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        var Image = Album().getAllImageAndDate().ImageData
        // var ImageURLs = Album().getAllImageAndDate().urlString
        
        @IBAction func btnGeneratGIF(sender: UIButton) {
            
            if (Image.count<2){
                
                SweetAlert().showAlert("At least two photos",subTitle: "Take more photos to create an amazing video :)",style: AlertStyle.Warning)
                
                return
            }
            
            
            var GIFGenerator :GifBiulder
            
            let defaults = NSUserDefaults.standardUserDefaults()
            if let speed = defaults.valueForKey("speed") as? Float
            {
                //GIFGenerator.frameDelay = (1 / Double(speed))
                GIFGenerator = GifBiulder(images: Image, frameDelay: (1 / Double(speed)))
                //print(speed)
                // print(GIFGenerator.frameDelay)
            }else{
                GIFGenerator = GifBiulder(images: Image, frameDelay: 1/7.0)
            }
            //print(ImageURLs)
            // KVNProgress.showProgress(0, status: "laoding...",onView: view)
            KVNProgress.showProgress(0, status:"Generating... 0%")
            // [KVNProgress showWithStatus:@"Loading" onView:view];
            let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
            dispatch_async(dispatch_get_global_queue(qos, 0)) { () -> Void in
                
                GIFGenerator.build({ (progress) -> Void in
                    
                    //print(progress)
                    dispatch_async(dispatch_get_main_queue(), {
                        if progress < 100 {
                            KVNProgress.updateProgress(progress, animated: true)
                            KVNProgress.updateStatus("Generating... \(Int(progress*100))%")
                        }else{
                            // KVNProgress.updateToInfinite()
                            KVNProgress.updateProgress(progress, animated: true)
                            KVNProgress.updateStatus("Finalizing...")
                        }
                        
                    })
                    }, success: { (gif) -> Void in
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            KVNProgress.showSuccessWithStatus("Success")
                            //print("gif")
                            //print(gif)
                            defaults.setValue(self.getCurrentDate(), forKey: "GifCreatedTime")
                            defaults.setURL(gif, forKey: "AssembedGifURL")
                            self.gifURL = gif
                            let gif = UIImage.gifWithURL(gif)
                            self.gifimageView.image = gif
                            
                        })
                        
                        
                    }) { (error) -> Void in
                        print("error")
                }
                
            }
            
            
            self.dateLable.text = self.getCurrentDate()
            self.dateLable.hidden = false
            self.noFileMessage.hidden = true
        }
        var gifURL = NSURL()
        func getCurrentDate()->String{
            let todaysDate:NSDate = NSDate()
            let dateFormatter:NSDateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "HH:mm MM/dd/yyyy"
            let DateInFormat:String = dateFormatter.stringFromDate(todaysDate)
            return DateInFormat
       }
        
        @IBAction func btnShare(sender: UIButton) {
            
            createShareBubble()
            
        }
        
        
        func createShareBubble(){
            let shareBubbles = AAShareBubbles.init(centeredInWindowWithRadius: 150)
            shareBubbles.delegate = self
            shareBubbles.bubbleRadius = 30; // Default is 40
            shareBubbles.showMailBubble = true
            shareBubbles.showFacebookBubble = true
            shareBubbles.showTwitterBubble = true
          //  shareBubbles.showInsBubble = true
            shareBubbles.showInstagramBubble = true
            shareBubbles.showSinaBubble = true
            shareBubbles.showQQBubble = true
            shareBubbles.showQzoneBubble = true
            shareBubbles.showWechatBubble = true
            shareBubbles.showMessageBubble = true
            // add custom buttons -- buttonId for custom buttons MUST be greater than or equal to 100
            // shareBubbles.addCustomButtonWithIcon(<#T##icon: UIImage!##UIImage!#>, backgroundColor: <#T##UIColor!#>, andButtonId: <#T##Int32#>)
            shareBubbles.show()
            
        }
        
        
        func aaShareBubbles(shareBubbles: AAShareBubbles!, tappedBubbleWithType bubbleType: Int32) {
            switch bubbleType {
            case AAShareBubbleTypeFacebook.rawValue:
                InformShareError()
                NSLog("Facebook")
                break
            case AAShareBubbleTypeTwitter.rawValue:
                InformShareError()
                NSLog("Twitter")
                break
            case AAShareBubbleTypeMail.rawValue:
                ShareViaEmail()
                NSLog("Email")
                break
            case AAShareBubbleTypeInstagram.rawValue:
                InformShareError()
                NSLog("Ins")
                break
            case AAShareBubbleTypeMessage.rawValue:
                ShareViaMessage()
                NSLog("Message")
                break
            case AAShareBubbleTypeQQ.rawValue:
                InformShareError()
                NSLog("QQ")
                break
            case AAShareBubbleTypeQzone.rawValue:
                InformShareError()
                NSLog("Qzone")
                break
            case AAShareBubbleTypeSina.rawValue:
                InformShareError()
                NSLog("Sina")
                break
            case AAShareBubbleTypeWechat.rawValue:
                ShareViaWechat()
                NSLog("Wechat")
                break
            case 100:
                // custom buttons have type >= 100
                NSLog("Custom Button With Type 100")
            default:
                break
            }
        }
        
        
        func ShareViaWechat() {
            let defaults = NSUserDefaults.standardUserDefaults()
            if let gifURL = defaults.URLForKey("AssembedGifURL")
            {
                
                let message =  WXMediaMessage()
                message.title = "TimeCapturorExport.gif"
                message.description = "It's my time"
                message.setThumbImage(UIImage(named:"logo"))
                
                
                let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
                dispatch_async(dispatch_get_global_queue(qos, 0)) {
                    
                    let ext =  WXFileObject()
                    ext.fileExtension = "gif"
                    //let filePath = NSBundle.mainBundle().pathForResource("ML", ofType: "pdf")
                    ext.fileData = NSData(contentsOfFile:gifURL.path!)
                    message.mediaObject = ext
                    
                }
                
                let req =  SendMessageToWXReq()
                req.bText = false
                req.message = message
                req.scene = Int32(WXSceneSession.rawValue)
                WXApi.sendReq(req)
            }else{
                SweetAlert().showAlert("GIF doesn't exist", subTitle: "Please create one first", style: AlertStyle.Error)
                
            }
            
        }
        
        func ShareViaEmail(){
            
            let defaults = NSUserDefaults.standardUserDefaults()
            if let gifURL = defaults.URLForKey("AssembedGifURL")
            {
                
                if( MFMailComposeViewController.canSendMail() ) {
                    print("Can send email.")
                    
                    let mailComposer = MFMailComposeViewController()
                    mailComposer.mailComposeDelegate = self
                    
                    //Set the subject and message of the email
                    mailComposer.setSubject("Have you heard about TimeCapturor?")
                    mailComposer.setMessageBody("This is the amazing video it produced!", isHTML: false)
                    
                    let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
                    dispatch_async(dispatch_get_global_queue(qos, 0)) {
                        
                        if let fileData = NSData(contentsOfFile: gifURL.path!) {
                            print("File data loaded.")
                            mailComposer.addAttachmentData(fileData, mimeType: "gif", fileName: "TimeCapturorExport.gif")
                        }
                    }
                    
                    self.presentViewController(mailComposer, animated: true, completion: nil)
                }else{
                    print("please set up your email first")
                    SweetAlert().showAlert("Email is not available", subTitle: "Please set up your email first", style: AlertStyle.Error)
                    
                }
            }else{
                SweetAlert().showAlert("GIF doesn't exist", subTitle: "Please create one first", style: AlertStyle.Error)
                
                
            }
            
            
        }
        
        
        func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        
        // Configures and returns a MFMessageComposeViewController instance
        func ShareViaMessage() {
            let defaults = NSUserDefaults.standardUserDefaults()
            if let gifURL = defaults.URLForKey("AssembedGifURL")
            {
                
                if( MFMessageComposeViewController.canSendText() ) {
                    print("Can send email.")
                    
                    let messageComposeVC = MFMessageComposeViewController()
                    messageComposeVC.messageComposeDelegate = self
                    
                    let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
                    dispatch_async(dispatch_get_global_queue(qos, 0)) {
                        
                        
                        if let fileData = NSData(contentsOfFile: gifURL.path!) {
                            print("File data loaded.")
                            messageComposeVC.addAttachmentData(fileData, typeIdentifier: "gif", filename: "TimeCapturorExport.gif")
                        }
                        
                    }
                    
                    
                    messageComposeVC.body = "Check this out! I cerated using TimeCapturor!"
                    
                    
                    self.presentViewController(messageComposeVC, animated: true, completion: nil)
                    
                }else{
                    SweetAlert().showAlert("Message is not available", subTitle: "Please set up your message first", style: AlertStyle.Error)
                }
                
            }else{
                SweetAlert().showAlert("GIF doesn't exist", subTitle: "Please create one first", style: AlertStyle.Error)
                
                
            }
        }
        
        // MFMessageComposeViewControllerDelegate callback - dismisses the view controller when the user is finished with it
        func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
            controller.dismissViewControllerAnimated(true, completion: nil)
        }
        
        
        func InformShareError(){
            SweetAlert().showAlert("Coming soon", subTitle: "Please use Wechat, Email, Message to share your time.", style: AlertStyle.Warning)
            
        }
        
        
        
        
        
        
    }
