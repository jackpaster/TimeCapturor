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


class NewViewController: UIViewController,UINavigationBarDelegate{
    
    @IBOutlet weak var imageView: UIImageView!
    var imageView2 = UIImageView()
    //var image = UIImage()
    var photoCollection = Album().getAllImageAndDate().ImageData
    var urlCollection = Album().getAllImageAndDate().groupNSURL
    var index: Int = 0
    
    var imagePositionX = CGFloat(0)
    var imagePositionY = CGFloat(0)

    @IBAction func deleteAction(sender: UIButton) {
        
        SweetAlert().showAlert("Are you sure?", subTitle: "This image will permanently delete!", style: AlertStyle.Warning, buttonTitle:"No, cancel it!", buttonColor:UIColor.colorFromRGB(0xD0D0D0) , otherButtonTitle:  "Yes, delete it!", otherButtonColor: UIColor.colorFromRGB(0xDD6B55)) { (isOtherButton) -> Void in
            if isOtherButton == true {
                
                SweetAlert().showAlert("Cancelled!", subTitle: "Your file is safe", style: AlertStyle.Error)
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
             SweetAlert().showAlert("Deleted!", subTitle: "The file has been deleted!", style: AlertStyle.Success)
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
        
        
        let statusHeight = UIApplication.sharedApplication().statusBarFrame.size.height
        let statusView = UIView(frame:
            CGRect(x: 0.0, y: 0.0, width: UIScreen.mainScreen().bounds.size.width, height:statusHeight) )
        statusView.backgroundColor = UIColor(red: 231 / 255.0, green: 76 / 255.0, blue: 60 / 255.0, alpha: 1)
        
        self.view.addSubview(statusView)
        
        view.backgroundColor = UIColor(red: 52 / 255.0, green: 73 / 255.0, blue: 94 / 255.0, alpha: 1)
        
        //////////////////////////////////
        
        
        let navigationBar = UINavigationBar(frame: CGRectMake(0, statusView.frame.height, self.view.frame.size.width, 44)) // Offset by 20 pixels vertically to take the status bar into account
        
        //navigationBar.backgroundColor = UIColor.whiteColor()
        navigationBar.delegate = self
        
        // Create a navigation item with a title
        let navigationItem = UINavigationItem()
        navigationItem.title = "Album"
        
       // let bar:UINavigationBar! =  self.navigationController?.navigationBar
        
        navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        navigationBar.shadowImage = UIImage()
        navigationBar.backgroundColor = UIColor(red: 231 / 255.0, green: 76 / 255.0, blue: 60 / 255.0, alpha: 1)
        
        navigationBar.layer.shadowColor = UIColor.blackColor().CGColor
        navigationBar.layer.shadowOffset = CGSizeMake(0, 4)
        navigationBar.layer.shadowRadius = 2
        navigationBar.layer.shadowOpacity = 0.5
        navigationBar.layer.masksToBounds = false
 
        navigationBar.items = [navigationItem]
        
        // Make the navigation bar a subview of the current view controller
        self.view.addSubview(navigationBar)
        
        
        
        
        
        // let screenSize: CGSize = UIScreen.mainScreen().bounds.size
        
        
    }
    
//    func btn_clicked(sender: UIBarButtonItem) {
//        // Do something
//    }
//    
    
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
