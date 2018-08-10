
//  HomeView.swift
//  NaradPosts

//  Created by Narayan on 2/19/18.
//  Copyright © 2018 Narayan. All rights reserved.


import UIKit

class HomeView: UIViewController,UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource{
    var dynamicURl=String()
    var d=0
    var time:Int=2130
    @IBOutlet weak var DismissNewView: UIView!
    @IBOutlet weak var tapBarView: UIView!
    private var CollectionViewIndex: Int = 0
    var visibleIndexPathRow=0
    var indexVariable=0
    var readNewsCount:Int=0
    var totalNewsCount:Int=0
    var skipConditionStatus=false
    var skip=0
    var timerTest : Timer?
    var refreshCount=0
    var pageIndex=0
    var pageSize=300
    let button=UIButton()
    var skipCondition=0
    var readSendCondition=0
    var c=1
    var firstDownLoad=5
    
    public var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    // Screen height.
    public var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    @IBOutlet weak var phoneNumberStore: UITextField!
    @IBOutlet weak var imageDisniss: UIImageView!
    var timer=Timer()
    
    var url=URL(string:"")
    var storesList = [NSDictionary]()
    var newsTitle = [String]()
    var pics = [String]()
    var description1 = [String]()
    var updateTime = [String]()
    var share=0
    var astricDictionay=[NSDictionary]()
    var bookDictionay=[NSDictionary]()
    
    let activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    @IBOutlet weak var homecollection: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let date = Date()
        let calendar = Calendar.current
        
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
       time=seconds
        if UserDefaults.standard.object(forKey: "dynamicURL") != nil && UserDefaults.standard.object(forKey: "dynamicURL")as! String != ""
        {
            dynamicURl=UserDefaults.standard.object(forKey: "dynamicURL") as! String
            print("260718 dynamicURLusing 260718")
        }
        else
        {
            dynamicURl=staticURL
        }
        
     // bookMarkInstance.bookmark=bookMarkInstance.bookmark+","+"123"
    //    print("bookMarkInstance********\(bookMarkInstance.bookmark)Rock*******")
        
        
        
        
    let countView=UIView()
        countView.frame=CGRect(x: 10, y: Int((view.bounds.height)-20), width: 80, height: 10)
        
