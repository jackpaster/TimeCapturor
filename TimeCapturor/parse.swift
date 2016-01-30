//
//  parse.swift
//  TimeCapturor
//
//  Created by YangTengfei on 1/21/16.
//  Copyright © 2016 TengfeiYang. All rights reserved.
//

import Foundation
import UIKit
import AVKit
import Parse
import MediaPlayer
import AssetsLibrary


class parseFileManager{
    
    let videoID = "video_" + UIDevice.currentDevice().identifierForVendor!.UUIDString + ".mov"
    let imageID = "image_" + UIDevice.currentDevice().identifierForVendor!.UUIDString + ".jpg"
   
    func deleteVideo(){
        let query = PFQuery(className:"Video")
        query.whereKey("videoName", equalTo:videoID)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) scores.")
                // Do something with the found objects
                if let objects = objects {
                    for object in objects {
                        let videoFile = object["VideoFile"] as! PFFile
                        print(videoFile.url)
                        object.deleteInBackground()
                    }
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }
    
    func uplaodImage(imageURL:NSURL){
        let videoOriginal = NSData(contentsOfURL: imageURL)
        let file = PFFile(name:imageID, data:videoOriginal!)
        file!.saveInBackgroundWithBlock({
            (succeeded: Bool, error: NSError?) -> Void in
            // Handle success or failure here ...
            }, progressBlock: {
                (percentDone: Int32) -> Void in
                // Update your progress spinner here. percentDone will be between 0 and 100.
        })
        
        let video = PFObject(className:"Image")
        video["imageName"] = imageID
        video["imageFile"] = file
        video.saveInBackground()
    }

    func uplaodVideo(videoURL:NSURL) {
        //let bundleURL = NSBundle.mainBundle().bundleURL
        //let dataFolderURL = bundleURL.URLByAppendingPathComponent("data")
        //let fileURL = bundleURL.URLByAppendingPathComponent("testVideo.mov")
        
        let videoOriginal = NSData(contentsOfURL: videoURL)
        let file = PFFile(name:videoID, data:videoOriginal!)
        file!.saveInBackgroundWithBlock({
            (succeeded: Bool, error: NSError?) -> Void in
            // Handle success or failure here ...
            }, progressBlock: {
                (percentDone: Int32) -> Void in
                
           // Update your progress spinner here. percentDone will be between 0 and 100.
        })

        
        let video = PFObject(className:"Video")
        video["videoName"] = videoID
        video["VideoFile"] = file
        video.saveInBackground()
        
    }
    
    func Retrive(videoURLOut: (String? -> Void) ) {
        //let videoGetter = PFObject(className:"video")
        //let videofile = video["VideoFile"] as! PFFile
        //video["VideoFile"]
        //let videoData = try! video.getData()
        //v = NSURL(string: videofile.url!)!
     //   mergeAndSave()
        print(UIDevice.currentDevice().identifierForVendor!.UUIDString)
        var videoURL:String? = nil
        let query = PFQuery(className:"UplaodedVideo")
        query.whereKey("videoName", equalTo:videoID)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) scores.")
                // Do something with the found objects
                if let objects = objects {
                    for object in objects {
                        let videoFile = object["VideoFile"] as! PFFile
                        //print(videoFile.url)
                        videoURL = videoFile.url
                       // self.videoURL = NSURL(string: videoFile.url!)!
                        //print(self.videoURL)
                        videoURLOut(videoURL)
                    }
                }
            } else {
                // Log details of the failure
                videoURLOut(videoURL)
                print("Error: \(error!) \(error!.userInfo)")
            }
            
            
        }

    }
    
    
    
    



    
}
