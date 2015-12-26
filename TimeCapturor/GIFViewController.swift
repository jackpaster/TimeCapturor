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

class GIFViewController: UIViewController {
   
    @IBOutlet weak var gifimageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
//        let jeremyGif = UIImage.gifWithName("jeremy")
//        let imageView = UIImageView(image: jeremyGif)
//        imageView.frame = CGRect(x: 0.0, y: 20.0, width: 350.0, height: 202.0)
//        
//        view.addSubview(imageView)
//
//        let imageData = NSData(contentsOfURL: NSBundle.mainBundle().URLForResource("adventure-time", withExtension: "gif")!)
//        let advTimeGif = UIImage.gifWithData(imageData!)
//        let imageView2 = UIImageView(image: advTimeGif)
//        imageView2.frame = CGRect(x: 0.0, y: 222.0, width: 350.0, height: 202.0)
//        
//        view.addSubview(imageView2)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    var Image = Album().getAllImageAndDate().ImageData
   
    @IBAction func back(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func btnGeneratGIF(sender: UIButton) {
        let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
        dispatch_async(dispatch_get_global_queue(qos, 0)) { () -> Void in
            let url = self.createGIF(with: self.Image, loopCount: 4,frameDelay: 0.1)
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                let jeremyGif = UIImage.gifWithURL(url)
                self.gifimageView.image = jeremyGif
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
                CGImageDestinationAddImage(destination!, ResizeImage(images[i],targetSize: size).fixOrientation().CGImage!, frameProperties)
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