        pageIndex=0
        pageSize=6
        refreshCount=0
        //Looks for single or multiple taps.
        let tapKeyBoard = UITapGestureRecognizer(target: self, action: #selector(HomeView.keyBoard(_:)))
        tapKeyBoard.delegate = self
        tapKeyBoard.numberOfTapsRequired = 1
        DismissNewView.addGestureRecognizer(tapKeyBoard)
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(HomeView.handleTap(_:)))
        tapGR.delegate = self
        tapGR.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGR)
      /*  let tapKeyBoard1 = UITapGestureRecognizer(target: self, action: #selector(HomeView.keyBoard1(_:)))
        tapKeyBoard1.delegate = self
        tapKeyBoard1.numberOfTapsRequired = 1
        imageDisniss.addGestureRecognizer(tapKeyBoard1)*/
        
       
        subview.layer.cornerRadius=15
     
        button.frame=CGRect(x: 0, y: 0, width: 60, height: 60)
        button.setTitle("Close", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self,action: "CloseButtonPressed", for: .touchUpInside)
       
       // homecollection!.decelerationRate = UIScrollViewDecelerationRateFast
        var width=(self.view.bounds.width/2)-40
        var height=(self.view.bounds.height/2)-40
        activityIndicator.frame=CGRect(x:width, y: height, width: 80, height: 80)
        activityIndicator.activityIndicatorViewStyle=UIActivityIndicatorViewStyle.whiteLarge
        activityIndicator.backgroundColor=UIColor.black
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped=true
        if UserDefaults.standard.object(forKey: "phoneNumberStore") == nil
        {activityIndicator.stopAnimating()
        }
        else
        {
            mainInstance.noOfTimes=1
            DismissNewView.isHidden=true
            activityIndicator.startAnimating()
            if Reachability.isConnectedToNetwork() == true {
                self.getTheDataFromServer()
                
            } else {
                print("Internet connection FAILED")
                let alert = UIAlertView(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", delegate: nil, cancelButtonTitle: "OK")
                alert.show()
            }
        }
        
      
        
        
        
        UserDefaults.standard.set("0", forKey: "category")
       
       
    
      
       
        
    }
    
    
    func checkUpdate123()
    {
       
        var version=1.9
        var updatedVersion123=UserDefaults.standard.object(forKey: "updatedVersion")
        print(updatedVersion123,"bvspupadetedversdiomn")
        var updatedVersion:String!
       if UserDefaults.standard.object(forKey: "UpdatedVersion") != nil {
        
            updatedVersion=UserDefaults.standard.object(forKey: "UpdatedVersion") as! String
            if version < Double("\(updatedVersion!)")!
            {
                DispatchQueue.main.async {
                    var oKaction:Int=3
                    UserDefaults.standard.set(oKaction, forKey: "oKaction")
                    var message:String="Narad Post IOS App "
                    UserDefaults.standard.set(message, forKey: "message")
                    var messageDescription="""
                    Updated Version of Narad Post
                    Mobile Application \(updatedVersion!) is Now
                    Available
                    """
                    UserDefaults.standard.set(messageDescription, forKey: "messageDescription")
                    
                 let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "popUp1") as! UIViewController
                    self.present(vc, animated: true, completion: nil)
             
                    
                }
            }
        }
        
        
    }
    @objc func astricButtonTapped(sender:UIButton)
    {
        let button = sender as? UIButton
        let cell = button?.superview?.superview as? UICollectionViewCell
        let indexPath = homecollection.indexPath(for: cell!)
        let simpleEntry : NSDictionary = self.storesList[indexPath!.row]
       /*01/06/18 if UserDefaults.standard.object(forKey: "astricDictionay") != nil
        {var dummyDict:[NSDictionary]=UserDefaults.standard.object(forKey: "astricDictionay") as! [NSDictionary]
            astricDictionay.append(simpleEntry)
            astricDictionay.append(contentsOf: dummyDict)
            // astricDictionay =  UserDefaults.standard.object(forKey: "astricDictionay") as! [NSDictionary]
            
            UserDefaults.standard.set(astricDictionay, forKey: "astricDictionay")
        }
        else{
            astricDictionay.append(simpleEntry)
            UserDefaults.standard.set(astricDictionay, forKey: "astricDictionay")
        }
        self.showToast(message: "Added intoख़ास ख़बरें")01/06/18*/
        
        
        var astricid=simpleEntry["id"] as! String
        if UserDefaults.standard.object(forKey: "astricString") != nil
        {var astricString:String=UserDefaults.standard.object(forKey: "astricString") as! String
            if astricString.contains(astricid) ==  true
            {
                self.showToast(message: "Already in ख़ास ख़बरें")
            }
            else
            {
                astricString=astricString+","+"\(astricid)"
                print(astricString,"********astricid")
                self.showToast(message: "Added into ख़ास ख़बरें")
                UserDefaults.standard.set(astricString, forKey: "astricString")
            }
            
            
        }
        else{
            var astricString=astricid
            UserDefaults.standard.set(astricString, forKey: "astricString")
            self.showToast(message: "Added into ख़ास ख़बरें")
        }
        
        
        
    }
    @objc func bookmarkButtonTapped(sender:UIButton)
    {
        let button = sender as? UIButton
        let cell = button?.superview?.superview as? UICollectionViewCell
        let indexPath = homecollection.indexPath(for: cell!)
        let simpleEntry : NSDictionary = self.storesList[indexPath!.row]
        var bookid=simpleEntry["id"] as! String
       if UserDefaults.standard.object(forKey: "bookString") != nil
        {var bookString:String=UserDefaults.standard.object(forKey: "bookString") as! String
            if bookString.contains(bookid) ==  true
            {
                self.showToast(message: "Already in बुकमार्क्स")
            }
            else
            {
                bookString=bookString+","+"\(bookid)"
                print(bookString,"********bookMarkInstance")
                self.showToast(message: "Added into बुकमार्क्स")
                 UserDefaults.standard.set(bookString, forKey: "bookString")
            }
            
           
        }
        else{
            var bookString=bookid
            UserDefaults.standard.set(bookString, forKey: "bookString")
        self.showToast(message: "Added intoबुकमार्क्स")
        }
        
    /*1/06/18    var bookid=simpleEntry["id"] as! String
        var bookString=bookMarkInstance.bookmark
        if bookString.characters.count>1
        {
            if bookString.contains(bookid) ==  true
            {
                self.showToast(message: "Already in बुकमार्क्स")
            }
            else
            {
                bookMarkInstance.bookmark=bookMarkInstance.bookmark+","+"\(bookid)"
                print(bookMarkInstance.bookmark,"********bookMarkInstance")
                self.showToast(message: "Added into बुकमार्क्स")
            }
        }
        else
        {bookMarkInstance.bookmark="\(bookid)"
            self.showToast(message: "Added into बुकमार्क्स")
        }
        01/06/18*/
        
        
        
        
        
    }
    
    func startTimer () {
        
        if timerTest == nil {
            timerTest =  Timer.scheduledTimer(
                timeInterval: TimeInterval(5),
                target      : self,
                selector    : #selector(HomeView.counter),
                userInfo    : nil,
                repeats     : false)
        }
    }
    
    func stopTimerTest() {
        if timerTest != nil {
            timerTest?.invalidate()
            timerTest = nil
        }
    }
    
