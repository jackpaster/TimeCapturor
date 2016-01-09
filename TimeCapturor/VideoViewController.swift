//
//  VideoViewController.swift
//  TimeCapturor
//
//  Created by YangTengfei on 12/30/15.
//  Copyright © 2015 TengfeiYang. All rights reserved.
//

import UIKit
import KVNProgress
import AVKit
import MediaPlayer
import MessageUI

class VideoViewController: UIViewController,AAShareBubblesDelegate,MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate {
    
    @IBOutlet weak var noFileMessage: UILabel!
    @IBOutlet weak var createNewButton: UIButton!
    @IBOutlet weak var sharButton: UIButton!
    @IBOutlet weak var dateLable: UILabel!
    
    @IBAction func btnCreatNew(sender: UIButton) {
        
        if (ImageURLs.count<2){
            
            SweetAlert().showAlert("At least two photos",subTitle: "Take more photos to create an amazing video :)",style: AlertStyle.Warning)
            
            return
        }
        
        
        let videoGenerator = TimeLapseBuilder(photoURLs: ImageURLs,framePerSecond: 7)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if let speed = defaults.valueForKey("speed") as? Float
        {
            videoGenerator.framePerSecond = speed
            
        }
        
        KVNProgress.showProgress(0, status:"Generating... 0%")
        // [KVNProgress showWithStatus:@"Loading" onView:view];
        let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
        dispatch_async(dispatch_get_global_queue(qos, 0)) { () -> Void in
            
            videoGenerator.build({ (progress) -> Void in
                
                //print(progress)
                dispatch_async(dispatch_get_main_queue(), {
                    KVNProgress.updateProgress(progress, animated: true)
                    KVNProgress.updateStatus("Generating... \(Int(progress*100))%")
                    
                })
                }, success: { (video) -> Void in
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        KVNProgress.showSuccessWithStatus("Success")
                        
                        self.videoURL = video
                        self.previewVideoView.image = self.firstFrameOfVideo(self.videoURL)
                        
                    })
                    
                    //print("video")
                    //print(video)
                    
                    defaults.setURL(video, forKey: "AssembedVideoURL")
                    defaults.setValue(self.getCurrentDate(), forKey: "VideoCreatedTime")
                    
                    //self.playVideo(video)
                    
                }) { (error) -> Void in
                    print("error")
            }
            
            
            
        }
        //print(NSURL.isFileReferenceURL(video))
        self.dateLable.text = self.getCurrentDate()
        self.dateLable.hidden = false
        self.noFileMessage.hidden = true
        self.playButton.hidden = false
    }
    
    func createShareBubble(){
        let shareBubbles = AAShareBubbles.init(centeredInWindowWithRadius: 150)
        shareBubbles.delegate = self
        shareBubbles.bubbleRadius = 30; // Default is 40
        shareBubbles.showMailBubble = true
        shareBubbles.showFacebookBubble = true
        shareBubbles.showTwitterBubble = true
        shareBubbles.showInsBubble = true
        //shareBubbles.showInstagramBubble = true
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
            
            self.InformShareError()
            
            NSLog("Twitter")
            break
        case AAShareBubbleTypeMail.rawValue:
            ShareViaEmail()
            NSLog("Email")
            break
        case AAShareBubbleTypeIns.rawValue:
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
    
    
    func aaShareBubblesDidHide(bubbles: AAShareBubbles) {
        NSLog("All Bubbles hidden")
    }
    
    
    
    @IBAction func btnShare(sender: UIButton) {
        
        createShareBubble()
        
    }
    
    
    func backMain(sender:UIButton){
        navigationController?.popToRootViewControllerAnimated(true)
    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    
    func firstFrameOfVideo(path:NSURL)->UIImage{
        let asset: AVURLAsset = AVURLAsset(URL: path)
        let imageGenerator: AVAssetImageGenerator = AVAssetImageGenerator(asset: asset)
        let  timeScale =  asset.duration.timescale
        let frame = try! imageGenerator.copyCGImageAtTime(CMTimeMake(1, timeScale), actualTime: nil)
        //var image: UIImage = UIImage.imageWithCGImage(frame, actualTime: nil)
        // videoFrame.image = image
        let frameImg : UIImage = UIImage(CGImage: frame)
        return frameImg
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if let videoURL = defaults.URLForKey("AssembedVideoURL")
        {
            let fileExist = NSFileManager.defaultManager().fileExistsAtPath(videoURL.path!)
            if fileExist == true{
                self.videoURL = videoURL
                previewVideoView.image = firstFrameOfVideo(videoURL)
                playButton.hidden = false
                noFileMessage.hidden = true
                dateLable.hidden = false
                
            }
        }else{
            // previewVideoView.image = video hasn't generated'
            playButton.hidden = true
            dateLable.hidden = true
            noFileMessage.hidden = false
            
        }
        
        previewVideoView.backgroundColor = UIColor(red: 200 / 255.0, green: 220 / 255.0, blue: 200 / 255.0, alpha: 1)
        
        dateLable.text = defaults.valueForKey("VideoCreatedTime") as? String
        dateLable.font = UIFont(name: dateLable.font.fontName, size: 11) //rgb(127, 140, 141)
        dateLable.textColor = UIColor(red: 236 / 255.0, green: 240 / 255.0, blue: 241 / 255.0, alpha: 1)
        dateLable.textAlignment = .Right
        dateLable.backgroundColor = UIColor(red: 44 / 255.0, green: 62 / 255.0, blue: 80 / 255.0, alpha: 0.1)//rgb(44, 62, 80)
        view.addSubview(dateLable)
        
        //KVNProgress.setConfiguration(self.customConfiguration)
        
        //NSURL.isFileReferenceURL()
        
     
        
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
        createNewButton.layer.cornerRadius = createNewButton.frame.size.height/2.0
        
        
        sharButton.layer.shadowColor = UIColor.blackColor().CGColor
        sharButton.layer.shadowOffset = CGSizeMake(0, 4)
        sharButton.layer.shadowRadius = 2
        sharButton.layer.shadowOpacity = 0.5
        sharButton.layer.masksToBounds = false
        // print(gifButton.frame)
        //gifButton.setImage(UIImage(named: "ic_gif"), forState: .Normal)
        //gifButton.centerLabelVerticallyWithPadding(0)
        sharButton.setTitleColor(UIColor(red: 230 / 255.0, green: 75 / 255.0, blue: 85 / 255.0, alpha: 1), forState: UIControlState.Normal)//rgb(236, 240, 241)
        sharButton.backgroundColor = UIColor(red: 236 / 255.0, green: 240 / 255.0, blue: 241 / 255.0, alpha: 1)
        sharButton.layer.cornerRadius = sharButton.frame.size.height/2.0
        
        
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
            self.title = "Video"
            //self.navigationController!.viewControllers.topItem.title = "some title"
            // self.navigationController?.title = "Video"
            //self.navigationItem.leftBarButtonItem = item
            
            
            // print("setting")
            ////////------=-=-=-=-=-=--=--=-=-==-=-=--==-=--=
            
            
        }else{
            let backBtton = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            backBtton.setImage(UIImage(named: "ic_back"), forState: UIControlState.Normal)
            backBtton.addTarget(self, action: Selector("backMain:"), forControlEvents:  UIControlEvents.TouchUpInside)
            let item = UIBarButtonItem(customView: backBtton)
            //self.navigationController?.title = "Video"
            self.title = "Video"
            self.navigationItem.leftBarButtonItem = item
            //print("main")
        }
        
        
        
        
        let statusHeight = UIApplication.sharedApplication().statusBarFrame.size.height
        let statusView = UIView(frame:
            CGRect(x: 0.0, y: 0.0, width: UIScreen.mainScreen().bounds.size.width, height:statusHeight) )
        statusView.backgroundColor = UIColor(red: 230 / 255.0, green: 75 / 255.0, blue: 85 / 255.0, alpha: 0.97)
        self.view.addSubview(statusView)
        
        view.backgroundColor =  UIColor(red: 171 / 255.0, green: 216 / 255.0, blue: 204 / 255.0, alpha: 1)
        
        
        playButton.tintColor = UIColor(red: 41 / 255.0, green: 128 / 255.0, blue: 185 / 255.0, alpha: 1)//rgb(41, 128, 185)
        playButton.setImage(UIImage(named: "ic_play"), forState: .Normal)
        playButton.centerLabelVerticallyWithPadding(1)
        playButton.backgroundColor = UIColor(red: 189/255.0, green: 195/255.0, blue: 199/255.0, alpha: 0.6) //rrgb(52, 73, 94)
        
        self.customConfiguration = self.customKVNProgressUIConfiguration()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.hidesBarsOnSwipe = false
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        KVNProgress.setConfiguration(self.customConfiguration)
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
        configuration.backgroundTintColor = UIColor(red: 236/255.0, green: 240/255.0, blue: 241/255.0, alpha: 0.4) //rgb(236, 240, 241)
        configuration.successColor = UIColor.whiteColor()
        configuration.errorColor = UIColor.whiteColor()
        //print("My")
        configuration.stopColor = UIColor.whiteColor()//stop button color
        configuration.circleSize = 110.0
        configuration.fullScreen = true
        
        //        let blockSelf: ViewController = self
        //
        //        configuration.tapBlock = {(Progress)in
        //            blockSelf.basicConfiguration.tapBlock = nil
        //            KVNProgress.dismiss()
        //        }
        configuration.backgroundType = .Blurred
        
        configuration.stopRelativeHeight = 0.3
        // configuration.stopColor = [UIColor whiteColor];
        
        
        //        configuration.tapBlock = {(Progress) in
        //            // Do what you want
        //            KVNProgress.dismiss()
        //            //shouldCancle = true
        //
        //
        //        }
        configuration.showStop = false
        
        return configuration
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var previewVideoView: UIImageView!
    
    @IBOutlet weak var playButton: UIButton!
    
    @IBAction func btnPlayVideo(sender: UIButton) {
        
        let fileExist = NSFileManager.defaultManager().fileExistsAtPath(videoURL.path!)
        if fileExist == true{
            playVideo(videoURL)
        }else{
            SweetAlert().showAlert("Video file doesn't exist!", subTitle: "You should create one first", style: AlertStyle.Error)
        }
        
        
        
        
    }
    //var Image = Album().getAllImageAndDate().ImageData
    //var firstFrame = Album().getAllImageAndDate().AllData[0].ImageData
    var ImageURLs = Album().getAllImageAndDate().urlString
    var videoURL = NSURL()
    
    var customConfiguration = KVNProgressConfiguration()
    
    //    @IBAction func btnGenerateVideo(sender: UIButton) {
    //
    //        let videoGenerator = TimeLapseBuilder(photoURLs: ImageURLs)
    //
    //        print(ImageURLs)
    //        KVNProgress.showProgress(0, status: "laoding...",onView: view)
    //
    //        // [KVNProgress showWithStatus:@"Loading" onView:view];
    //
    //        videoGenerator.build({ (progress) -> Void in
    //
    //            print(progress)
    //            dispatch_async(dispatch_get_main_queue(), {
    //                // KVNProgress.showProgress(progress, status:"Generating... \(Int(progress*100))%",onView: self.view)
    //            })
    //            }, success: { (video) -> Void in
    //                // dispatch_async(dispatch_get_main_queue(), {
    //
    //                dispatch_async(dispatch_get_main_queue(), {
    //                    KVNProgress.showSuccessWithStatus("Success",onView: self.view)
    //                    self.playButton.hidden = false
    //                })
    //
    //                // KVNProgress.dismiss()
    //                //   })
    //
    //                // print(video)
    //
    //
    //                self.videoURL = video
    //                //self.playVideo(video)
    //
    //            }) { (error) -> Void in
    //                print("error")
    //        }
    //
    //
    //    }
    func getCurrentDate()->String{
        //            let GMTdate: NSDate = NSDate()
        //            let zone: NSTimeZone = NSTimeZone.systemTimeZone()
        //            let interval = zone.secondsFromGMTForDate(GMTdate)
        //            let localeDate: NSDate = GMTdate.dateByAddingTimeInterval(Double(interval))
        //            return localeDate
        let todaysDate:NSDate = NSDate()
        let dateFormatter:NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm MM/dd/yyyy"
        let DateInFormat:String = dateFormatter.stringFromDate(todaysDate)
        return DateInFormat
        //            let date = NSDate()
        //            let formatter = NSDateFormatter()
        //            formatter.timeStyle = .ShortStyle
        //            formatter.stringFromDate(date)
        //            return date
    }
    
    
    
    
    private func playVideo(v:NSURL) {
        
        dispatch_async(dispatch_get_main_queue(), {
            // code here
            let player = AVPlayer(URL: v)
            let playerController = AVPlayerViewController()
            playerController.player = player
            self.presentViewController(playerController, animated: true) {
                player.play()
            }
        })
        
        
    }
    
    
    func ShareViaWechat() {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if let videoURL = defaults.URLForKey("AssembedVideoURL")
        {
            let message =  WXMediaMessage()
            message.title = "TimeCapturorExport.mov"
            message.description = "It's my time"
            message.setThumbImage(UIImage(named:"logo"))
            
            
            let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
            
            dispatch_async(dispatch_get_global_queue(qos, 0)) {
                
                let ext =  WXFileObject()
                ext.fileExtension = "mov"
                //let filePath = NSBundle.mainBundle().pathForResource("ML", ofType: "pdf")
                ext.fileData = NSData(contentsOfFile:videoURL.path!)
                message.mediaObject = ext
                
            }
            
            let req =  SendMessageToWXReq()
            req.bText = false
            req.message = message
            req.scene = Int32(WXSceneSession.rawValue)
            WXApi.sendReq(req)
        }else{
            SweetAlert().showAlert("Video doesn't exist", subTitle: "Please create one first", style: AlertStyle.Error)
        }
        
    }
    
    func ShareViaEmail(){
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if let videoURL = defaults.URLForKey("AssembedVideoURL")
        {
            
            if( MFMailComposeViewController.canSendMail() ) {
                print("Can send email.")
                
                let mailComposer = MFMailComposeViewController()
                mailComposer.mailComposeDelegate = self
                
                //Set the subject and message of the email
                mailComposer.setSubject("Have you heard about TimeCapturor?")
                mailComposer.setMessageBody("This is the amazing video I created using TimeCapturor!", isHTML: false)
                
                let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
                
                dispatch_async(dispatch_get_global_queue(qos, 0)) {
                    
                    if let fileData = NSData(contentsOfFile: videoURL.path!) {
                        print("File data loaded.")
                        mailComposer.addAttachmentData(fileData, mimeType: "mov", fileName: "TimeCapturorExport.mov")
                    }
                    
                }
                self.presentViewController(mailComposer, animated: true, completion: nil)
            }else{
                print("please set up your email first")
                SweetAlert().showAlert("Email is not available", subTitle: "Please set up your email first", style: AlertStyle.Error)
            }
        }else{
            SweetAlert().showAlert("Video doesn't exist", subTitle: "Please create one first", style: AlertStyle.Error)
        }
        
        
        
        
    }
    
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // Configures and returns a MFMessageComposeViewController instance
    func ShareViaMessage() {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let videoURL = defaults.URLForKey("AssembedVideoURL")
        {
            if( MFMessageComposeViewController.canSendText() ) {
                print("Can send email.")
                
                let messageComposeVC = MFMessageComposeViewController()
                messageComposeVC.messageComposeDelegate = self
                
                let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
                dispatch_async(dispatch_get_global_queue(qos, 0)) {
                    
                    if let fileData = NSData(contentsOfFile: videoURL.path!) {
                        print("File data loaded.")
                        messageComposeVC.addAttachmentData(fileData, typeIdentifier: "mov", filename: "TimeCapturorExport.mov")
                    }
                    
                }
                
                messageComposeVC.body = "Check this out! I cerated using TimeCapturor!"
                
                
                self.presentViewController(messageComposeVC, animated: true, completion: nil)
                
            }else{
                SweetAlert().showAlert("Message is not available", subTitle: "Please set up your message first", style: AlertStyle.Error)
            }
        }
            
        else{
            SweetAlert().showAlert("Video doesn't exist", subTitle: "Please create one first", style: AlertStyle.Error)
            
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
