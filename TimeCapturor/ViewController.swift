//
//  ViewController.swift
//  TimeCapturor
//
//  Created by YangTengfei on 12/21/15.
//  Copyright © 2015 TengfeiYang. All rights reserved.
//

import UIKit
//import Photos
import LiquidFloatingActionButton

class ViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UIImagePickerControllerDelegate,UIViewControllerTransitioningDelegate,UINavigationControllerDelegate,LiquidFloatingActionButtonDataSource,LiquidFloatingActionButtonDelegate,UIGestureRecognizerDelegate,KPTimePickerDelegate{
    
    
    var timePicker = KPTimePicker()
    
    @IBOutlet weak var setTimeButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    var longPressGestureRecognizer = UILongPressGestureRecognizer()
    var panRecognizer = UIPanGestureRecognizer()
    
    func timePicker(timePicker: KPTimePicker!, selectedDate date: NSDate!, switchButton: Bool) {
        // NSLog(switchButton ? "Yes" : "No")
        print(switchButton)
        self.show(false, timePickerAnimated: true)
        if date != nil {
            let dateFormatter: NSDateFormatter = NSDateFormatter()
            dateFormatter.locale = NSLocale.currentLocale()
            dateFormatter.dateStyle = .NoStyle
            dateFormatter.timeStyle = .ShortStyle
            //self.statusLabel.text = dateFormatter.stringFromDate(date).lowercaseString
            print(dateFormatter.stringFromDate(date).lowercaseString)
        }
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if otherGestureRecognizer.isEqual(self.panRecognizer){
            return false
        }
        return true
    }
    
    func longPressRecognized(sender: UILongPressGestureRecognizer) {
        if sender.state == .Began {
            self.show(true, timePickerAnimated: true)
        }
    }
    
