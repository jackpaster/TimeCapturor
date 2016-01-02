//
//  GeneretingGIF.swift
//  TimeCapturor
//
//  Created by YangTengfei on 1/2/16.
//  Copyright © 2016 TengfeiYang. All rights reserved.
//

import UIKit
import MobileCoreServices
import ImageIO

class GifBiulder: NSObject {
    //let photoURLs: [String]
    let images: [UIImage]
    let loopCount: Int = 100
    var frameDelay: Double
    
    init(images: [UIImage],frameDelay : Double) {
        self.images = images
        self.frameDelay = frameDelay
    }
    
    
    func build(progress: (CGFloat -> Void), success: (NSURL -> Void), failure: (NSError -> Void)) {
        
            let totalNumber = images.count

            let fileProperties = [kCGImagePropertyGIFDictionary as String: [kCGImagePropertyGIFLoopCount as String: loopCount]]
            let frameProperties = [kCGImagePropertyGIFDictionary as String: [kCGImagePropertyGIFDelayTime as String: frameDelay]]
            print(frameDelay)
            let size = CGSizeMake(192*2, 256*2)
            
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
                    progress( CGFloat(i)/CGFloat(totalNumber) )
                    
                }
                if CGImageDestinationFinalize(destination!) {
                   // print("finaliza success")
                    // print("\(url)")
                    success( url )
                    
                } else {
                    
                    print("error")
                    //failure(NSError())
                }
            } else  {
                
                print("error")
                
            }
            
            
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
            
            
            

}