@objc func CloseButtonPressed(sender: UIButton!)
{
    dismiss(animated: true, completion: nil)
    }
    @IBAction func refresh(_ sender: UIButton) {
      
        
        refreshCount=0
        var width=(self.view.bounds.width/2)-40
        var height=(self.view.bounds.height/2)-40
        activityIndicator.frame=CGRect(x:width, y: height, width: 80, height: 80)
        activityIndicator.activityIndicatorViewStyle=UIActivityIndicatorViewStyle.whiteLarge
        activityIndicator.backgroundColor=UIColor.darkGray
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped=true
       /* DispatchQueue.main.async {
             self.downLoadAds()
        }
     */
       
     
        self.homecollection.scrollToItem(at: IndexPath(item:0,section:0), at: .top, animated: true)
        activityIndicator.stopAnimating()
    }
   
    func downLoadAds()
    {   let mySession=URLSession.shared
        let url=URL(string:"http://naradpost.news/WebService/GetAds.php")
        
        
        
        
        print("****\(url)********")
        
        
        let task = mySession.dataTask(with: url!, completionHandler: {
            (data, response, error) in
            if let error = error {
                print(error)
            }
            
            if let data = data{
                
                print("databvsp =\(data)")
            }
            
            //reading return responsive//
            
            if let response = response {
               // print("url bv= \(response.url!)")
                //print("response bv= \(response)")
                let httpResponse = response as! HTTPURLResponse
               // print("response code bv= \(httpResponse.statusCode)")
              //  print("\(response.description)response description")
                
                // Print out reponse body
                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
               // print("****** response data = \(responseString!)")
                
                //*********only successfully message coming and response data ******//
                
                let adsArray:[String]=responseString!.components(separatedBy: "~")
                UserDefaults.standard.set(adsArray, forKey: "adsArray")
                DispatchQueue.main.async {
                self.getTheDataFromServer()
                    
                }
                
                
                
                
            }
        })
        task.resume()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        checkUpdate123()
    }
    func getTheDataFromServer()
    {//http://naradpost.news/WebService/GetNewsByLocations_with_ads.php?category=0&country=0&state=0&city=0&ward=0&skip=0&get=5&tm=13444
        let date = Date()
        let calendar = Calendar.current
        
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        time=seconds
        let url=URL(string:dynamicURl+"GetNewsByLocations_with_ads.php?category=0&country=0&state=0&city=0&ward=0&skip=\(skip)&get=\(firstDownLoad)&tm=\(time)")
        print(url,"1234567890")
             let task = URLSession.shared.dataTask(with: url!, completionHandler: {
            (data,response,error) in
            if  error != nil
            {
                print(error)
            }
            else
            {
                do{
                    let resultJSON=try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
            //print(resultJSON,"bvsp1234")
                    let posts=resultJSON!["posts"] as! [NSDictionary]
                   // print(posts.count,"***postsCount***")
                    
                    //  print("******\(posts)")  prints data
                    for value in posts{
                        let dicValue = value as! NSDictionary
                        self.storesList.append(dicValue)
                        
                    }
                    if self.firstDownLoad==5
                    {
                        self.skipCondition=1
                        self.skip=self.skip+self.firstDownLoad
                        self.firstDownLoad=20
                        self.skipConditionStatus=true
                        if Reachability.isConnectedToNetwork() == true {
                            self.getTheDataFromServer()
                            
                        } else {
                            print("Internet connection FAILED")
                            let alert = UIAlertView(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", delegate: nil, cancelButtonTitle: "OK")
                            alert.show()
                        }
                       
                    }
                    print(posts.count,"storesList_count")
                    if posts.count == 6
                    {
                        self.skipCondition=1
                        self.skip=self.skip+self.firstDownLoad
                        self.skipConditionStatus=true
                    }
                    else if posts.count==24 {
                        self.skipCondition=1
                        self.skip=self.skip+self.firstDownLoad
                        self.skipConditionStatus=true
                    }
                    else{
                        self.skipConditionStatus=false
                    }
                }
                catch{
                    print("\(error.localizedDescription)")
                }
                DispatchQueue.main.async(execute: {
                    self.activityIndicator.stopAnimating()
                    self.homecollection.dataSource=self
                    self.homecollection.reloadData()
                    self.activityIndicator.stopAnimating()
                })
                
                
                
                
            }
        })
        task.resume()
       
    }

    
    @IBOutlet weak var subview: UIView!
    
    @IBAction func submit(_ sender: UIButton) {
        
        
        if phoneNumberStore.text?.count != 10
        {
            let alert=UIAlertController(title: "Alert", message: "Please enter valid 10 digit mobile number", preferredStyle: UIAlertControllerStyle.alert)
            let action=UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            
        }
        else
        {
            let usertype:String="Registered"
        let password="IOS"
        DismissNewView.isHidden=true
       // subview.isHidden=true
        UserDefaults.standard.set(phoneNumberStore.text, forKey: "phoneNumberStore")
       
         UserDefaults.standard.set(usertype, forKey: "usertype")
         let token:String=UserDefaults.standard.object(forKey: "token") as! String
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
            dateFormatter1.dateFormat = "hh:mma"
            let Date12 = dateFormatter1.string(from: date1!)
            let dateString:String="\(Date12)"
            print("12 hour formatted Date:",Date12)
        
        print("\(today_string)")
        
        
        
        //api fields//
 
        let mySession = URLSession.shared
        
        //api url link//
            
            
            
            let urlString:String=dynamicURl+"/DownloadCounter.php?mobile_no=\(phoneNumberStore.text!)&dte=\(today_string)&tm=\(dateString)&device=\(password)&usertype=\(usertype)&token=\(token)"
            var urlString1 = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            //print(urlString1)
            
            let url: URL! = URL(string:urlString)!
           // print("bvsp url:\(url)")
   
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
                print("****** response data = \(responseString!)")
                
                //*********only successfully message coming and response data ******//
                
            }
        })
        task.resume()
            viewDidLoad()
            
 }
            
    
    }
    
