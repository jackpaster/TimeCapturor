    //
    //  RootViewController.swift
    //  SwiftGif
    //
    //  Created by Arne Bahlo on 10.06.14.
    //  Copyright (c) 2014 Arne Bahlo. All rights reserved.
    //
    
    import UIKit
    import MobileCoreServices
    import ImageIO
    import AVFoundation
    //import UCZProgressView
   // import AVKit
   // import MediaPlayer
    import KVNProgress
    
    class GIFViewController: UIViewController {
        
         var previousPage = 0
        
        @IBOutlet weak var gifimageView: UIImageView!
        
        //let progressView = UCZProgressView()
        var customConfiguration = KVNProgressConfiguration()
        
        
        func backMain(sender:UIButton){
            navigationController?.popToRootViewControllerAnimated(true)
        }
        
        override func viewDidLoad() {
            let statusHeight = UIApplication.sharedApplication().statusBarFrame.size.height
            let statusView = UIView(frame:
                CGRect(x: 0.0, y: 0.0, width: UIScreen.mainScreen().bounds.size.width, height:statusHeight) )
            statusView.backgroundColor = UIColor(red: 231 / 255.0, green: 76 / 255.0, blue: 60 / 255.0, alpha: 0.97)
            self.view.addSubview(statusView)
            
            view.backgroundColor = UIColor(red: 52 / 255.0, green: 73 / 255.0, blue: 94 / 255.0, alpha: 1)
            
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
            configuration.backgroundTintColor = UIColor(red: 0.173, green: 0.263, blue: 0.856, alpha: 0.4)
            configuration.successColor = UIColor.whiteColor()
            configuration.errorColor = UIColor.whiteColor()
            configuration.stopColor = UIColor.whiteColor()//stop button color
            configuration.circleSize = 110.0
            configuration.fullScreen = false
            
            //        let blockSelf: ViewController = self
            //
            //        configuration.tapBlock = {(Progress)in
            //            blockSelf.basicConfiguration.tapBlock = nil
            //            KVNProgress.dismiss()
            //        }
            configuration.stopRelativeHeight = 0.3
            // configuration.stopColor = [UIColor whiteColor];
            
           
            configuration.tapBlock = {(Progress) in
                // Do what you want
                KVNProgress.dismiss()
                
            }
             configuration.showStop = true
            
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
       
        
        @IBAction func doneAction(sender: UIBarButtonItem) {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        @IBAction func back(sender: UIButton) {
            //self.dismissViewControllerAnimated(true, completion: nil)
            navigationController?.popToRootViewControllerAnimated(true)
        }
        @IBAction func btnGeneratGIF(sender: UIButton) {
            let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
            dispatch_async(dispatch_get_global_queue(qos, 0)) { () -> Void in
                let url = self.createGIF(with: self.Image, loopCount: 4,frameDelay: 0.1)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let gif = UIImage.gifWithURL(url)
                    self.gifimageView.image = gif
                    self.gifimageView.hidden = false
                })
            }
            
            
            //  print("\(url)")
            
        }
        
        
              
        
        
               
        
        
        func ResizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
            let size = image.size
            
            let widthRatio  = targetSize.width  / image.size.width
            let heightRatio = targetSize.height / image.size.height
            
            // Figure out what our orientation is, and use that to form the rectangle
            var newSize: CGSize
            if(widthRatio > heightRatio) {
                newSize = CGSizeMake(size.width * heightRatio, size.height * heightRatio)
            } else {
                newSize = CGSizeMake(size.width * widthRatio,  size.height * widthRatio)
            }
            
            // This is the rect that we've calculated out and this is what is actually used below
            let rect = CGRectMake(0, 0, newSize.width, newSize.height)
            
            // Actually do the resizing to the rect using the ImageContext stuff
            UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
            image.drawInRect(rect)
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return newImage
        }
        
        
        func createGIF(with images: [UIImage], loopCount: Int = 0, frameDelay: Double) ->NSURL{
            let fileProperties = [kCGImagePropertyGIFDictionary as String: [kCGImagePropertyGIFLoopCount as String: loopCount]]
            let frameProperties = [kCGImagePropertyGIFDictionary as String: [kCGImagePropertyGIFDelayTime as String: frameDelay]]
            
            let size = CGSizeMake(192, 256)
            
            let documentsDirectory = NSTemporaryDirectory()
            let url = NSURL(fileURLWithPath: documentsDirectory).URLByAppendingPathComponent("animated.gif")
            if url != NSURL() {
                let destination = CGImageDestinationCreateWithURL(url, kUTTypeGIF, images.count, nil)
                CGImageDestinationSetProperties(destination!, fileProperties)
                //print("1:\(gifdata)")
                for i in 0..<images.count {
                    autoreleasepool{
                        CGImageDestinationAddImage(destination!, ResizeImage(images[i],targetSize: size).CGImage!, frameProperties)
                        // print("Generating \(images[i].CGImage!)")
                    }
                    
                }
                if CGImageDestinationFinalize(destination!) {
                    print("finaliza success")
                    // print("\(url)")
                    return url
                    
                } else {
                    
                    print("error")
                    return NSURL()
                }
            } else  {
                
                print("error")
                return NSURL()
            }
        }
        
        
        
    }