    func panRecognized(sender: UIPanGestureRecognizer) {
        
        self.timePicker.forwardGesture(sender)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    func show(show: Bool, timePickerAnimated animated: Bool) {
        if show {
            self.navigationController?.hidesBarsOnSwipe = false
            
            self.timePicker.pickingDate = NSDate()
            self.view!.addSubview(self.timePicker)
            
            self.timePicker.alpha = 0.0
            UIView.animateWithDuration(0.4,
                animations: {
                    self.navigationController?.navigationBarHidden = true
                    self.timePicker.alpha = 1.0
                }, completion: nil)
            
        }
        else {
            self.navigationController?.hidesBarsOnSwipe = true

            self.timePicker.alpha = 1
            UIView.animateWithDuration(0.4,
                animations: {
                    self.timePicker.alpha = 0
                    self.navigationController?.navigationBarHidden = false
                }, completion: {_ in                     
                 self.timePicker.removeFromSuperview()})

            
            
        }
    }

    
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var toolBar: UIToolbar!
    var collectionView: UICollectionView!
    var selectedCell: CollectionViewCell?
    
//    @IBOutlet var tapView: UIView?{
//        didSet{
//            let recognizer =  UITapGestureRecognizer(target: self, action: "Tap")
//            tapView?.addGestureRecognizer(recognizer)
//        }
//    }
//    
//    func Tap(gesture :UIGestureRecognizer){
//        print("www")
//    }
    
    var cells: [LiquidFloatingCell] = []
    var floatingActionButton: LiquidFloatingActionButton!
    
    @IBOutlet weak var cameraButton: UIButton!
    
    func numberOfCells(liquidFloatingActionButton: LiquidFloatingActionButton) -> Int {
        return cells.count
    }
    
    func cellForIndex(index: Int) -> LiquidFloatingCell {
        return cells[index]
    }
    
    func liquidFloatingActionButton(liquidFloatingActionButton: LiquidFloatingActionButton, didSelectItemAtIndex index: Int) {
        print("did Tapped! \(index)")
        switch index {
        case 0:
           
             self.show(true, timePickerAnimated: true)
           // performSegueWithIdentifier("reminder", sender: nil)
            break
        case 1:
            
            performSegueWithIdentifier("store", sender: nil)
            break
        case 2:
            
            performSegueWithIdentifier("info", sender: nil)
            break
        case 3:
            
            performSegueWithIdentifier("video", sender: nil)
            break
        case 4:
            
            
            performSegueWithIdentifier("gif", sender: nil)
            break
        case 5:
            
            
            performSegueWithIdentifier("setting", sender: nil)
            break
            
            
        default:break
        }
        liquidFloatingActionButton.close()
    }
    
    var buttonLeft = LiquidFloatingActionButton()
    var buttonRight = LiquidFloatingActionButton()
    

    func createButton() ->(buttonLeft:LiquidFloatingActionButton,buttonRight:LiquidFloatingActionButton){
        let createButton: (CGRect, LiquidFloatingActionButtonAnimateStyle) -> LiquidFloatingActionButton = { (frame, style) in
            let floatingActionButton = LiquidFloatingActionButton(frame: frame)
            floatingActionButton.animateStyle = style
            floatingActionButton.color = UIColor(red: 231 / 255.0, green: 76 / 255.0, blue: 60 / 255.0, alpha: 1.0)
            floatingActionButton.dataSource = self
            floatingActionButton.delegate = self
            return floatingActionButton
        }
        
        let cellFactory: (String) -> LiquidFloatingCell = { (iconName) in
            return LiquidFloatingCell(icon: UIImage(named: iconName)!)
        }
        cells.append(cellFactory("ic_reminder"))
        cells.append(cellFactory("ic_share"))
        cells.append(cellFactory("ic_info"))
        cells.append(cellFactory("ic_mp4"))
        cells.append(cellFactory("ic_gif"))
        cells.append(cellFactory("ic_setting"))
       //let x = (self.view.frame.width/2 - self.cameraButton.frame.width/2-self.view.frame.width - 56)
        let floatingFrame = CGRect(x: self.view.frame.width - 56 - 25 , y: self.view.frame.height - 56 - 16, width: 56, height: 56)
        let bottomRightButton = createButton(floatingFrame, .Up)
        
        let floatingFrame2 = CGRect(x: 25 , y: self.view.frame.height - 56 - 16, width: 56, height: 56)
        let bottomLeftButton = createButton(floatingFrame2, .Up)
        
       // buttonLeft = bottomLeftButton
        //buttonRight = bottomRightButton
       bottomRightButton.identifier = "button1"
        
         //self.view.addSubview(bottomRightButton)
         //self.view.addSubview(bottomLeftButton)
        return (bottomLeftButton,bottomRightButton)
    }
    
    
    
    var collectionData = Album()
    
    //    override func viewDidLoad() {
    //        super.viewDidLoad()
    //
    //        // Do any additional setup after loading the view, typically from a nib.
    //    }
    ///////////////////////////////////////////////////////////
    //    var collectionView: UICollectionView?
    
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
   // var navBar:UINavigationBar=UINavigationBar()
    
    @IBOutlet weak var SettingButton: UIButton!
    
    func handleTap(sender: UITapGestureRecognizer? = nil) {
        print("left")
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.2 * Double(NSEC_PER_SEC)))
        
