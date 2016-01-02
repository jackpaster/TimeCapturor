//
//  TimeLapseBuilder.swift
//  Vapor
//
//  Created by Adam Jensen on 5/10/15.
//  Copyright (c) 2015 Adam Jensen. All rights reserved.
//
// NOTE: This implementation is written in Swift 2.0.

import AVFoundation
import UIKit

let kErrorDomain = "TimeLapseBuilder"
let kFailedToStartAssetWriterError = 0
let kFailedToAppendPixelBufferError = 1

class TimeLapseBuilder: NSObject {
    let photoURLs: [String]
    var videoWriter: AVAssetWriter?
    var framePerSecond : Float
    init(photoURLs: [String],framePerSecond : Float) {
        self.photoURLs = photoURLs
        self.framePerSecond = framePerSecond
    }
    
    
    func build(progress: (CGFloat -> Void), success: (NSURL -> Void), failure: (NSError -> Void)) {
        let inputSize = CGSize(width: 960, height: 1280)
        let outputSize = CGSize(width: 960, height: 1280)
        var error: NSError?
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
        let videoOutputURL = NSURL(fileURLWithPath: documentsPath.stringByAppendingPathComponent("AssembledVideo.mov"))
        
        do {
            
            try NSFileManager.defaultManager().removeItemAtURL(videoOutputURL)
            print("deleted")
        } catch {
            print("not deleted")
        }
        
        do {
            try videoWriter = AVAssetWriter(URL: videoOutputURL, fileType: AVFileTypeQuickTimeMovie)
        } catch let writerError as NSError {
            error = writerError
            videoWriter = nil
        }
        
        if let videoWriter = videoWriter {
            let videoSettings: [String : AnyObject] = [
                AVVideoCodecKey  : AVVideoCodecH264,
                AVVideoWidthKey  : outputSize.width,
                AVVideoHeightKey : outputSize.height,
                //        AVVideoCompressionPropertiesKey : [
                //          AVVideoAverageBitRateKey : NSInteger(1000000),
                //          AVVideoMaxKeyFrameIntervalKey : NSInteger(16),
                //          AVVideoProfileLevelKey : AVVideoProfileLevelH264BaselineAutoLevel
                //        ]
            ]
            
            let videoWriterInput = AVAssetWriterInput(mediaType: AVMediaTypeVideo, outputSettings: videoSettings)
            
            let sourceBufferAttributes = [String : AnyObject](dictionaryLiteral:
                (kCVPixelBufferPixelFormatTypeKey as String, Int(kCVPixelFormatType_32ARGB)),
                (kCVPixelBufferWidthKey as String, Float(inputSize.width)),
                (kCVPixelBufferHeightKey as String, Float(inputSize.height))
            )
            
            let pixelBufferAdaptor = AVAssetWriterInputPixelBufferAdaptor(
                assetWriterInput: videoWriterInput,
                sourcePixelBufferAttributes: sourceBufferAttributes
            )
            
            assert(videoWriter.canAddInput(videoWriterInput))
            videoWriter.addInput(videoWriterInput)
            
            if videoWriter.startWriting() {
                videoWriter.startSessionAtSourceTime(kCMTimeZero)
                assert(pixelBufferAdaptor.pixelBufferPool != nil)
                
                let media_queue = dispatch_queue_create("mediaInputQueue", nil)
                
                videoWriterInput.requestMediaDataWhenReadyOnQueue(media_queue, usingBlock: { () -> Void in
                    
                    ///////////////////////////mark /////
                    let fps: Int32 = Int32(self.framePerSecond)
                    let frameDuration = CMTimeMake(1, fps)
                    let currentProgress = self.photoURLs.count
                    
                    var frameCount: Int = 0
                    var remainingPhotoURLs = [String](self.photoURLs)
                    
                    while ( !remainingPhotoURLs.isEmpty) {
                       // print( "before loop \(videoWriterInput.readyForMoreMediaData )" )
                       
                        while (videoWriterInput.readyForMoreMediaData == false) {
                          //  print("looping")
                            let maxDate: NSDate = NSDate(timeIntervalSinceNow: 0.1)
                            NSRunLoop.currentRunLoop().runUntilDate(maxDate)
                        }
                       // print( "after loop \(videoWriterInput.readyForMoreMediaData )" )
                        
                        let nextPhotoURL = remainingPhotoURLs.removeAtIndex(0)
                        let lastFrameTime = CMTimeMake(Int64(frameCount), fps)
                        let presentationTime = frameCount == 0 ? lastFrameTime : CMTimeAdd(lastFrameTime, frameDuration)
                        
                        
                        if !self.appendPixelBufferForImageAtURL(nextPhotoURL, pixelBufferAdaptor: pixelBufferAdaptor, presentationTime: presentationTime) {
                            error = NSError(
                                domain: kErrorDomain,
                                code: kFailedToAppendPixelBufferError,
                                userInfo: [
                                    "description": "AVAssetWriterInputPixelBufferAdapter failed to append pixel buffer",
                                    "rawError": videoWriter.error ?? "(none)"
                                ]
                            )
                            
                            break
                        }
                        
                        
                    frameCount++
                  //  print( videoWriterInput.readyForMoreMediaData )
                //    print( "\(remainingPhotoURLs.count)  + after appen  \(videoWriterInput.readyForMoreMediaData) ")
                    //currentProgress.completedUnitCount = frameCount
                    progress(CGFloat(Double(frameCount) / Double(currentProgress) ) )
                   
                    }
                    
                    videoWriterInput.markAsFinished()
                    videoWriter.finishWritingWithCompletionHandler { () -> Void in
                        if error == nil {
                            success(videoOutputURL)
                        }
                        
                        self.videoWriter = nil
                    }
                })
            } else {
                error = NSError(
                    domain: kErrorDomain,
                    code: kFailedToStartAssetWriterError,
                    userInfo: ["description": "AVAssetWriter failed to start writing"]
                )
            }
        }
        
        if let error = error {
            failure(error)
        }
    }
    
