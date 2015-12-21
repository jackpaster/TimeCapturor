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
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    let lableData = ["1","2","3","4"]
    let ImageData = [UIImage(named: "1"),UIImage(named: "2"),UIImage(named: "3"),UIImage(named: "4")]
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection: Int)->Int{
        return lableData.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath)->UICollectionViewCell{
        let cell: CollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! CollectionViewCell
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
            vc.image = self.ImageData[indexPath.row]!
            vc.title = self.lableData[indexPath.row]
        }
    }


}