var adsArray=UserDefaults.standard.object(forKey: "adsArray")
        
        
   
  
    func runTimer()
    {
        self.timer = Timer.scheduledTimer(timeInterval: 08, target: self, selector: #selector(HomeView.counter), userInfo: nil, repeats: false)
      
        
    }
    
  @objc func counter() {
    
    var usertype:String=UserDefaults.standard.object(forKey: "usertype") as! String
    if usertype != nil
    {
        //tapBarView.isHidden=false
    print("Read content")
    let password="IOS"
    //if UserDefaults.standard.object(forKey: "phoneNumberStore") != nil{
    
    let phoneNumber1=UserDefaults.standard.object(forKey: "phoneNumberStore")! as! String
    let cellIndex:Int = indexVariable
   //let cell = button.superview?.superview as? GeminiCell
   // let indexPath = homecollection.indexPath(for: cell!)
    print("\(cellIndex)+++++++++++")
    
    let simpleEntry : NSDictionary = self.storesList[cellIndex]
        var id:Int=Int(simpleEntry.object(forKey:"id") as! String)!
   /* let alert=UIAlertController(title: "Alert", message: "Boss you are seeing this message \(id)from 1 min", preferredStyle: .alert)
    let action=UIAlertAction(title: "Ok", style: .cancel, handler: nil)
    alert.addAction(action)
    self.present(alert, animated: true, completion: nil)
    
    */
    
    
    
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
    
    
    
    //api fields//
    
    let mySession = URLSession.shared
    
    //api url link//
        

        var urlString:String=dynamicURl+"PostReadCountIncre.php?mobile_no=\(phoneNumber1 as! String)&post_id=\(id)&dte=\(today_string)&tm=\(dateString)&device_type=\(password)&usertype=\(usertype)"
        var urlString1 = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        print(urlString1)
        
        let url: URL! = URL(string:urlString1!)!
            print("bvsp******** url:\(url)")
    let task = mySession.dataTask(with: url, completionHandler: {
        (data, response, error) in
        if let error = error {
            print(error)
        }
        
        if let data = data{
            
           // print("databvsp =\(data)")
        }
        
        //reading return responsive//
        
        if let response = response {
            print("url bv= \(response.url!)")
            print("response bv= \(response)")
            let httpResponse = response as! HTTPURLResponse
            print("response code bv= \(httpResponse.statusCode)")
            //print("\(response.description)response description")
            
            // Print out reponse body
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("****** response data = \(responseString!)")
            
            //*********only successfully message coming and response data ******//
         //   UserDefaults.standard.set(, forKey: "phoneNumberStore")
           // self.sendRequestToServer()
            
        }
    })
    task.resume()
  
    }
    
    }

    
    @IBAction func skipButton(_ sender: UIButton) {
        
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
            dateFormatter1.dateFormat = "hh:mma"
            let Date12 = dateFormatter1.string(from: date1!)
            let dateString:String="\(Date12)"
            print("12 hour formatted Date:",Date12)
            
        
            
            
            
            //api fields//
            
            let mySession = URLSession.shared
            
            //api url link//
            let url: URL! = URL(string:dynamicURl+"/GetRandomNo.php?tm=\(Date12)")!
    
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
                    print("****** response data = \(responseString!)")
                    
                    //*********only successfully message coming and response data ******//
                    
                    UserDefaults.standard.set(responseString!, forKey: "phoneNumberStore")
                   
                    DispatchQueue.main.async {

                        self.sendRequestToServer()
                    }
              
                }
            })
            task.resume()
   
            
        }
        
        
    @IBAction func nextPage(_ sender: UIButton) {
        let storyBoard=UIStoryboard(name: "Main", bundle: nil)
        let vc=storyboard?.instantiateViewController(withIdentifier: "abc") as! UIViewController
        presentDetail(vc)
        
    }
    
    func sendRequestToServer()
    {let usertype:String="Not Registered"
         UserDefaults.standard.set(usertype, forKey: "usertype")
        let password="IOS"

          DismissNewView.isHidden=true
     
        
        // subview.isHidden=true
        var mobilenumber=UserDefaults.standard.object(forKey: "phoneNumberStore")
        let token=String()
        if UserDefaults.standard.object(forKey: "token") != nil
        {
         let token:String=UserDefaults.standard.object(forKey: "token") as! String
        
        }
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
        
        
        
        //api fields//
        
        let mySession = URLSession.shared
        
        //api url link//
        let urlString:String=dynamicURl+"DownloadCounter.php?mobile_no=\(mobilenumber!)&dte=\(today_string)&tm=\(dateString)&device=\(password)&usertype=\(usertype)&token=\(token)"
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
                print("****** response data = \(responseString!)")
                
                //*********only successfully message coming and response data ******//
        
                
                
            }
        })
        task.resume()
        viewDidLoad()
        
        
        
    }
        
   
     @objc func webView(sender: UIButton!)
     {  let button = sender as? UIButton
        let cell = button?.superview?.superview as? UICollectionViewCell
        let indexPath = homecollection.indexPath(for: cell!)
        let simpleEntry : NSDictionary = self.storesList[indexPath!.row]
        var urlLink:String=simpleEntry.object(forKey:"url") as! String
        UserDefaults.standard.set(urlLink, forKey: "urlLink")
        print("\(urlLink)bvsp")
        var publisherLink:String=simpleEntry.object(forKey:"publisher_image") as! String
        UserDefaults.standard.set(publisherLink, forKey: "publisherLink")
        let storyboard=UIStoryboard(name: "Main", bundle: nil)
        let vc=storyboard.instantiateViewController(withIdentifier: "webView") as! UIViewController
        self.present(vc, animated: true, completion: nil)
    }
    
 
     @objc func hideTopBarView()
     {
        if tapBarView.isHidden==false
        {
            tapBarView.isHidden=true
        }
        else
        {
            tapBarView.isHidden=false
        }
    }
    @objc func shareButtontapped(sender: UIButton!)
    {  // var newsImage:UIImage!
        let button = sender as? UIButton
        let cell = button?.superview?.superview as? UICollectionViewCell
        let indexPath = homecollection.indexPath(for: cell!)
        print("\(indexPath?.row)+++++++++++")
        
        let simpleEntry : NSDictionary = self.storesList[indexPath!.row]
         var share_link:String=simpleEntry.object(forKey:"share_link") as! String
        
        let myWebsite = NSURL(string:share_link)
        //let img: UIImage = image!
        print("\(myWebsite)**********")
        guard let url = myWebsite else {
            print("nothing found")
            return
        }
        
        
        
        ////whats appp Image Code
      
        
       /////////////////////////////////
        
        
        
       
        let bounds = UIScreen.main.bounds
        UIGraphicsBeginImageContextWithOptions(bounds.size, true, 0.0)
        self.view.drawHierarchy(in: bounds, afterScreenUpdates: false)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
         let shareItems:Array = [img!, url]
        let activityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        
        if readNewsCount<indexPath.row
        {
            readNewsCount=readNewsCount+1
            
            //showToast(message: "\(totalNewsCount-readNewsCount) are remaining")
        }
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    
/*var visibleRect: CGRect = CGRect()
 visibleRect.origin = collectionView?.contentOffset
 visibleRect.size = collectionView?.bounds.size
 var visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
 var visibleIndexPath: IndexPath? = collectionView?.indexPathForItem(at: visiblePoint)*/
    
       /* indexVariable=visibleIndexPathRow
        var storeList=storesList[visibleIndexPathRow] as! NSDictionary
        timer.invalidate()
        print(indexPath.row,"indexpathRowValue")
        print(storeList["id"],"storeList(id)")
        if storeList["id"] as! String != "0"
        {
            self.timer = Timer.scheduledTimer(timeInterval:5, target: self, selector: #selector(HomeView.counter), userInfo: nil, repeats: false)
        }*/
        /*if indexPath.row==0
        {
            
            
            indexVariable=indexPath.row
            var storeList=storesList[indexPath.row] as! NSDictionary
            timer.invalidate()
            print(indexPath.row,"indexpathRowValue")
            print(storeList["id"],"storeList(id)")
            if storeList["id"] as! String != "0"
            {
                self.timer = Timer.scheduledTimer(timeInterval:5, target: self, selector: #selector(HomeView.counter), userInfo: nil, repeats: false)
            }
        }
        else
        {
        indexVariable=indexPath.row
        var storeList=storesList[indexPath.row-1] as! NSDictionary
        timer.invalidate()
        print(indexPath.row,"indexpathRowValue")
       
            print(storeList["id"],"storeList(id)")
        if storeList["id"] as! String != "0"
        {
            self.timer = Timer.scheduledTimer(timeInterval:5, target: self, selector: #selector(HomeView.counter), userInfo: nil, repeats: false)
        }
        }*/
    }

    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return storesList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        
       // indexVariable=indexPath.row
        
        
        
        // let queue = DispatchQueue(label: "com.appcoda.myqueue")
        // queue.sync {
        
        
        let cell=homecollection.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! HomeCollectionViewCell
        cell.layer.cornerRadius=10
        var storeList=storesList[indexPath.row] as! NSDictionary
        var image1:String!
        
        
        print("\(indexPath.row)indexpath variable")
        image1=storeList.object(forKey: "image") as! String
        print("image1 value\(image1!)")
        
        
      if storeList["id"] as! String  == "0"
        {
            
            cell.backgroundColor=UIColor.black
            
            
            
            cell.backgroundColor=UIColor.black
            
            //cell.image1.image = UIImage(data: imageData!)
            
            cell.image1.frame=CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
            cell.title2.isHidden=true
            cell.title.isHidden=true
            cell.title2.isHidden=true
          
            cell.astric.isHidden=true
            cell.bookmark.isHidden=true
            
            cell.time.isHidden=true
            cell.smallImage.isHidden=true
            cell.shareButton.isHidden=true
            cell.readMoreButton.isHidden=true
            cell.label2.isHidden=true
            cell.image1.layer.cornerRadius=10
            cell.image1.sd_setImage(with: URL(string: image1!), placeholderImage: UIImage(named: "placeholder.png"))
        }
        else{
            
            
            
            
            let simpleEntry : NSDictionary = self.storesList[indexPath.row]
            cell.backgroundColor=UIColor.white
            /*  DispatchQueue.global().async {
             let url = URL(string: "\(photonamelink!)")
             
             let imageData = try? Data(contentsOf: url!)
             
             DispatchQueue.main.sync {
             
             cell.image1.image = UIImage(data: imageData!)
             
             }
             }*/
            
            /* DispatchQueue.global().async {
             let url = URL(string: "\(smallImage!)")
             
             let imageData = try? Data(contentsOf: url!)
             
             DispatchQueue.main.sync {
             
             cell.smallImage.image = UIImage(data: imageData!)
             
             
             }
             }
             
             
             */
            
            
            cell.shareButton.isHidden=false
            cell.title2.isHidden=false
            cell.title.isHidden=false
            cell.title2.isHidden=false
        
            cell.astric.isHidden=false
            cell.astric.addTarget(self, action:#selector(astricButtonTapped), for: .touchUpInside)
            cell.bookmark.isHidden=false
            cell.bookmark.addTarget(self, action:#selector(bookmarkButtonTapped), for: .touchUpInside)
            cell.time.isHidden=false
            cell.smallImage.isHidden=false
            cell.readMoreButton.isHidden=false
            cell.label2.isHidden=false
            
            cell.image1.layer.cornerRadius=0
            //cell.image1.frame=CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 298)
        
        
        
        if self.screenHeight==558
        {
            cell.image1.frame=CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height/2-50)
            cell.constrainHeight.constant=self.view.bounds.height/2-50
        }
        else if self.screenHeight==667
        {
            cell.image1.frame=CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height/2-40)
            cell.constrainHeight.constant=self.view.bounds.height/2-40
        }
        else if self.screenHeight>667
        {
            cell.image1.frame=CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height/2)
            cell.constrainHeight.constant=self.view.bounds.height/2
        }
        else
        {cell.image1.frame=CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 250)
            cell.constrainHeight.constant=250
        }
            var photonamelink:String=simpleEntry["image"] as! String
            cell.image1.sd_setImage(with: URL(string: image1!), placeholderImage: UIImage(named: "placeholder.png"))
            
            var smallImage:String=simpleEntry["publisher_image"] as! String
            
            cell.smallImage.sd_setImage(with: URL(string: smallImage), placeholderImage: UIImage(named: "placeholder.png"))
            cell.title2.font=UIFont.boldSystemFont(ofSize: 21.0)
            DispatchQueue.main.async {
                cell.title.text = "\(simpleEntry["description"]!)".htmlAttributedString?.string
                cell.title.font = UIFont(name:"Avenir", size:16)
            }
            
            cell.title2.text = "\(simpleEntry["title"]!)"
            
            cell.time.text = simpleEntry["time"] as? String
            
            /*UIView.animate(withDuration:0.5, delay:3.0, options: [.curveEaseOut, .autoreverse, .repeat], animations: {
             cell.blinking.alpha = 0.0
             
             }, completion: nil)
             
             */
            
            
            cell.shareButton.layer.cornerRadius=5
            cell.shareButton.layer.borderWidth=2
            cell.shareButton.layer.borderColor=UIColor.orange.cgColor
            cell.shareButton.addTarget(self, action:#selector(shareButtontapped), for: .touchUpInside)
            cell.readMoreButton.addTarget(self, action:#selector(webView), for: .touchUpInside)
        }
        return cell
    }
    
    
    
    /* func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
     
     let simpleEntry : NSDictionary = self.storesList[indexPath.row]
     var urlLink:String=simpleEntry.object(forKey:"url") as! String
     UserDefaults.standard.set(urlLink, forKey: "urlLink")
     print("\(urlLink)bvsp")
     var publisherLink:String=simpleEntry.object(forKey:"publisher_image") as! String
     UserDefaults.standard.set(publisherLink, forKey: "publisherLink")
     let storyboard=UIStoryboard(name: "Main", bundle: nil)
     let vc=storyboard.instantiateViewController(withIdentifier: "webView") as! UIViewController
     self.present(vc, animated: true, completion: nil)
     
     }*/
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        for cell: UICollectionViewCell in homecollection.visibleCells {
            var indexPath: IndexPath? = homecollection.indexPath(for: cell)
           
            
            CollectionViewIndex = 0
            var lastSectionIndex: Int = (homecollection?.numberOfSections)! - 1
            var lastItemIndex: Int = (homecollection?.numberOfItems(inSection: lastSectionIndex))! - 1
            var visibleRect: CGRect = CGRect()
            visibleRect.origin = (homecollection?.contentOffset)!
            visibleRect.size = (homecollection?.bounds.size)!
            var visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
            var visibleIndexPath: IndexPath? = homecollection?.indexPathForItem(at: visiblePoint)
           
            print(visibleIndexPath?.row,"bvspVisible")
            visibleIndexPathRow=(visibleIndexPath?.row)!
           
            var storeList=storesList[visibleIndexPathRow] as! NSDictionary
            timer.invalidate()
            print(visibleIndexPathRow,"indexpathRowValue")
            print(storeList["id"],"storeList(id)")
            indexVariable=visibleIndexPathRow
         
            if storeList["id"] as! String != "0"
            {
                self.timer = Timer.scheduledTimer(timeInterval:5, target: self, selector: #selector(HomeView.counter), userInfo: nil, repeats: false)
              
                
            }
            if visibleIndexPath?.row==storesList.count-1
            {if skipConditionStatus==true
            {self.activityIndicator.startAnimating()
                firstDownLoad=20
                CollectionViewIndex=1
                
                }
            }
            if visibleIndexPath?.row == 0
            {
                refreshCount = refreshCount+1
                
                if refreshCount==2
                {
                    refreshCount=0
                    
                    refreshAutomatic()
                }
            }
        }
    }
    func refreshAutomatic()
    {
        
        print("refreshing The data Automatically")
        refreshCount=0
        downLoadAds()
        self.showToast(message: "Updated data")
        
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("scrollViewWillBeginDragging")
        tapBarView.isHidden=true
        if CollectionViewIndex == 1 {
            if skipConditionStatus==true
            {
                skipCondition=0
                if Reachability.isConnectedToNetwork() == true {
                    self.getTheDataFromServer()
                    
                } else {
                    print("Internet connection FAILED")
                    let alert = UIAlertView(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", delegate: nil, cancelButtonTitle: "OK")
                    alert.show()
                }
               
                
            }
        }
    }
   /* func sendRequestForNextPage()
    {
        if CollectionViewIndex==1
        {if skipConditionStatus==true
        {
            skipCondition=0
            self.gettingCategoryList()
            
            }
            
            
        }
    }*/
    
    
    
    
    
}
extension HomeView: UIGestureRecognizerDelegate {
    @objc func handleTap(_ gesture: UITapGestureRecognizer){
        print("doubletapped")
        hideTopBarView()
        
    }
    @objc func keyBoard(_ gesture: UITapGestureRecognizer){
        subview.endEditing(true)
        
    }
}



// MARK: - UICollectionViewDelegate

// MARK: - UICollectionViewDataSource

extension UIViewController {
    
    func showToast(message : String) {
      
        let toastLabel = UILabel(frame: CGRect(x: (self.view.frame.size.width/2) - 100, y: self.view.frame.size.height-100, width: 200, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    } }


extension UIViewController {
    
    func presentDetail(_ viewControllerToPresent: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.75
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        self.view.window!.layer.add(transition, forKey: kCATransition)
        
        present(viewControllerToPresent, animated: false)
    }
    func presentDetailRight(_ viewControllerToPresent: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.50
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        self.view.window!.layer.add(transition, forKey: kCATransition)
        
        present(viewControllerToPresent, animated: false)
    }
    func dismissDetail() {
        let transition = CATransition()
        transition.duration = 0.50
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        self.view.window!.layer.add(transition, forKey: kCATransition)
        
        dismiss(animated: false)
    }
}