    func appendPixelBufferForImageAtURL(url: String, pixelBufferAdaptor: AVAssetWriterInputPixelBufferAdaptor, presentationTime: CMTime) -> Bool {
        var appendSucceeded = false
        
        autoreleasepool {
            if let url = NSURL(string: url),
                let imageData = NSData(contentsOfURL: url),
                let image = UIImage(data: imageData) ,
                let pixelBufferPool = pixelBufferAdaptor.pixelBufferPool {
                    let pixelBufferPointer = UnsafeMutablePointer<CVPixelBuffer?>.alloc(1)
                    let status: CVReturn = CVPixelBufferPoolCreatePixelBuffer(
                        kCFAllocatorDefault,
                        pixelBufferPool,
                        pixelBufferPointer
                    )
                    
                    if let pixelBuffer = pixelBufferPointer.memory where status == 0 {
                        fillPixelBufferFromImage(image.fixOrientation(), pixelBuffer: pixelBuffer)
                        
                        appendSucceeded = pixelBufferAdaptor.appendPixelBuffer(
                            pixelBuffer,
                            withPresentationTime: presentationTime
                        )
                        
                        pixelBufferPointer.destroy()
                    } else {
                        NSLog("error: Failed to allocate pixel buffer from pool")
                    }
                    
                    pixelBufferPointer.dealloc(1)
            }
        }
        print("append  \(appendSucceeded)")
        return appendSucceeded
    }
    
    func fillPixelBufferFromImage(image: UIImage, pixelBuffer: CVPixelBufferRef) {
        CVPixelBufferLockBaseAddress(pixelBuffer, 0)
        
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer)
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        
        let context = CGBitmapContextCreate(
            pixelData,
            Int(image.size.width),
            Int(image.size.height),
            8,
            CVPixelBufferGetBytesPerRow(pixelBuffer),
            rgbColorSpace,
            CGImageAlphaInfo.PremultipliedFirst.rawValue
        )
        
        CGContextDrawImage(context, CGRectMake(0, 0, image.size.width, image.size.height), image.CGImage)
        
        CVPixelBufferUnlockBaseAddress(pixelBuffer, 0)
    }
}