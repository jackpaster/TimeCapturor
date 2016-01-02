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
       // var thumbnail: UIImage
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
        
        let size = CGSizeMake(192, 256)
        
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
        
        
        data.sortInPlace({ $0.lableData > $1.lableData })
        //imagesGroupNSURL.sort({ $0 > $1 })
        return (data,imageOnly.reverse(),imagesGroupNSURL.reverse(),imageOnly.count,imageURLString)
        
    }
    
    
    
    
}