        if(buttonRight.isClosed == false){
            buttonRight.close()
            dispatch_after(delayTime, dispatch_get_main_queue()) {
                self.buttonLeft.didTapped()
            }
        }else{
            self.buttonLeft.didTapped()
        }
        
                    
        

    
    }
    func handleTap2(sender: UITapGestureRecognizer? = nil) {
        print("right")
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.2 * Double(NSEC_PER_SEC)))
        
        if(buttonLeft.isClosed == false){
            buttonLeft.close()
            dispatch_after(delayTime, dispatch_get_main_queue()) {
                self.buttonRight.didTapped()
            }
        }else{
            self.buttonRight.didTapped()
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.respondsToSelector("setNeedsStatusBarAppearanceUpdate") {
            self.setNeedsStatusBarAppearanceUpdate()
        }
        //self.view.backgroundColor = UIColor(red: 36, green: 40, blue: 46, alpha: 1)
       // self.setTimeButton.layer.cornerRadius = 10
       // self.setTimeButton.layer.borderColor = UIColor.whiteColor().CGColor
       // self.setTimeButton.layer.borderWidth = 2
        self.timePicker = KPTimePicker(frame: self.view.bounds)
        self.timePicker.delegate = self
        self.timePicker.minimumDate = self.timePicker.pickingDate.dateAtStartOfDay()
        self.timePicker.maximumDate = self.timePicker.pickingDate.dateByAddingMinutes((60 * 24)).dateAtStartOfDay().dateBySubtractingMinutes(5)
        self.longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: "longPressRecognized:")
        self.longPressGestureRecognizer.allowableMovement = 44.0
        self.longPressGestureRecognizer.delegate = self
        self.longPressGestureRecognizer.minimumPressDuration = 0.6
      //  self.setTimeButton.addGestureRecognizer(self.longPressGestureRecognizer)
        self.panRecognizer = UIPanGestureRecognizer(target: self, action: "panRecognized:")
        

        
        
        
        cameraButton.layer.shadowColor = UIColor.blackColor().CGColor
        cameraButton.layer.shadowOffset = CGSizeMake(4, 4)
        cameraButton.layer.shadowRadius = 2
        cameraButton.layer.shadowOpacity = 0.5
        cameraButton.layer.masksToBounds = false
        
        navigationController?.navigationBar.layer.shadowColor = UIColor.blackColor().CGColor
        navigationController?.navigationBar.layer.shadowOffset = CGSizeMake(0, 4)
        navigationController?.navigationBar.layer.shadowRadius = 2
        navigationController?.navigationBar.layer.shadowOpacity = 0.5
        navigationController?.navigationBar.layer.masksToBounds = false
        

        
