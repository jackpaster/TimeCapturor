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
    
    @IBOutlet weak var createNewButton: UIButton!
    @IBOutlet weak var sharButton: UIButton!
    
    @IBAction func btnCreatNew(sender: UIButton) {
    }
    
    @IBAction func btnShare(sender: UIButton) {
    }
    
    
    func backMain(sender:UIButton){
        navigationController?.popToRootViewControllerAnimated(true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            //print("main")
        }
        

        
        
        let statusHeight = UIApplication.sharedApplication().statusBarFrame.size.height
        let statusView = UIView(frame:
            CGRect(x: 0.0, y: 0.0, width: UIScreen.mainScreen().bounds.size.width, height:statusHeight) )
        statusView.backgroundColor = UIColor(red: 231 / 255.0, green: 76 / 255.0, blue: 60 / 255.0, alpha: 0.97)
        self.view.addSubview(statusView)
        
        view.backgroundColor = UIColor(red: 52 / 255.0, green: 73 / 255.0, blue: 94 / 255.0, alpha: 1)
        
        
        
        playButton.setImage(UIImage(named: "ic_play"), forState: .Normal)
        playButton.centerLabelVerticallyWithPadding(1)
        playButton.backgroundColor = UIColor(red: 189/255.0, green: 195/255.0, blue: 199/255.0, alpha: 0.5) //rgb(189, 195, 199)
        self.customConfiguration = self.customKVNProgressUIConfiguration()
        if(Album().getAllImageAndDate().AllData.count != 0 ){
            previewVideoView.image = Album().getAllImageAndDate().AllData[0].ImageData
        }else{
            //previewVideoView.image
        }
        
        // Do any additional setup after loading the view.
        //btnGenerateVideo(UIButton())
        playButton.hidden = true
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
        configuration.backgroundTintColor = UIColor(red: 0.173, green: 0.263, blue: 0.856, alpha: 0.4)
        configuration.successColor = UIColor.whiteColor()
        configuration.errorColor = UIColor.whiteColor()
        //print("My")
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


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var previewVideoView: UIImageView!

    @IBOutlet weak var playButton: UIButton!

    @IBAction func btnPlayVideo(sender: UIButton) {
        
        
        playVideo(videoURL)
        
        
    }
    //var Image = Album().getAllImageAndDate().ImageData
    //var firstFrame = Album().getAllImageAndDate().AllData[0].ImageData
    var ImageURLs = Album().getAllImageAndDate().urlString
    var videoURL = NSURL()
    
     var customConfiguration = KVNProgressConfiguration()
    
    @IBAction func btnGenerateVideo(sender: UIButton) {
        
        let videoGenerator = TimeLapseBuilder(photoURLs: ImageURLs)
        
        print(ImageURLs)
        KVNProgress.showProgress(0, status: "laoding...",onView: view)
        
        // [KVNProgress showWithStatus:@"Loading" onView:view];
        
        videoGenerator.build({ (progress) -> Void in
            
            print(progress)
            dispatch_async(dispatch_get_main_queue(), {
               // KVNProgress.showProgress(progress, status:"Generating... \(Int(progress*100))%",onView: self.view)
            })
            }, success: { (video) -> Void in
                // dispatch_async(dispatch_get_main_queue(), {
                
                dispatch_async(dispatch_get_main_queue(), {
                    KVNProgress.showSuccessWithStatus("Success",onView: self.view)
                    self.playButton.hidden = false
                })
                
                // KVNProgress.dismiss()
                //   })
                
                // print(video)
                
               
                self.videoURL = video
                //self.playVideo(video)
                
            }) { (error) -> Void in
                print("error")
        }
        
        
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
