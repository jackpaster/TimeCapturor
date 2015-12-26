
import UIKit
import AVFoundation

enum Status: Int {
    case Preview, Still, Error
}

class XMCCameraViewController: UIViewController, XMCCameraDelegate {
    
    @IBOutlet weak var cameraStill: UIImageView!
    @IBOutlet weak var cameraPreview: UIView!
    @IBOutlet weak var cameraStatus: UILabel!
    @IBOutlet weak var cameraCapture: UIButton!
    @IBOutlet weak var cameraCaptureShadow: UILabel!
    @IBOutlet weak var Cancle: UIButton!
    var preview: AVCaptureVideoPreviewLayer?
    
    var camera: XMCCamera?
    var status: Status = .Preview
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeCamera()
    }
    
    @IBAction func btnCancel(sender: UIButton) {
        
        if self.status == .Preview {
            self.navigationController?.navigationBarHidden = false
            self.dismissViewControllerAnimated(true, completion: nil)
            
        } else if self.status == .Still{
            
            UIView.animateWithDuration(0.225, animations: { () -> Void in
                self.cameraStill.alpha = 0.0;
                self.cameraStatus.alpha = 0.0;
                self.cameraPreview.alpha = 1.0;
                self.Cancle.setTitle("←Back", forState: UIControlState.Normal)
                self.cameraCapture.setTitle("Capture", forState: UIControlState.Normal)
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
    
    
    func initializeCamera() {
        self.cameraStatus.text = "Starting Camera"
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
    
    @IBAction func captureFrame(sender: AnyObject) {
        if self.status == .Preview {
            self.cameraStatus.text = "Capturing Photo"
            UIView.animateWithDuration(0.225, animations: { () -> Void in
                self.cameraPreview.alpha = 0.0;
                self.cameraStatus.alpha = 1.0
            })
            
            self.camera?.captureStillImage({ (image) -> Void in
                if image != nil {
                    self.cameraStill.image = image;
                    
                    UIView.animateWithDuration(0.225, animations: { () -> Void in
                        self.cameraStill.alpha = 1.0;
                        self.cameraStatus.alpha = 0.0;
                    })
                    self.status = .Still
                } else {
                    self.cameraStatus.text = "Uh oh! Something went wrong. Try it again."
                    self.status = .Error
                }
                self.Cancle.setTitle("X", forState: UIControlState.Normal)
                self.cameraCapture.setTitle("Save", forState: UIControlState.Normal)
            })
        } else if self.status == .Still || self.status == .Error {
            if !saveImageToSandBox() {
                print("save image false")
            }else{
                UIView.animateWithDuration(0.225, animations: { () -> Void in
                    self.cameraStill.alpha = 0.0;
                    self.cameraStatus.alpha = 0.0;
                    self.cameraPreview.alpha = 1.0;
                    self.Cancle.setTitle("←Back", forState: UIControlState.Normal)
                    self.cameraCapture.setTitle("Capture", forState: UIControlState.Normal)
                    }, completion: { (done) -> Void in
                        self.cameraStill.image = nil;
                        self.status = .Preview
                })

            }
        }
    }
    
    func saveImageToSandBox() -> Bool
    {
        if let image = self.cameraStill.image
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
                    if imageData.writeToURL(url, atomically: true)
                    {
                       // print(url.absoluteString)
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
            self.cameraStatus.text = ""
            UIView.animateWithDuration(0.225, animations: { () -> Void in
                self.cameraStatus.alpha = 0.0
                self.cameraPreview.alpha = 1.0
                self.cameraCapture.alpha = 1.0
                self.cameraCaptureShadow.alpha = 0.4;
            })
        }
        
        func cameraSessionDidStop() {
            self.cameraStatus.text = "Camera Stopped"
            UIView.animateWithDuration(0.225, animations: { () -> Void in
                self.cameraStatus.alpha = 1.0
                self.cameraPreview.alpha = 0.0
            })
        }
}

