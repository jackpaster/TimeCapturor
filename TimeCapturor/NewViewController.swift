//
//  NewViewController.swift
//  TimeCapturor
//
//  Created by YangTengfei on 12/21/15.
//  Copyright © 2015 TengfeiYang. All rights reserved.
//

import UIKit
//import Photos
let screenWidth = UIScreen.mainScreen().bounds.width
let screenHeight = UIScreen.mainScreen().bounds.height


class NewViewController: UIViewController{
    
    @IBOutlet weak var imageView: UIImageView!
    var imageView2 = UIImageView()
    //var image = UIImage()
    var photoCollection = Album().getAllImageAndDate().ImageData
    var urlCollection = Album().getAllImageAndDate().groupNSURL
    var index: Int = 0
    
    var imagePositionX = CGFloat(0)
    var imagePositionY = CGFloat(0)

    @IBAction func deleteAction(sender: UIButton) {
        
//        let alert = UIAlertController(title: "Delete Image", message: "Are you sure you want to delete this image?", preferredStyle: .Alert)
//        
//        let confirmAction = UIAlertAction(
//            title: "Yes",
//            style: UIAlertActionStyle.Default) { (action) in
//                // ...
//                do{
//                    try NSFileManager().removeItemAtURL(self.urlCollection[self.index])
//                    alert.dismissViewControllerAnimated(true, completion: nil)
//                    
//                   // dispatch_async(dispatch_get_main_queue(), {
//                        // self.index++
//                     self.displayPhoto()
//                    
//                }catch  {
//                    print ("Error: \(error)")
//                }
//
//        }
//        alert.addAction(confirmAction)
//
//        alert.addAction(UIAlertAction(title: "No", style: .Cancel, handler: {(alertAction)in
//            //Do not delete photo
//            alert.dismissViewControllerAnimated(true, completion: nil)
//        }))
//        
//        self.presentViewController(alert, animated: true, completion: nil)
        SweetAlert().showAlert("Are you sure?", subTitle: "You file will permanently delete!", style: AlertStyle.Warning, buttonTitle:"No, cancel it!", buttonColor:UIColor.colorFromRGB(0xD0D0D0) , otherButtonTitle:  "Yes, delete it!", otherButtonColor: UIColor.colorFromRGB(0xDD6B55)) { (isOtherButton) -> Void in
            if isOtherButton == true {
                
                SweetAlert().showAlert("Cancelled!", subTitle: "Your imaginary file is safe", style: AlertStyle.Error)
            }
            else {
    
                do{
                    try NSFileManager().removeItemAtURL(self.urlCollection[self.index])
                    // alert.dismissViewControllerAnimated(true, completion: nil)
                    // SweetAlert().showAlert("Cancelled!", subTitle: "Your imaginary file is safe", style: AlertStyle.Error)
                    // dispatch_async(dispatch_get_main_queue(), {
                    // self.index++
                   
                    self.displayPhoto()
                    
                }catch  {
                    print ("Error: \(error)")
                }
                
            }
        }

        
        
    }
    
    
    func displayPhoto(){
        photoCollection = Album().getAllImageAndDate().ImageData
        urlCollection = Album().getAllImageAndDate().groupNSURL
       // print(index)
        if(photoCollection.count == 0){
            SweetAlert().showAlert("Empty!", subTitle: "Your album is empty", style: AlertStyle.None,buttonTitle: "Return"){ (isOtherButton) -> Void in
                
                     self.dismissViewControllerAnimated(true, completion: nil)
            }

            
        }else{
             SweetAlert().showAlert("Deleted!", subTitle: "Your imaginary file has been deleted!", style: AlertStyle.Success)
            if(index >= photoCollection.count){
                index = photoCollection.count - 1
            }
           
        
        // })
//        //淡出动画
//        UIView.beginAnimations(nil, context: nil)
//        UIView.setAnimationDuration(0.5)
//        imageView.alpha = 0.0
//        UIView.commitAnimations()
        
        
//        UIView.beginAnimations(nil, context: nil)
//        UIView.setAnimationDuration(5)
//        imageView.center = CGPointMake(-screenWidth/2, imagePositionY)
//        imageView.alpha = 0.0
//        UIView.setAnimationCurve(UIViewAnimationCurve.EaseOut) //设置动画相对速度
//        UIView.commitAnimations()
        
        imageView.alpha = 0.7
        imageView.center = CGPointMake(screenWidth/2+20, imagePositionY)
        
        imageView.image = photoCollection[self.index]
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.2)
        imageView.center = CGPointMake(screenWidth/2, imagePositionY )
        imageView.alpha = 1.0
        UIView.setAnimationCurve(UIViewAnimationCurve.EaseOut)
        UIView.commitAnimations()

    
        imageView.image = photoCollection[index]
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = photoCollection[index]
        imagePositionX = imageView.center.x
        imagePositionY = imageView.center.y
        imageView2 = imageView
        // let screenSize: CGSize = UIScreen.mainScreen().bounds.size
        
        
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // self.navigationController?.delegate = self
        
    }
    
    
    @IBAction func `return`(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //
    //    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    //        if operation == UINavigationControllerOperation.Pop {
    //            return MagicMovePopTransion()
    //        } else {
    //            return nil
    //        }
    //    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
