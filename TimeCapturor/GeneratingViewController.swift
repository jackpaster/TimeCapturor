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
import UCZProgressView
import AVKit
import MediaPlayer

class GIFViewController: UIViewController {
    
    @IBOutlet weak var gifimageView: UIImageView!
     var videoURL = NSURL()
    let progressView = UCZProgressView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        progressView.frame = gifimageView.frame
        
        progressView.indeterminate = false
        progressView.showsText = true
        progressView.center = view.center
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    var Image = Album().getAllImageAndDate().ImageData
    var ImageURLs = Album().getAllImageAndDate().urlString
    
    @IBAction func doneAction(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func back(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
    
    //  private var firstAppear = true
    // var moviePlayer : MPMoviePlayerController!
   
    @IBAction func btnGenerateVideo(sender: UIButton) {
        
        let videoGenerator = TimeLapseBuilder(photoURLs: ImageURLs)

        
        videoGenerator.build({ (progress) -> Void in
            print(progress)
            }, success: { (video) -> Void in
              
                print(video)
                self.videoURL = video
                self.playVideo(video)
                
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
