//
//  SelfViewController.swift
//  TimeCapturor
//
//  Created by YangTengfei on 1/5/16.
//  Copyright © 2016 TengfeiYang. All rights reserved.
//

import UIKit

class SelfViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let barChart = PNBarChart()    // initWithFrame:CGRectMake(0, 135.0, SCREEN_WIDTH, 200.0)];
        [barChart setXLabels:@[@"SEP 1",@"SEP 2",@"SEP 3",@"SEP 4",@"SEP 5"]];
        [barChart setYValues:@[@1,  @10, @2, @6, @3]];
        [barChart strokeChart];
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
