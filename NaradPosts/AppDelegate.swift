//
//  AppDelegate.swift
//  NaradPosts
//
//  Created by Narayan on 2/16/18.
//  Copyright © 2018 Narayan. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications
var staticURL="http://naradpost.news/WebService/"
@UIApplicationMain
class AppDelegate: UIResponder,XMLParserDelegate,UIApplicationDelegate,UNUserNotificationCenterDelegate{
var selection=0
    var window: UIWindow?
    var dynamicURL=String()
    public var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    // Screen height.
    public var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        
       
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            getApiLink()
            abc()
            
            print(screenHeight,"100718")
            
           
            
            
        } else {
            print("Internet connection FAILED")
            let alert = UIAlertView(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
        
        // iOS 11 support
        if #available(iOS 11, *) {
            UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
            application.registerForRemoteNotifications()
        }
        // iOS 10 support
        if #available(iOS 10, *) {
            UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
            application.registerForRemoteNotifications()
        }
            // iOS 9 support
        else if #available(iOS 9, *) {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
            // iOS 8 support
        else if #available(iOS 8, *) {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
            // iOS 7 support
        else {
            application.registerForRemoteNotifications(matching: [.badge, .sound, .alert])
        }
       
        return true
    }
   
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        var mobilenumber=UserDefaults.standard.object(forKey: "phoneNumberStore")
        if mobilenumber != nil
        {
        sendUpdateStatusToServer()
        
        }
        
        
    }
 
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
   

    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Convert token to string
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        UserDefaults.standard.set(deviceTokenString, forKey: "token")
        // Print it to console
        print("APNs device token: \(deviceTokenString)")
        
        
        // Persist it in your backend in case it's new
    }
    
    // Called when APNs failed to register the device for push notifications
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // Print the error to console (you should alert the user that registration failed)
        print("APNs registration failed: \(error)")
    }
    // Push notification received
    func application(_ application: UIApplication, didReceiveRemoteNotification data: [AnyHashable : Any]) {
        // Print notification payload data
        
        print("Push notification received: \(data)")
    }
    
    
    // This method will be called when app received push notifications in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        completionHandler([.alert, .badge, .sound])
    }
    
    
    
    
    
    
    

    func sendUpdateStatusToServer()
    {
        
        let userType:String=UserDefaults.standard.object(forKey: "usertype") as! String
        let password="IOS"
    
        // subview.isHidden=true
        var mobilenumber=UserDefaults.standard.object(forKey: "phoneNumberStore")
        
        
        
        let date = Date()
        let calender = Calendar.current
        let components = calender.dateComponents([.year,.month,.day,.hour,.minute,.second], from: date)
        
        let year = components.year
        let month = components.month
        let day = components.day
        let hour = components.hour
        let minute = components.minute
        let second = components.second
        
        let today_string = String(year!) + "-" + String(month!) + "-" + String(day!)
        let today_time=String(hour!)  + ":" + String(minute!)
        
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "HH:mm"
        
        let date1 = dateFormatter1.date(from: today_time)
        dateFormatter1.dateFormat = "hh:mm a"
        let Date12 = dateFormatter1.string(from: date1!)
        let dateString:String="\(Date12)"
        print("12 hour formatted Date:",Date12)
        
        print("\(today_string)")
        
        if UserDefaults.standard.object(forKey: "dynamicURL") != nil && UserDefaults.standard.object(forKey: "dynamicURL")as! String != ""
        {
            dynamicURL=UserDefaults.standard.object(forKey: "dynamicURL") as! String
        }
        else
        {
            dynamicURL=staticURL
        }
        
        //api fields//
        
        let mySession = URLSession.shared
        
        //api url link//
        let urlString:String=dynamicURL+"DownloadCounter.php?mobile_no=\(mobilenumber!)&dte=\(today_string)&tm=\(dateString)&device=\(password)&usertype=\(userType)"
        var urlString1 = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        print(urlString1)
        
        let url: URL! = URL(string:urlString1!)!
        print("bvsp url:\(url)")
        
        let task = mySession.dataTask(with: url, completionHandler: {
            (data, response, error) in
            if let error = error {
                print(error)
            }
            
            if let data = data{
                
                print("databvsp =\(data)")
            }
            
            //reading return responsive//
            
            if let response = response {
                print("url bv= \(response.url!)")
                print("response bv= \(response)")
                let httpResponse = response as! HTTPURLResponse
                print("response code bv= \(httpResponse.statusCode)")
                print("\(response.description)response description")
                
                // Print out reponse body
                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                print("****** response data sendUpdateStatusToServer = \(responseString!)")
                
                //*********only successfully message coming and response data ******//
                
                
                
            }
        })
        task.resume()
  
    }
    func abc()
    {var is_SoapMessage: String = "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance/\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema/\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body><GetUpdatedVersion xmlns=\"http://tempuri.org/\"><ProjectName>Narad Post IOS</ProjectName><SecurityKey>#111000$</SecurityKey></GetUpdatedVersion></soap:Body></soap:Envelope>"
      let is_URL: String = "http://admin.khatabahi.com/KhataBahiService.asmx"
        
        let lobj_Request = NSMutableURLRequest(url: NSURL(string: is_URL)! as URL)
        let session = URLSession.shared
        //let err: NSError?
        
        lobj_Request.httpMethod = "POST"
        lobj_Request.httpBody = is_SoapMessage.data(using: String.Encoding.utf8)
        lobj_Request.addValue("admin.khatabahi.com", forHTTPHeaderField: "Host")
        lobj_Request.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        lobj_Request.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        lobj_Request.addValue(String(is_SoapMessage.characters.count), forHTTPHeaderField: "Content-Length")
        lobj_Request.addValue("http://tempuri.org/GetUpdatedVersion", forHTTPHeaderField: "SOAPAction")
        
        let task = session.dataTask(with: lobj_Request as URLRequest, completionHandler: {data, response, error -> Void in
            print("Response: \(response)")
            if data != nil
            {
            let strData = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("Body: \(strData)")
            
            let XMLparser = XMLParser(data: data!)
            XMLparser.delegate = self
            XMLparser.parse()
            }
            //XMLparser.shouldResolveExternalEntities = true
            if error != nil
            {
                print("Error: " + error!.localizedDescription)
            }
            
        })
        
        task.resume()
        
    }
    
    func getApiLink()
    {var is_SoapMessage: String = "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance/\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema/\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body><GetAPIDynamicURL xmlns=\"http://tempuri.org/\"></GetAPIDynamicURL></soap:Body></soap:Envelope>"
     let is_URL: String = "http://admin.khatabahi.com/WSKhataBahiOnline.asmx"
        //let is_URL: String = "http://wservice.khatabahi.online/WSKhataBahiOnline.asmx"
        let lobj_Request = NSMutableURLRequest(url: NSURL(string: is_URL)! as URL)
        let session = URLSession.shared
        //let err: NSError?
        
        lobj_Request.httpMethod = "POST"
        lobj_Request.httpBody = is_SoapMessage.data(using: String.Encoding.utf8)
        lobj_Request.addValue("admin.khatabahi.com", forHTTPHeaderField: "Host")
        lobj_Request.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        lobj_Request.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        lobj_Request.addValue(String(is_SoapMessage.characters.count), forHTTPHeaderField: "Content-Length")
        lobj_Request.addValue("http://tempuri.org/GetAPIDynamicURL", forHTTPHeaderField: "SOAPAction")
        
        let task = session.dataTask(with: lobj_Request as URLRequest, completionHandler: {data, response, error -> Void in
            print("Response: \(response)")
            if data != nil
            {
                let strData = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                print("Body: \(strData)")
                
                let XMLparser = XMLParser(data: data!)
                XMLparser.delegate = self
                XMLparser.parse()
            }
            //XMLparser.shouldResolveExternalEntities = true
            if error != nil
            {
                print("Error: " + error!.localizedDescription)
            }
            
        })
        
        task.resume()
        
    }
    
    
    var elementValue: String?
    var getDynamicURlResult=String()
    var getDynamicURlValue=String()
    var success = false
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "GetUpdatedVersionResult" {
            elementValue = String()
            selection=0
        }
        if elementName == "GetAPIDynamicURLResult" {
            getDynamicURlValue = String()
            selection=1
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if elementValue != nil && selection==0{
            elementValue! += string
            UserDefaults.standard.set(elementValue, forKey: "UpdatedVersion")
            print(elementValue,"elementValue")
            
            
        }
        if getDynamicURlValue != nil && selection==1{
            getDynamicURlValue += string
            UserDefaults.standard.set(getDynamicURlValue, forKey: "dynamicURL")
            
            print(getDynamicURlValue)
            
        }
    }
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "GetUpdatedVersionResult" {
            elementValue = String()
            selection=0
        }
        if elementName == "GetAPIDynamicURLResult" {
            getDynamicURlValue = String()
            selection=1
            
        }
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("parseErrorOccurred: \(parseError)")
    }
    
    

    
}
