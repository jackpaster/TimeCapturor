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
    
    class GIFViewController: UIViewController {
        
         var previousPage = 0
        
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
                    dateLable.text = defaults.valueForKey("GifCreatedTime") as? String
                    dateLable.font = UIFont(name: dateLable.font.fontName, size: 11) //rgb(127, 140, 141)
                    dateLable.textColor = UIColor(red: 236 / 255.0, green: 240 / 255.0, blue: 241 / 255.0, alpha: 1)
                    dateLable.textAlignment = .Right
                    dateLable.backgroundColor = UIColor(red: 44 / 255.0, green: 62 / 255.0, blue: 80 / 255.0, alpha: 0.3)//rgb(44, 62, 80)
                    view.addSubview(dateLable)

                    
                }
            }else{
                dateLable.hidden = true
                // previewVideoView.image = video hasn't generated'
                
            }
            
            
            createNewButton.layer.shadowColor = UIColor.blackColor().CGColor
            createNewButton.layer.shadowOffset = CGSizeMake(0, 4)
            createNewButton.layer.shadowRadius = 2
            createNewButton.layer.shadowOpacity = 0.5
            createNewButton.layer.masksToBounds = false
            // print(gifButton.frame)
            //gifButton.setImage(UIImage(named: "ic_gif"), forState: .Normal)
            //gifButton.centerLabelVerticallyWithPadding(0)
            createNewButton.setTitleColor(UIColor(red: 195 / 255.0, green: 57 / 255.0, blue: 43 / 255.0, alpha: 1.0), forState: UIControlState.Normal)//rgb(236, 240, 241)
            createNewButton.backgroundColor = UIColor(red: 236 / 255.0, green: 240 / 255.0, blue: 241 / 255.0, alpha: 1)
            createNewButton.layer.cornerRadius = 28
            
            
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
            sharButton.layer.cornerRadius = 28
            
            
            let statusHeight = UIApplication.sharedApplication().statusBarFrame.size.height
            let statusView = UIView(frame:
                CGRect(x: 0.0, y: 0.0, width: UIScreen.mainScreen().bounds.size.width, height:statusHeight) )
            statusView.backgroundColor = UIColor(red: 231 / 255.0, green: 76 / 255.0, blue: 60 / 255.0, alpha: 0.97)
            self.view.addSubview(statusView)
            
            view.backgroundColor =  UIColor(red: 29 / 255.0, green: 78 / 255.0, blue: 111 / 255.0, alpha: 1)
            
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
            
            //        let blockSelf: ViewController = self
            //
            //        configuration.tapBlock = {(Progress)in
            //            blockSelf.basicConfiguration.tapBlock = nil
            //            KVNProgress.dismiss()
            //        }
            configuration.stopRelativeHeight = 0.3
            // configuration.stopColor = [UIColor whiteColor];
            
           
//            configuration.tapBlock = {(Progress) in
//                // Do what you want
//                KVNProgress.dismiss()
//                
//            }
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
            
           
            let GIFGenerator = GifBiulder(images: Image, frameDelay: 7.0)
            
            let defaults = NSUserDefaults.standardUserDefaults()
            if let speed = defaults.valueForKey("speed") as? Float
            {
             GIFGenerator.frameDelay = (1 / Double(speed))
                //print(speed)
               // print(GIFGenerator.frameDelay)
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
                            self.dateLable.text = self.getCurrentDate()
                            self.dateLable.hidden = false
                            let gif = UIImage.gifWithURL(gif)
                            self.gifimageView.image = gif

                        })
                        
                        
                    }) { (error) -> Void in
                        print("error")
                }
                
            }
            
            
        }
        
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
        
        @IBAction func btnShare(sender: UIButton) {
            
            
            
        }
        
        
               
        
            
        
    }