//        var attachment = NSTextAttachment()
//        attachment.image = UIImage(named: "ic_camera")
//        var attachmentString = NSAttributedString(attachment: attachment)
//        var myString = NSMutableAttributedString(string: "")
//        myString.appendAttributedString(attachmentString)
        //lable.setattribute = attachmenrstring
        
        cameraButton.setImage(UIImage(named: "ic_camera"), forState: .Normal)
        cameraButton.centerLabelVerticallyWithPadding(1)
        
        cameraButton.backgroundColor = UIColor(red: 240 / 255.0, green: 76 / 255.0, blue: 60 / 255.0, alpha: 1.0)//rgb(44, 62, 80)
        cameraButton.layer.cornerRadius = 28
        //cameraButton.layer.borderWidth = 1
        //cameraButton.layer.borderColor = UIColor.blackColor().CGColor
        
        screenSize = UIScreen.mainScreen().bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        
        toolBar.setBackgroundImage(UIImage(), forToolbarPosition: UIBarPosition.Any, barMetrics: UIBarMetrics.Default)
        toolBar.setShadowImage(UIImage(),forToolbarPosition: UIBarPosition.Any)
        
        //    .setBackgroundImage (UIImage(),forToolbarPosition: UIBarPosition.Any,
        //    barMetrics: UIBarMetrics.Default)
        //    self.toolbar.setShadowImage(UIImage(),
        //    forToolbarPosition: UIBarPosition.Any)
        
        // self.collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: MyFlowLayout())
        let statusHeight = UIApplication.sharedApplication().statusBarFrame.size.height
        let statusView = UIView(frame:
            CGRect(x: 0.0, y: 0.0, width: UIScreen.mainScreen().bounds.size.width, height:statusHeight) )
        //statusView.backgroundColor = UIColor.whiteColor()
        // statusView.backgroundColor = UIColor.redColor()
        
        // 1  add blur
       // let darkBlur = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        // 2
       // let blurView = UIVisualEffectView(effect: darkBlur)
       // blurView.frame = statusView.bounds
        // 3
        //statusView.addSubview(blurView)rgb(231, 76, 60)rgb(192, 57, 43)
     
        statusView.backgroundColor = UIColor(red: 231 / 255.0, green: 76 / 255.0, blue: 60 / 255.0, alpha: 0.97)

        
       // self.view.addSubview(statusBackView)
        
        
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        // UIApplication.sharedApplication().statusBarStyle = .BlackOpaque
        //UIApplication.sharedApplication()
        
        // change title color and drop the shadow like it's hot
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.blackColor();
        shadow.shadowOffset = CGSizeMake(1,2);
        UINavigationBar.appearance().titleTextAttributes = NSDictionary(objects: [UIColor.whiteColor(), shadow], forKeys: [NSForegroundColorAttributeName, NSShadowAttributeName]) as? [String : AnyObject];
        
        let border = CALayer()
        let width = CGFloat(0.6)
        border.borderColor = UIColor.darkGrayColor().CGColor
        border.frame = CGRect(x: 0, y: statusHeight, width:  screenWidth, height: 0.6)
        
        border.borderWidth = width
        //statusView.layer.addSublayer(border)
        //statusView.layer.masksToBounds = true
        
        
        
         navigationController?.navigationBar.barTintColor = UIColor(red: 240 / 255.0, green: 76 / 255.0, blue: 60 / 255.0, alpha: 1.0)
        
        // self.navigationController?.navigationBar.translucent = true192
        
        
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 3, left: 4, bottom: 75, right: 4)
        //layout.itemSize = CGSize(width: 150, height: 150)
        //  print("screen width \(self.collectionView.frame)")
        // print("view width \(self.view.frame)")
        //print(screenWidth)
        // print(screenHeight)
        //self.collectionView.frame = self.view.frame
        layout.itemSize = CGSize(width: (screenWidth-14) / 3, height: (screenWidth-14) / 3)
        layout.minimumInteritemSpacing = 3
        layout.minimumLineSpacing = 3
        
        //let margins = view.layoutMarginsGuide
        //self.collectionView.setTranslatesAutoresizingMaskIntoConstraints(false)
        // create the constraints with the constant value you want.
        
        
        
        let size = CGSize(width: view.frame.width, height: view.frame.height)
        //let frame = CGRect(origin: CGPoint(x: 0.0, y: statusHeight+0.6), size: size)
        let frame = CGRect(origin: CGPoint(x: 0, y: 0), size: size)
        
        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView!.dataSource = self
        collectionView!.delegate = self
        collectionView!.registerClass(CollectionViewCell.self, forCellWithReuseIdentifier: "cell")//rgb(29, 78, 111)
        //collectionView.backgroundColor = UIColor(red: 52 / 255.0, green: 73 / 255.0, blue: 94 / 255.0, alpha: 1)
        collectionView.backgroundColor = UIColor(red: 29 / 255.0, green: 78 / 255.0, blue: 111 / 255.0, alpha: 1)
        //collectionView.leadingAnchor.constraintEqualToAnchor(margins.leadingAnchor).active = true
        //rgb(149, 165, 166)rgb(52, 73, 94)rgb(127, 140, 141)
        //collectionView.setCollectionViewLayout(layout, animated: false)
        navigationController?.navigationBar.tintAdjustmentMode = .Normal
        //navigationController?.navigationBar.barTintColor = [UIColor blackColor];
        navigationController?.navigationBar.translucent = true
        
        //navBar.frame=CGRectMake(0, 0, screenWidth, 50)
        //navBar.backgroundColor=(UIColor .blackColor())
        
        let bar:UINavigationBar! =  self.navigationController?.navigationBar
        
        bar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        bar.shadowImage = UIImage()
        bar.backgroundColor = UIColor(red: 231 / 255.0, green: 76 / 255.0, blue: 60 / 255.0, alpha: 0.97)
        //bar.frame.origin.y = -50
        //bar.frame = CGRect(x: bar.frame.origin.x , y: bar.frame.origin.y-20, width: bar.frame.size.width, height: bar.frame.size.height)
        self.view.addSubview(collectionView!)
        self.view.bringSubviewToFront(toolBar)
        self.view.bringSubviewToFront(bottomView)
        let buttons = createButton()
        buttonLeft = buttons.buttonLeft
        buttonRight = buttons.buttonRight
        

        let tap = UITapGestureRecognizer(target: self, action: Selector("handleTap:"))
        let tap2 = UITapGestureRecognizer(target: self, action: Selector("handleTap2:"))
        // we use our delegate
        tap.delegate = self
        tap2.delegate = self
        // allow for user interaction
       
        // buttonLeft.userInteractionEnabled = true
        //buttonRight.userInteractionEnabled = true
        
        // add tap as a gestureRecognizer to tapView
        
        //buttonLeft.addGestureRecognizer(tap)
        //buttonRight.addGestureRecognizer(tap2)

        
        self.view.addSubview(buttonLeft)
        self.view.addSubview(buttonRight)
        

        self.view.addSubview(statusView)
        
        // an action we'll call "handleTap:"
        
        
       // buttonLeft as UIButton).addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)

        
       
        
    }
    
    
      //self.view.addSubview(collectionView!)
    //
    //        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    //        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
    //        layout.itemSize = CGSize(width: CGFloat(screenWidth / 3), height: CGFloat(screenWidth / 3))
    //        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
    //        print(collectionView)
    //        collectionView!.dataSource = self
    //        collectionView!.delegate = self
    //        collectionView!.registerClass(CollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
    //        collectionView!.backgroundColor = UIColor.greenColor()
    //        self.view.addSubview(collectionView!)
    
    
    
    //
    
    //
    //        // Do any additional setup after loading the view, typically from a nib
    //        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    //        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
    //        layout.itemSize = CGSize(width: screenWidth / 3, height: screenWidth / 3)
    //        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
    //
    //        collectionView!.registerClass(CollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
    //        collectionView!.backgroundColor = UIColor.greenColor()
    //        self.view.addSubview(collectionView!)
    override func viewWillDisappear(animated: Bool) {

            super.viewWillDisappear(animated)
            
         //   UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
            self.navigationController?.navigationBarHidden = false
    
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // self.navigationController?.delegate = self
        
        
        
        //navigationController?.hidesBarsOnSwipe = true
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    
        self.navigationController?.hidesBarsOnSwipe = true
        collectionData.updateData()
        collectionView.reloadData()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection: Int)->Int{
        //print(cellData.count)
        return collectionData.cellData.count
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath)->UICollectionViewCell{
        let cell: CollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! CollectionViewCell
        //cell.backgroundColor = UIColor.whiteColor()rgb(189, 195, 199)rgb(44, 62, 80)
         cell.layer.borderColor = UIColor(red: 44 / 255.0, green: 62 / 255.0, blue: 80 / 255.0, alpha: 1).CGColor
        cell.layer.borderWidth = 0.5
       cell.layer.cornerRadius = CGFloat(1.8)
        //cell.frame.size.width = screenWidth / 3
        //cell.frame.size.height = screenWidth / 3
        
        
        
        //cell.layer.borderWidth = 0.5
        
        cell.titleLable?.text = dateGenerating(collectionData.cellData[indexPath.row].lableData)
        cell.imageView?.image = collectionData.cellData[indexPath.row].ImageData
        
        // print("11")
        return cell
        
    }
    
    func dateGenerating(date:NSString)->String{
                        let tempRange = date.rangeOfString(" ")
                       let dateRang = NSMakeRange(0, tempRange.location)
                      var photoDate = date.substringWithRange(dateRang)
        
                    var myDate = photoDate.componentsSeparatedByString("-")
                photoDate = myDate[1]+"/"+myDate[2]+"/"+myDate[0]
        return photoDate
    }
    
    
    //    func animationControllerForPresentedController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    //        if ((toVC as? NewViewController) != nil){
    //            if operation == UINavigationControllerOperation.Push {
    //                print("1")
    //                return MagicMoveTransion()
    //            } else {
    //                print("2")
    //                return nil
    //            }
    //        }else {
    //            print("3")
    //            return FadeAnimator()
    //        }
    //    }
    
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return MagicMoveTransion()
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.selectedCell = collectionView.cellForItemAtIndexPath(indexPath) as? CollectionViewCell
        
        self.performSegueWithIdentifier("showImage", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showImage"{
            let indexPaths = self.collectionView!.indexPathsForSelectedItems()!
            let indexPath = indexPaths[0] as NSIndexPath
            let vc = segue.destinationViewController as! NewViewController
            vc.transitioningDelegate = self
            // vc.image = self.cellData[indexPath.row].ImageData
            
            vc.index = indexPath.item
            //vc.photoCollection = collectionData.getAllImageAndDate().ImageData
            // vc.urlCollection = collectionData.getAllImageAndDate().groupNSURL
            
            //  vc.image = self.selectedCell!.imageView.image!
            //vc.title = self.collectionData.cellData[indexPath.row].lableData
            
        }
    }
    
    
}

