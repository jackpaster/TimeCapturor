//
//  ViewController.swift
//  TimeCapturor
//
//  Created by YangTengfei on 12/21/15.
//  Copyright © 2015 TengfeiYang. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBAction func btnTakingPhoto(sender: UIButton) {
        if (UIImagePickerController.isSourceTypeAvailable(.Camera))
        {
            if UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) != nil
            {
                let imagePicker = UIImagePickerController()
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .Camera
                imagePicker.cameraDevice = UIImagePickerControllerCameraDevice.Front
                imagePicker.cameraCaptureMode = .Photo
                presentViewController(imagePicker, animated: true, completion: nil)
            }
            else
            {
                print("Rear camera doesn't exist")
            }
        }
        else
        {
            //print("\(ImageData[1])")
            print("Camera inaccessable")
        }
        
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ImageData = getAllImage()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
         ImageData = getAllImage()
        collectionView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    let lableData = ["1","2","3","4","5","6","7","8","9","10"]
    var ImageData=[UIImage]()
    
    func getAllImage()->[UIImage]
    {
        
        var images = [UIImage]()
        let filManager = NSFileManager()
        
        if let docsDir = filManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first as NSURL!
        {
        do {
             print("\(docsDir.path)")
           // print("\(filManager.fileExistsAtPath(docsDir.absoluteString) )")
            //try filManager.createDirectoryAtPath(docsDir.path!, withIntermediateDirectories: true, attributes: nil)
            //print("\(filManager.fileExistsAtPath(docsDir.absoluteString) )")
            let items =  try filManager.contentsOfDirectoryAtPath(docsDir.path!)
             print("item number \(items.count)")
            for item in items
                {
                    print("before select item \(item)")
                    if item.hasSuffix(".jpg")
                    {
                        print("selected item \(docsDir)\(item)")
                        //let test = NSURL(string: item)
                        let itemOp = docsDir.absoluteString+item
                        print(itemOp)
                        if let imageData = NSData(contentsOfURL: NSURL(string: itemOp)!)
                        {
                            //var imageData = UIImageJPEGRepresentation(item, 1.0)
                            if let uiimageData = UIImage(data: imageData)
                            {
                                images.append(uiimageData)
                            }
                        }
                    }
                }
            }catch  {
                print ("Error: \(error)")
            }
        }
        print("return number \(images.count)")
        return images
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection: Int)->Int{
        print(ImageData.count)
        return ImageData.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath)->UICollectionViewCell{
        let cell: CollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! CollectionViewCell
        print(indexPath.row)
        cell.titleLable?.text = lableData[indexPath.row]
        cell.imageView?.image = ImageData[indexPath.row]

        print("11")
        return cell
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("showImage", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showImage"{
            let indexPaths = self.collectionView!.indexPathsForSelectedItems()!
            let indexPath = indexPaths[0] as NSIndexPath
            let vc = segue.destinationViewController as! NewViewController
            
            vc.image = self.ImageData[indexPath.row]
            vc.title = self.lableData[indexPath.row]
            
        }
    }
    
    
}

