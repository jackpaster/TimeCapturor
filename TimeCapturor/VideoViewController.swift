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

class VideoViewController: UIViewController {
    
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
    
    @IBAction func btnShare(sender: UIButton) {
        
        let textToShare = "Swift is awesome!  Check out this website about it!"
        
        let myWebsite = videoURL
        
            let objectsToShare = [textToShare, myWebsite]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            self.presentViewController(activityVC, animated: true, completion: nil)
        
        
        
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
        
        dateLable.text = defaults.valueForKey("VideoCreatedTime") as? String
        dateLable.font = UIFont(name: dateLable.font.fontName, size: 11) //rgb(127, 140, 141)
        dateLable.textColor = UIColor(red: 236 / 255.0, green: 240 / 255.0, blue: 241 / 255.0, alpha: 1)
        dateLable.textAlignment = .Right
        dateLable.backgroundColor = UIColor(red: 44 / 255.0, green: 62 / 255.0, blue: 80 / 255.0, alpha: 0.1)//rgb(44, 62, 80)
        view.addSubview(dateLable)

        //KVNProgress.setConfiguration(self.customConfiguration)
        
         //NSURL.isFileReferenceURL()
        
        
        //UIApplication.sharedApplication().setStatusBarStyle(.LightContent , animated: false)
       // UIViewController.preferredStatusBarStyle(.LightContent)
        createNewButton.layer.shadowColor = UIColor.blackColor().CGColor
        createNewButton.layer.shadowOffset = CGSizeMake(0, 4)
        createNewButton.layer.shadowRadius = 2
        createNewButton.layer.shadowOpacity = 0.5
        createNewButton.layer.masksToBounds = false
        // print(gifButton.frame)
        //gifButton.setImage(UIImage(named: "ic_gif"), forState: .Normal)
        //gifButton.centerLabelVerticallyWithPadding(0)
        createNewButton.setTitleColor(UIColor(red: 231 / 255.0, green: 76 / 255.0, blue: 60 / 255.0, alpha: 1.0), forState: UIControlState.Normal)//rgb(236, 240, 241)
        createNewButton.backgroundColor = UIColor(red: 236 / 255.0, green: 240 / 255.0, blue: 241 / 255.0, alpha: 1)
        createNewButton.layer.cornerRadius = 25
        
        
        sharButton.layer.shadowColor = UIColor.blackColor().CGColor
        sharButton.layer.shadowOffset = CGSizeMake(0, 4)
        sharButton.layer.shadowRadius = 2
        sharButton.layer.shadowOpacity = 0.5
        sharButton.layer.masksToBounds = false
        // print(gifButton.frame)
        //gifButton.setImage(UIImage(named: "ic_gif"), forState: .Normal)
        //gifButton.centerLabelVerticallyWithPadding(0)
        sharButton.setTitleColor(UIColor(red: 231 / 255.0, green: 76 / 255.0, blue: 60 / 255.0, alpha: 1.0), forState: UIControlState.Normal)//rgb(236, 240, 241)
        sharButton.backgroundColor = UIColor(red: 236 / 255.0, green: 240 / 255.0, blue: 241 / 255.0, alpha: 1)
        sharButton.layer.cornerRadius = 25
        
        
        
        
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
        statusView.backgroundColor = UIColor(red: 231 / 255.0, green: 76 / 255.0, blue: 60 / 255.0, alpha: 0.97)
        self.view.addSubview(statusView)
        
        view.backgroundColor =  UIColor(red: 29 / 255.0, green: 78 / 255.0, blue: 111 / 255.0, alpha: 1)
        
        
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
    
    
    
    
    
}
