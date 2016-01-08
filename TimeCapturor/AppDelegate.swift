//
//  AppDelegate.swift
//  TimeCapturor
//
//  Created by YangTengfei on 12/21/15.
//  Copyright © 2015 TengfeiYang. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        
        var viewController: UIViewController = UIViewController()
        viewController.view!.backgroundColor = UIColor.greenColor()
        //  Temporary iOS8 fix for 'presentation lag' on launch
        self.window!.addSubview(viewController.view!)
        self.window!.rootViewController!.presentViewController(viewController, animated: false, completion: { _ in })
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let launchTimes = defaults.valueForKey("launchTimes") as? Int
        {
            defaults.setInteger(launchTimes+1, forKey: "launchTimes")
            
        }else{
            defaults.setInteger(1, forKey: "launchTimes")
        }
        
        ShareSDK.registerApp("e460ee2dc4b8", activePlatforms: [ SSDKPlatformType.SubTypeQZone.rawValue ,SSDKPlatformType.TypeFacebook.rawValue,SSDKPlatformType.TypeMail.rawValue,SSDKPlatformType.TypeSMS.rawValue, SSDKPlatformType.TypeQQ.rawValue , SSDKPlatformType.TypeSinaWeibo.rawValue,SSDKPlatformType.TypeWechat.rawValue], onImport: {(platformType: SSDKPlatformType) -> Void in
            switch platformType {
            case SSDKPlatformType.TypeWechat:
                ShareSDKConnector.connectWeChat(WXApi.classForCoder())
                break
            case SSDKPlatformType.TypeQQ:
                ShareSDKConnector.connectQQ(QQApiInterface.classForCoder(), tencentOAuthClass: TencentOAuth.classForCoder())
                break
            case SSDKPlatformType.TypeSinaWeibo:
                ShareSDKConnector.connectWeibo(WeiboSDK.classForCoder())
                break
            default:
                break
            }
            },  onConfiguration: {(platform : SSDKPlatformType,appInfo : NSMutableDictionary!) -> Void in
                switch platform {
                    
                case SSDKPlatformType.TypeSinaWeibo:
                    //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                    appInfo.SSDKSetupSinaWeiboByAppKey("3954647548",
                        appSecret : "0633c28358b81f14bc3ff26a9bfeaed3",
                        redirectUri : "http://www.sharesdk.cn",
                        authType : SSDKAuthTypeBoth)
                    break
                    
                case SSDKPlatformType.TypeWechat:
                    //设置微信应用信息
                    appInfo.SSDKSetupWeChatByAppId("wx8c1bfe6751c32d4d", appSecret: "7e8d51cc5d4154d3fe51fb0ea3738efc")
                    break
                case SSDKPlatformType.TypeQQ:
                    appInfo.SSDKSetupQQByAppId("1105013379", appKey: "k2F5ppN68zcXUxbi", authType: SSDKAuthTypeBoth)
                    break
                    
                case SSDKPlatformType.TypeFacebook:
                    //设置Facebook应用信息，其中authType设置为只用SSO形式授权
                    appInfo.SSDKSetupFacebookByApiKey("1072947386089573", appSecret: "8e1448c7440e759fe3c86920c65fa7ec", authType: SSDKAuthTypeBoth)
                    
                    break
                    
                    
                default:
                    break
                    
                }
        })

        
        
        
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

