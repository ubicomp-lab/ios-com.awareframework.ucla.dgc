//
//  AppDelegate.swift
//  LifeSense
//
//  Created by Yuuki Nishiyama on 2018/03/26.
//  Copyright © 2018 Yuuki Nishiyama. All rights reserved.
//

import UIKit
import AWAREFramework

@UIApplicationMain
class AppDelegate: AWAREDelegate {

    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        super.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        let study   = AWAREStudy.shared()
        let manager = AWARESensorManager.shared()
        
        if let study = study, let manager = manager {
            /////// Settings for data synching strategies //////////
            study.setStudyURL("https://api.awareframework.com/index.php/webservice/index/1553/ZDaTuBFymPPF")
            // Aware.setSetting(getApplicationContext(), Aware_Preferences.WEBSERVICE_SILENT, true);
            // Aware.setSetting(getApplicationContext(), Aware_Preferences.WEBSERVICE_WIFI_ONLY, true);
            study.setAutoDBSyncOnlyWifi(true)
            // Aware.setSetting(getApplicationContext(), Aware_Preferences.WEBSERVICE_FALLBACK_NETWORK, 6); //after 6h fallback to 3G sync.
            // Aware.setSetting(getApplicationContext(), Aware_Preferences.REMIND_TO_CHARGE, true);
            study.setAutoDBSyncOnlyBatterChargning(true)
            // Aware.setSetting(getApplicationContext(), Aware_Preferences.FREQUENCY_CLEAN_OLD_DATA, 1); //weekly basis
            study.setCleanOldDataType(cleanOldDataTypeWeekly)
            // Aware.setSetting(getApplicationContext(), Aware_Preferences.FREQUENCY_WEBSERVICE, 60); //every 1h
            study.setAutoDBSyncIntervalWithMinutue(60)
            
//            study.setAutoDBSyncIntervalWithMinutue(1)
//            study.setMaximumNumberOfRecordsForDBSync(10)
            
            // Aware.setSetting(getApplicationContext(), Aware_Preferences.STATUS_SIGNIFICANT_MOTION, true); //we only want to log accelerometer data when there is movement
            // Aware.setSetting(getApplicationContext(), Aware_Preferences.STATUS_ESM, true); //we want to use the ESM functionality of AWARE

            // Aware.setSetting(getApplicationContext(), Aware_Preferences.STATUS_ACCELEROMETER, true);
            // Aware.setSetting(getApplicationContext(), Aware_Preferences.FREQUENCY_ACCELEROMETER, 200 * 1000);
            // Aware.setSetting(getApplicationContext(), Aware_Preferences.THRESHOLD_ACCELEROMETER, 0.01); //changes need to be > 0.01 in each axis to log. Makes sensor less sensitive
            let acceleroemter = Accelerometer.init(awareStudy: study, dbType: AwareDBTypeSQLite)
            acceleroemter?.setSensingIntervalWithSecond(0.2)
            acceleroemter?.startSensor()
            acceleroemter?.threshold = 0.01;
            manager.add(acceleroemter)
            
            
            // Aware.setSetting(getApplicationContext(), Aware_Preferences.STATUS_BAROMETER, true);
            // Aware.setSetting(getApplicationContext(), Aware_Preferences.FREQUENCY_BAROMETER, 200 * 1000);
            // Aware.setSetting(getApplicationContext(), Aware_Preferences.THRESHOLD_BAROMETER, 0.01); //changes need to be > 0.01 in each axis to log. Makes sensor less sensitive
            let barometer = Barometer.init(awareStudy: study, dbType: AwareDBTypeSQLite)
            barometer?.setSensingIntervalWithSecond(0.2)
            barometer?.startSensor()
            manager.add(barometer)
            
            // Aware.setSetting(getApplicationContext(), Aware_Preferences.STATUS_LIGHT, true);
            // Aware.setSetting(getApplicationContext(), Aware_Preferences.FREQUENCY_LIGHT, 200 * 1000);
            // Aware.setSetting(getApplicationContext(), Aware_Preferences.THRESHOLD_LIGHT, 5); //changes need to be > 5 lux to log. Makes sensor less sensitive
            /** NOTE: iOS does not support this sensor */
            
            
            // Activity Recognition settings
            // Aware.setSetting(getApplicationContext(), Settings.STATUS_PLUGIN_GOOGLE_ACTIVITY_RECOGNITION, true);
            //this is actually controlled by Google's algorithm. We want every 10 seconds, but this is not guaranteed. Recommended value is 60 s.
            // Aware.setSetting(getApplicationContext(), Settings.FREQUENCY_PLUGIN_GOOGLE_ACTIVITY_RECOGNITION, 60);
            // Aware.startPlugin(getApplicationContext(), "com.aware.plugin.google.activity_recognition"); //initialise plugin and set as active
            let motion = IOSActivityRecognition.init(awareStudy: study, dbType: AwareDBTypeSQLite)
            motion?.sensingInterval = 60;
            motion?.startSensor()
            
            
            // Aware.setSetting(getApplicationContext(), Aware_Preferences.STATUS_APPLICATIONS, true); //includes usage, and foreground
            /** NOTE: iOS does not support this sensor */

            // Aware.setSetting(getApplicationContext(), Aware_Preferences.STATUS_BATTERY, true);
            let battery = Battery.init(awareStudy: study, dbType: AwareDBTypeSQLite)
            battery?.startSensor()
            manager.add(battery)
            
            // Aware.setSetting(getApplicationContext(), Aware_Preferences.STATUS_COMMUNICATION_EVENTS, true);
            /** NOTE: iOS does not support this sensor */
            
            // Aware.setSetting(getApplicationContext(), Aware_Preferences.STATUS_CALLS, true);
            let call = Calls.init(awareStudy: study, dbType: AwareDBTypeSQLite)
            call?.startSensor()
            manager.add(call)
            
            // Aware.setSetting(getApplicationContext(), Aware_Preferences.STATUS_MESSAGES, true);
            /** NOTE: iOS does not support this sensor */
            
            // Aware.setSetting(getApplicationContext(), Aware_Preferences.STATUS_SCREEN, true);
            let screen = Screen.init(awareStudy: study, dbType: AwareDBTypeSQLite)
            screen?.startSensor()
            manager.add(screen)
            
            // Aware.setSetting(getApplicationContext(), Aware_Preferences.STATUS_TOUCH, true);
            /** NOTE: iOS does not support this sensor */
            
            // Aware.setSetting(getApplicationContext(), Aware_Preferences.STATUS_WIFI, true);
            // Aware.setSetting(getApplicationContext(), Aware_Preferences.FREQUENCY_WIFI, 5); //every 5 minutes
            let wifi = Wifi.init(awareStudy: study, dbType: AwareDBTypeSQLite)
            wifi?.startSensor(withInterval: 60 * 5)
            manager.add(wifi)
            
            //fused location
            // Aware.setSetting(getApplicationContext(), com.aware.plugin.google.fused_location.Settings.STATUS_GOOGLE_FUSED_LOCATION, true);
            // Aware.setSetting(getApplicationContext(), com.aware.plugin.google.fused_location.Settings.FREQUENCY_GOOGLE_FUSED_LOCATION, 300); //every 5 minutes.
            // Aware.setSetting(getApplicationContext(), com.aware.plugin.google.fused_location.Settings.MAX_FREQUENCY_GOOGLE_FUSED_LOCATION, 60); //every 60 s if mobile
            // Aware.setSetting(getApplicationContext(), com.aware.plugin.google.fused_location.Settings.ACCURACY_GOOGLE_FUSED_LOCATION, 102);
            // Aware.setSetting(getApplicationContext(), com.aware.plugin.google.fused_location.Settings.FALLBACK_LOCATION_TIMEOUT, 20); //if not moving for 20 minutes, new location captured
            // Aware.setSetting(getApplicationContext(), com.aware.plugin.google.fused_location.Settings.LOCATION_SENSITIVITY, 5); //need to move 5 meter to assume new location
            // Aware.startPlugin(getApplicationContext(), "com.aware.plugin.google.fused_location");
            let location = FusedLocations.init(awareStudy: study, dbType: AwareDBTypeSQLite)
            location?.intervalSec = 300
            location?.startSensor()
            manager.add(location)
            
            manager.createDBTablesOnAwareServer()
            
//            manager.setDebugToAllSensors(true)
//            manager.setDebugToAllStorage(true)
//
//            manager.setSyncProcessCallbackToAllSensorStorages { (sensorName, progress, error) in
//                print(sensorName,progress);
//            }
//
//            DispatchQueue.main.asyncAfter(deadline: .now() + 60) {
//                manager.syncAllSensors()
//            }
        }
        
        return true
    }

    override func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        super.applicationWillResignActive(application)
    }

    override func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        super.applicationDidEnterBackground(application)
    }

    override func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        super.applicationWillEnterForeground(application)
    }

    override func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        super.applicationDidBecomeActive(application)
    }

    override func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        super.applicationWillTerminate(application)
    }


}

