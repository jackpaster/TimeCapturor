//
//  AlbumData.swift
//  TimeCapturor
//
//  Created by YangTengfei on 12/23/15.
//  Copyright © 2015 TengfeiYang. All rights reserved.
//

import UIKit

class Album{
    
    init() {
        cellData = getAllImageAndDate().AllData
    }
    
    struct cellContents {
        var lableData: String
        var ImageData: UIImage
    }

    var cellData = [cellContents]()
    
    func updateData(){
        cellData = getAllImageAndDate().AllData
    }
    

    
    func getAllImageAndDate()->(AllData:[cellContents],ImageData:[UIImage],groupNSURL:[NSURL],Number:Int,urlString:[String])
    {
        
        var data = [cellContents]()
        var imageOnly = [UIImage]()
        var imagesGroupNSURL = [NSURL]()
        let filManager = NSFileManager()
        var imageURLString = [String]()
        
        if let docsDir = filManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first as NSURL!
        {
            do {
                //    print("\(docsDir.path)")
                // print("\(filManager.fileExistsAtPath(docsDir.absoluteString) )")
                //try filManager.createDirectoryAtPath(docsDir.path!, withIntermediateDirectories: true, attributes: nil)
                //print("\(filManager.fileExistsAtPath(docsDir.absoluteString) )")
                let items =  try filManager.contentsOfDirectoryAtPath(docsDir.path!)
                // print("item number \(items.count)")
                for item in items
                {
                    //   print("before select item \(item)")
                    if item.hasSuffix(".jpg")
                    {
                        //     print("selected item \(docsDir)\(item)")
                        //let test = NSURL(string: item)
                        
                        // let pathExtention = NSURL(string: item)!.pathExtension
                       
                        let dateData = (NSURL(string: item)!.URLByDeletingPathExtension?.absoluteString)! as NSString
                        let date = NSDate(timeIntervalSinceReferenceDate: dateData.doubleValue).description as NSString
                        let tempRange = date.rangeOfString(" ")
                        let dateRang = NSMakeRange(0, tempRange.location)
                        var photoDate = date.substringWithRange(dateRang)
                        
                        var myDate = photoDate.componentsSeparatedByString("-")
                        photoDate = myDate[1]+"/"+myDate[2]+"/"+myDate[0]
                        
                        let itemOp = docsDir.absoluteString+item
                        //print(itemOp) 
                        imagesGroupNSURL.append(NSURL(string: itemOp)!)
                        imageURLString.append(itemOp)
                        if let imageData = NSData(contentsOfURL: NSURL(string: itemOp)!)
                        {
                            //var imageData = UIImageJPEGRepresentation(item, 1.0)
                            if let uiimageData = UIImage(data: imageData)
                            {
                                imageOnly.append(uiimageData)
                                let cellContent = cellContents(lableData: date as String, ImageData: uiimageData)
                                
                                data.append(cellContent)
                            }
                        }
                        
                    }
                    
                }
               // print(imageOnly.count)
            }catch  {
                print ("Error: \(error)")
            }
        }
        //print("return number \(images.count)")
        data.sortInPlace({ $0.lableData > $1.lableData })
        //imagesGroupNSURL.sort({ $0 > $1 })
        return (data,imageOnly.reverse(),imagesGroupNSURL.reverse(),imageOnly.count,imageURLString)
        
    }
    
    
    
    
}