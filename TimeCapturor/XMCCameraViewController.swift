
import UIKit
import AVFoundation
import CoreFoundation
import ImageIO

enum Status: Int {
    case Preview, Still, Error
}

class XMCCameraViewController: UIViewController, XMCCameraDelegate {
    
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!

    
   
    
    @IBOutlet weak var cameraStill: UIImageView!
    @IBOutlet weak var cameraPreview: UIView!
    //@IBOutlet weak var cameraStatus: UILabel!
   // @IBOutlet weak var cameraCapture: UIButton!
    //@IBOutlet weak var cameraCaptureShadow: UILabel!
    let Cancle = UIButton(type: UIButtonType.System) as UIButton
    let captureButton: DKCircleButton = DKCircleButton(frame: CGRectMake(0, 0, 70, 70))
    var baseLines : UIImageView!
    var preview: AVCaptureVideoPreviewLayer?
    
    var camera: XMCCamera?
    var status: Status = .Preview
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeCamera()
        
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: .Fade)

        
        screenSize = UIScreen.mainScreen().bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        
    baseLines = UIImageView(frame: CGRectMake(0, 0, screenWidth, screenHeight))

        UIGraphicsBeginImageContextWithOptions(CGSize(width: screenWidth, height: screenHeight), false, 0)
        let context = UIGraphicsGetCurrentContext()
        
        let points = [ CGPoint(x: screenWidth/6,y: screenHeight/5),
            CGPoint(x: screenWidth/3 , y: screenHeight/5*2),
            CGPoint(x: screenWidth/6 * 4, y: screenHeight/5*2),
            CGPoint(x: screenWidth/6*5, y: screenHeight/5),
            CGPoint(x: screenWidth/2, y: 50),
            CGPoint(x: screenWidth/2, y: screenHeight-150)]
        
        CGContextMoveToPoint( context, points[0].x, points[0].y)
        CGContextAddLineToPoint(context,points[3].x,points[3].y)
        
        CGContextMoveToPoint( context, points[1].x, points[1].y)
        CGContextAddLineToPoint(context,points[2].x,points[2].y)
        
        CGContextMoveToPoint( context, points[4].x, points[4].y)
        CGContextAddLineToPoint(context,points[5].x,points[5].y)
        
        
        CGContextSetStrokeColorWithColor(context, UIColor.whiteColor().CGColor)
        CGContextStrokePath(context)
        
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //view.addSubview(UIImage)
        baseLines.image = img
        
        view.addSubview(baseLines)

        
        
        Cancle.frame = CGRect(x: screenSize.width/2 - 130, y: screenSize.height - 95, width: 80, height: 50)
        Cancle.titleLabel?.font = UIFont(name: (Cancle.titleLabel?.font?.fontName)! , size: 18)
        Cancle.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        Cancle.addTarget(self, action: "btnCancel:", forControlEvents: UIControlEvents.TouchUpInside)
        self.Cancle.setTitle("Return", forState: UIControlState.Normal)

        captureButton.center = CGPointMake(screenSize.width/2, screenSize.height - 70)
        captureButton.titleLabel!.font = UIFont.systemFontOfSize(22)
        captureButton.animateTap = true
        captureButton.displayShading = true
       // button1.setImage(UIImage(named: "ic_camera"),animated: true)
        captureButton.addTarget(self, action: "captureFrame:", forControlEvents: UIControlEvents.TouchUpInside)
        
        view.addSubview(Cancle)
        view.addSubview(captureButton)
        
        
    }
    
    func btnCancel(sender: UIButton) {
        
        if self.status == .Preview {
            self.navigationController?.navigationBarHidden = false
            self.dismissViewControllerAnimated(true, completion: nil)
            
        } else if self.status == .Still{
            
            UIView.animateWithDuration(0.225, animations: { () -> Void in
                self.cameraStill.alpha = 0.0;
               // self.cameraStatus.alpha = 0.0;
                self.baseLines.alpha = 1
                self.cameraPreview.alpha = 1.0;
                self.Cancle.setTitle("Return", forState: UIControlState.Normal)
                self.captureButton.setImage(nil, animated: false)
                }, completion: { (done) -> Void in
                    self.cameraStill.image = nil;
                    self.status = .Preview
            })
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBarHidden = true
        self.establishVideoPreviewArea()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.sharedApplication().statusBarHidden = false
    }
    
    
    func initializeCamera() {
    //    self.cameraStatus.text = "Starting Camera"
        self.camera = XMCCamera(sender: self)
    }
    
    func establishVideoPreviewArea() {
        self.preview = AVCaptureVideoPreviewLayer(session: self.camera?.session)
        self.preview?.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.preview?.frame = self.cameraPreview.bounds
        self.preview?.cornerRadius = 8.0
        self.cameraPreview.layer.addSublayer(self.preview!)
    }
    
    // MARK: Button Actions
    
    func captureFrame(sender: AnyObject) {
        if self.status == .Preview {
          //  self.cameraStatus.text = "Capturing Photo"
            
            UIView.animateWithDuration(0.225, animations: { () -> Void in
                self.cameraPreview.alpha = 0.0;
                self.baseLines.alpha = 0.0
           //     self.cameraStatus.alpha = 1.0
            })
            
            self.camera?.captureStillImage({ (image) -> Void in
                if image != nil {
                    self.cameraStill.image = image;
                     //self.captureButton.setTitle("⤓", forState: UIControlState.Normal)
                    //self.captureButton.setTitleColor(UIColor.greenColor(), forState: UIControlState.Normal)
                    //self.captureButton.tintColor = UIColor.whiteColor()
                   
                    UIView.animateWithDuration(0.225, animations: { () -> Void in
                        self.cameraStill.alpha = 1.0;
             //           self.cameraStatus.alpha = 0.0;
                    })
                    self.status = .Still
                } else {
           //         self.cameraStatus.text = "Uh oh! Something went wrong. Try it again."
                    self.status = .Error
                }
                self.Cancle.setTitle("Cancel", forState: UIControlState.Normal)
                 self.captureButton.setImage(UIImage(named: "ic_save"), animated: false)
            })
        } else if self.status == .Still || self.status == .Error {
            if !saveImageToSandBox() {
                print("save image false")
            }else{
                self.navigationController?.navigationBarHidden = false
                self.dismissViewControllerAnimated(true, completion: nil)
                
//                UIView.animateWithDuration(0.225, animations: { () -> Void in
//                    self.cameraStill.alpha = 0.0;
//               //     self.cameraStatus.alpha = 0.0;
//                    self.cameraPreview.alpha = 1.0;
//                    self.Cancle.setTitle("Return", forState: UIControlState.Normal)
//                     self.captureButton.setImage(nil, animated: false)
//                    }, completion: { (done) -> Void in
//                        self.cameraStill.image = nil;
//                        self.status = .Preview
//                })

            }
        }
    }
    
    func saveImageToSandBox() -> Bool{
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if var WeekCountDic = defaults.dictionaryForKey("WeekCountDic") as? [String:String]
        {
            let cal = NSCalendar.currentCalendar()
            let date = cal.startOfDayForDate(NSDate())
            let CurrentWeekday = String(cal.component(.Weekday, fromDate: date))
            //print(WeekCountDic[CurrentWeekday]!)
            let count = (WeekCountDic[CurrentWeekday]! as NSString).intValue
            print(count)
            WeekCountDic[CurrentWeekday] = String(Int(count) + 1)
            print(WeekCountDic[CurrentWeekday])
            defaults.setObject(WeekCountDic, forKey: "WeekCountDic")
        }
        
        if let _ = defaults.valueForKey("firstMoment"){
            
        }else{
            let formatter = NSDateFormatter()
            formatter.dateFormat = "HH:mm:ss MMMM/dd/yyyy"
            let currentDate = formatter.stringFromDate(NSDate())
            defaults.setValue(currentDate, forKey: "firstMoment")
            print(currentDate)
        }
        
        if let image = self.cameraStill.image?.fixOrientation()
        {
            if let imageData = UIImageJPEGRepresentation(image, 0.5)
            {
                let filManager = NSFileManager()
                if let docsDir = filManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first as NSURL!
                {
                    let unique = NSDate.timeIntervalSinceReferenceDate()
                   // print(unique)//472587882.953091
                  //  let unique2 = NSDate(timeIntervalSinceReferenceDate: unique).description as NSString
                  //  print(unique2)//2015-12-23 18:24:42 +0000
                 //   let range = unique2.rangeOfString(" ")
                 //   print(range)//10 1
                  //  let r = NSMakeRange(0, range.location)
                   // let s = unique2.substringWithRange(r)
                 //   print(s)
                    let url = docsDir.URLByAppendingPathComponent("\(unique).jpg")
                    // if let path = url.absoluteString as? String{
                    dispatch_async(dispatch_get_main_queue(), {() -> Void in
                        parseFileManager().uplaodImage(url)
                        })
                    if imageData.writeToURL(url, atomically: true)
                    {
                       // print(url.absoluteString)
                       // getEXIF(url)
                        return true
                    }
                    
                    // }
                    
                }
            }
        }
        return false
    }
    
        // MARK: Camera Delegate
        
        func cameraSessionConfigurationDidComplete() {
            self.camera?.startCamera()
        }
        
        func cameraSessionDidBegin() {
         //   self.cameraStatus.text = ""
            UIView.animateWithDuration(0.225, animations: { () -> Void in
           //     self.cameraStatus.alpha = 0.0
                self.cameraPreview.alpha = 1.0
            })
        }
        
        func cameraSessionDidStop() {
     //       self.cameraStatus.text = "Camera Stopped"
            UIView.animateWithDuration(0.225, animations: { () -> Void in
        //        self.cameraStatus.alpha = 1.0
                self.cameraPreview.alpha = 0.0
            })
        }
    
    func getEXIF(url:NSURL){
    //var  myImageSofunvurce:CGImageSource
    let myImageSource = CGImageSourceCreateWithURL(url, nil)
    //let ns = NSDictionary()
    let imageProperties = (CGImageSourceCopyPropertiesAtIndex(myImageSource!,0,nil))! as Dictionary

    print(imageProperties)
    }
    
}

