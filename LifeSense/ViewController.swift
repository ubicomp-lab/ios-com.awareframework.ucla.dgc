//
//  ViewController.swift
//  LifeSense
//
//  Created by Yuuki Nishiyama on 2018/03/26.
//  Copyright © 2018 Yuuki Nishiyama. All rights reserved.
//

import UIKit
import AWAREFramework

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let delegate = UIApplication.shared.delegate as! AWAREDelegate
        
        // delegate.sharedAWARECore.sharedLocationManager.requestAlwaysAuthorization()
        delegate.sharedAWARECore.requestBackgroundSensing()
        delegate.sharedAWARECore.requestNotification(UIApplication.shared)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

