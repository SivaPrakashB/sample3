    //
    //  BookAndMarkViewController.swift
    //  NaradPosts
    //
    //  Created by Narayan on 6/1/18.
    //  Copyright © 2018 Narayan. All rights reserved.
    //

    import UIKit

    class BookAndMarkViewController: UIViewController,UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate{
        private var CollectionViewIndex: Int = 0
        @IBOutlet weak var topBarView: UIView!
        var url=URL(string:"")
        var storesList = [NSDictionary]()
        var newsTitle = [String]()
        var pics = [String]()
        var description1 = [String]()
        var updateTime = [String]()
        var indexVariable=0
        var timer=Timer()
        var count=0
        let adsImageView=UIImageView()
        var refreshCount=0
        var astricDictionay=[NSDictionary]()
        var bookDictionay=[NSDictionary]()
        var stateID=String()
        var showValue=0
        var skipCondition=0
        var time:Int=830
        var skip=0
        var a=""
        var reloadDataCondition=0
        var skipConditionStatus=false
        var getNewsUrl=String()
        var visibleIndexPathRow=0
        var bookMarkNewsIDS=String()
        var kasKhabareNewsIDS=String()
        var conditionForDelet=Int()
        var dynamicURl=String()
        public var screenWidth: CGFloat {
            return UIScreen.main.bounds.width
        }
        
        // Screen height.
        public var screenHeight: CGFloat {
            return UIScreen.main.bounds.height
        }
        
        
        
        @IBOutlet weak var title3: UILabel!
        
        
        
        let activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
        @IBOutlet weak var homecollection: UICollectionView!
        override func viewDidLoad() {
            super.viewDidLoad()
            if UserDefaults.standard.object(forKey: "dynamicURL") != nil && UserDefaults.standard.object(forKey: "dynamicURL")as! String != ""
            {
                dynamicURl=UserDefaults.standard.object(forKey: "dynamicURL") as! String
            }
            else
            {
                dynamicURl=staticURL
            }
            
            refreshCount=0
            let tapGR = UITapGestureRecognizer(target: self, action: #selector(StateNewsShowViewController.handleTap(_:)))
            tapGR.delegate = self
            tapGR.numberOfTapsRequired = 1
            view.addGestureRecognizer(tapGR)
            // homecollection!.decelerationRate = UIScrollViewDecelerationRateFast
            
            adsImageView.frame=CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
            adsImageView.isHidden=true
            /*21/05/18  let name:String=UserDefaults.standard.object(forKey: "name") as! String
             self.title3.text="\(name)"21/05/18*/
            var width=(self.view.bounds.width/2)-40
            var height=(self.view.bounds.height/2)-40
            activityIndicator.frame=CGRect(x:width, y: height, width: 80, height: 80)
            activityIndicator.activityIndicatorViewStyle=UIActivityIndicatorViewStyle.whiteLarge
            activityIndicator.backgroundColor=UIColor.darkGray
            self.view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            activityIndicator.hidesWhenStopped=true
            
            
            
            
        }
        override func viewDidAppear(_ animated: Bool) {
            
            let numberCheck200=UserDefaults.standard.object(forKey: "category") as! String
           
          if Int(numberCheck200) == 200{
                self.bookCategory()
            conditionForDelet=0
            }
            else if Int(numberCheck200) == 300
            {
                self.astricCategory()
                conditionForDelet=1
            }
            
            let name:String=UserDefaults.standard.object(forKey: "name") as! String
            self.title3.text="\(name)"
            
            
           /* stateID=UserDefaults.standard.object(forKey: "stateID") as! String
            getNewsUrl=UserDefaults.standard.object(forKey: "getNewsUrl") as! String
            gettingCategoryList()*/
        }
        @objc func dismissView()
        {
            adsImageView.isHidden=true
            
        }
        
        @IBAction func Refresh(_ sender: UIButton) {
            
            refreshCount=0
            var width=(self.view.bounds.width/2)-40
            var height=(self.view.bounds.height/2)-40
            activityIndicator.frame=CGRect(x:width, y: height, width: 80, height: 80)
            activityIndicator.activityIndicatorViewStyle=UIActivityIndicatorViewStyle.whiteLarge
            activityIndicator.backgroundColor=UIColor.darkGray
            self.view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            activityIndicator.hidesWhenStopped=true
            //downLoadAds()
            
            self.homecollection.scrollToItem(at: IndexPath(item:0,section:0), at: .top, animated: true)
            activityIndicator.stopAnimating()
            // self.homecollection.reloadData()
        }
        
        
        
        
        @objc func webView(sender: UIButton!)
        { let button = sender as? UIButton
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
        
       
        
        func bookCategory()
        {
            
            bookMarkNewsIDS=UserDefaults.standard.object(forKey: "bookString") as! String
         let urlString=dynamicURl+"GetNewsByNewsIDs_with_ads.php?news_id=\(bookMarkNewsIDS)"
            
            let date = Date()
            let calendar = Calendar.current
            
            let hour = calendar.component(.hour, from: date)
            let minutes = calendar.component(.minute, from: date)
            let seconds = calendar.component(.second, from: date)
            time=seconds
            url = URL(string: "\(urlString)&skip=\(skip)&get=5&tm=\(time)")
            
            print("*********Rock\(url)*********")
            
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
                        print(resultJSON,"bvsp1234")
                        let posts=resultJSON!["posts"] as! [NSDictionary]
                        print(posts.count,"***bv***")
                        
                        //  print("******\(posts)")  prints data
                        for value in posts{
                            let dicValue = value as! NSDictionary
                            self.storesList.append(dicValue)
                            
                        }
                        
                       
                        if posts.count == 6
                        {self.showValue=self.skip
                            self.skipCondition=1
                            self.skip=self.skip+5
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
                        self.homecollection.dataSource=self
                        self.homecollection.reloadData()
                        self.activityIndicator.stopAnimating()
                    })
                    
                    
                    
                    
                }
            })
            task.resume()
            
        }
        func astricCategory()
        {
            
            let date = Date()
            let calendar = Calendar.current
            
            let hour = calendar.component(.hour, from: date)
            let minutes = calendar.component(.minute, from: date)
            let seconds = calendar.component(.second, from: date)
            time=seconds
            
            kasKhabareNewsIDS=UserDefaults.standard.object(forKey: "astricString") as! String
            let urlString=dynamicURl+"GetNewsByNewsIDs_with_ads.php?news_id=\(kasKhabareNewsIDS)"
            
            
            url = URL(string: "\(urlString)&skip=\(skip)&get=5&tm=\(time)")
            
            
            
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
                        print(resultJSON,"bvsp1234")
                        let posts=resultJSON!["posts"] as! [NSDictionary]
                        print(posts.count,"***bv***")
                        
                        //  print("******\(posts)")  prints data
                        for value in posts{
                            let dicValue = value as! NSDictionary
                            self.storesList.append(dicValue)
                            
                        }
                        
                        
                        if posts.count == 6
                        {self.showValue=self.skip
                            self.skipCondition=1
                            self.skip=self.skip+5
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
                        self.homecollection.dataSource=self
                        self.homecollection.reloadData()
                        self.activityIndicator.stopAnimating()
                    })
                    
                    
                    
                    
                }
            })
            task.resume()
            
        }
        
        
        
        
        
        func gettingCategoryList()
        {
            time=time+1
            let getNewsUrl:String=UserDefaults.standard.object(forKey: "getNewsUrl") as! String
            
            
            url = URL(string: "\(getNewsUrl)&skip=\(skip)&get=5&tm=\(time)")
            
            
            print("****\(url)********")
            //       let urlString = RequiredURLS().storesUrl
            //   print("urlString : \(urlString)")
            
            //  activityIndicator.startAnimating()
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
                        print(resultJSON,"bvsp1234")
                        let posts=resultJSON!["posts"] as! [NSDictionary]
                        print(posts.count,"***bv***")
                        
                        //  print("******\(posts)")  prints data
                        for value in posts{
                            let dicValue = value as! NSDictionary
                            self.storesList.append(dicValue)
                            
                        }
                        
                        print(self.storesList.count,"123bv")
                        if self.storesList.count==0
                        {let alert = UIAlertController(title: "Alert", message: "News List Not Available Please Choose Another one", preferredStyle: .alert)
                            let action=UIAlertAction(title: "ok", style: .cancel, handler: { (ACTION) in
                                let condition:Int=UserDefaults.standard.object(forKey: "StateNewsShowCondition") as! Int
                                if condition==0
                                {
                                    let st=UIStoryboard(name: "Main", bundle: nil)
                                    let vc=st.instantiateViewController(withIdentifier: "state") as! UIViewController
                                    self.present(vc, animated: true, completion: nil)
                                }
                                else  if condition==1
                                {
                                    let st=UIStoryboard(name: "Main", bundle: nil)
                                    let vc=st.instantiateViewController(withIdentifier: "selectCity") as! UIViewController
                                    self.present(vc, animated: true, completion: nil)
                                }
                                else if condition==2{
                                    let st=UIStoryboard(name: "Main", bundle: nil)
                                    let vc=st.instantiateViewController(withIdentifier: "selectWard") as! UIViewController
                                    self.present(vc, animated: true, completion: nil)
                                }
                                else
                                {
                                    let st=UIStoryboard(name: "Main", bundle: nil)
                                    let vc=st.instantiateViewController(withIdentifier: "abc") as! UIViewController
                                    self.present(vc, animated: true, completion: nil)
                                }
                                
                                //self.dismiss(animated: false, completion: nil)
                                /* let st=UIStoryboard(name: "Main", bundle: nil)
                                 let vc=st.instantiateViewController(withIdentifier: "abc") as! UIViewController
                                 self.present(vc, animated: true, completion: nil)*/
                                
                                
                            })
                            alert.addAction(action)
                            self.present(alert, animated: true, completion: nil)
                        }
                        if posts.count == 6
                        {self.showValue=self.skip
                            self.skipCondition=1
                            self.skip=self.skip+5
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
                        self.homecollection.dataSource=self
                        self.homecollection.reloadData()
                        self.activityIndicator.stopAnimating()
                    })
                    
                    
                    
                    
                }
            })
            task.resume()
            
            
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            timer.invalidate()
        }
        func runTimer()
        {
            timer = Timer.scheduledTimer(timeInterval: 05, target: self, selector: #selector(StateNewsShowViewController.counter), userInfo: nil, repeats: false)
        }
        @objc func counter() {
            
            
            let usertype:String=UserDefaults.standard.object(forKey: "usertype") as! String
            if usertype != nil
            {topBarView.isHidden=false
                let password="IOS"
                let phoneNumber1=UserDefaults.standard.object(forKey: "phoneNumberStore")! as! String
                let cellIndex:Int = indexVariable
                //let cell = button.superview?.superview as? GeminiCell
                // let indexPath = homecollection.indexPath(for: cell!)
                print("\(cellIndex)+++++++++++")
                
                let simpleEntry : NSDictionary = self.storesList[visibleIndexPathRow]
                var id:String=simpleEntry.object(forKey:"id") as! String
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
            }
            
        }
        func hideTopBarView()
        {
            if topBarView.isHidden==false
            {
                topBarView.isHidden=true
                
            }
            else
            {
                topBarView.isHidden=false
            }
        }
        @objc func astricButtonTapped(sender:UIButton)
        {  if conditionForDelet != 1
            {
            let button = sender as? UIButton
            let cell = button?.superview?.superview as? UICollectionViewCell
            let indexPath = homecollection.indexPath(for: cell!)
            let simpleEntry : NSDictionary = self.storesList[indexPath!.row]
       
            
            
            var astricid=simpleEntry["id"] as! String
            if UserDefaults.standard.object(forKey: "astricString") != nil
            {
                var astricString:String=UserDefaults.standard.object(forKey: "astricString") as! String
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
            else
            {print(visibleIndexPathRow,"visibleIndexPathRow02/06/18")
                print(storesList.count,"storesList.count02/06/18")
                if storesList.count != 1
                {
                    
                    for cell: UICollectionViewCell in self.homecollection.visibleCells {
                        var indexPath: IndexPath? = self.homecollection.indexPath(for: cell)
                        
                        var lastSectionIndex: Int = (self.homecollection?.numberOfSections)! - 1
                        var lastItemIndex: Int = (self.homecollection?.numberOfItems(inSection: lastSectionIndex))! - 1
                        var visibleRect: CGRect = CGRect()
                        visibleRect.origin = (self.homecollection?.contentOffset)!
                        visibleRect.size = (self.homecollection?.bounds.size)!
                        var visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
                        var visibleIndexPath: IndexPath? = self.homecollection?.indexPathForItem(at: visiblePoint)
                        
                        print("\(visibleIndexPath?.row)visibileIndexPath.row")
                        print("\(self.storesList.count-1)storeListCount")
                        print(visibleIndexPath?.row,"bvspVisible")
                         self.visibleIndexPathRow=(visibleIndexPath?.row)!
                        print(visibleIndexPathRow,"visibleIndexPathRow04/06/18")
                    }
                    
                    
                    
                    var astricString:String=UserDefaults.standard.object(forKey: "astricString") as! String
                    
                    print(astricString,"astricString/06/18")
                    
                    var simplyEntry=storesList[visibleIndexPathRow] as! NSDictionary
                    let id=simplyEntry["id"] as! String
                    
                    astricString=astricString.replacingOccurrences(of: "\(id),", with: "")
                    print(astricString,"astricStringAfter02/06/18")
                    UserDefaults.standard.set(astricString, forKey: "astricString")
                    //bookCategory()
                    storesList.remove(at: visibleIndexPathRow)
                    let indexPath = IndexPath(row: visibleIndexPathRow, section: 0)
                    self.homecollection.performBatchUpdates({
                        
                        //  homecollection.deleteItems(at: [indexPath])
                        homecollection.deleteItems(at: [indexPath])
                    }) { (finished) in
                        self.homecollection.reloadData()
                        
                        
                       
                    }
                }
                else
                {
                    UserDefaults.standard.set(nil, forKey: "astricString")
                    let alert=UIAlertController(title: "Alert", message: "KashKhabare are Empty", preferredStyle: .alert)
                    let action=UIAlertAction(title: "Ok", style: .cancel) { (ACTION) in
                        let st=UIStoryboard(name: "Main", bundle: nil)
                        let vc=st.instantiateViewController(withIdentifier: "abc") as! UIViewController
                        self.present(vc, animated: true, completion: nil)
                    }
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                    
                    
                } 
                
            }
        }
        @objc func bookmarkButtonTapped(sender:UIButton)
        {
           
            if conditionForDelet != 0
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
                var bookString:String=bookid
                UserDefaults.standard.set(bookString, forKey: "bookString")
                self.showToast(message: "Added into बुकमार्क्स")
            }
            }
            else
            {print(visibleIndexPathRow,"visibleIndexPathRow02/06/18")
                print(storesList.count,"storesList.count02/06/18")
                if storesList.count != 1
                {
                    
                    for cell: UICollectionViewCell in self.homecollection.visibleCells {
                        var indexPath: IndexPath? = self.homecollection.indexPath(for: cell)
                        
                        var lastSectionIndex: Int = (self.homecollection?.numberOfSections)! - 1
                        var lastItemIndex: Int = (self.homecollection?.numberOfItems(inSection: lastSectionIndex))! - 1
                        var visibleRect: CGRect = CGRect()
                        visibleRect.origin = (self.homecollection?.contentOffset)!
                        visibleRect.size = (self.homecollection?.bounds.size)!
                        var visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
                        var visibleIndexPath: IndexPath? = self.homecollection?.indexPathForItem(at: visiblePoint)
                        
                        print("\(visibleIndexPath?.row)visibileIndexPath.row")
                        print("\(self.storesList.count-1)storeListCount")
                        print(visibleIndexPath?.row,"bvspVisible")
                        self.visibleIndexPathRow=(visibleIndexPath?.row)!
                        print(visibleIndexPathRow,"visibleIndexPathRow04/06/18")
                    }
                    
                    
                    
                    
                var bookString:String=UserDefaults.standard.object(forKey: "bookString") as! String
                 
                print(bookString,"bookString02/06/18")
                var simplyEntry=storesList[visibleIndexPathRow] as! NSDictionary
                let id=simplyEntry["id"] as! String
                
                bookString=bookString.replacingOccurrences(of: "\(id),", with: "")
                print(bookString,"bookStringAfter02/06/18")
                UserDefaults.standard.set(bookString, forKey: "bookString")
                //bookCategory()
                storesList.remove(at: visibleIndexPathRow)
                let indexPath = IndexPath(row: visibleIndexPathRow, section: 0)
                self.homecollection.performBatchUpdates({
                   
                    //  homecollection.deleteItems(at: [indexPath])
                    homecollection.deleteItems(at: [indexPath])
                }) { (finished) in
                    self.homecollection.reloadData()
                    for cell: UICollectionViewCell in self.homecollection.visibleCells {
                        var indexPath: IndexPath? = self.homecollection.indexPath(for: cell)
                        
                        var lastSectionIndex: Int = (self.homecollection?.numberOfSections)! - 1
                        var lastItemIndex: Int = (self.homecollection?.numberOfItems(inSection: lastSectionIndex))! - 1
                        var visibleRect: CGRect = CGRect()
                        visibleRect.origin = (self.homecollection?.contentOffset)!
                        visibleRect.size = (self.homecollection?.bounds.size)!
                        var visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
                        var visibleIndexPath: IndexPath? = self.homecollection?.indexPathForItem(at: visiblePoint)
                        
                        print("\(visibleIndexPath?.row)visibileIndexPath.row")
                        print("\(self.storesList.count-1)storeListCount")
                        print(visibleIndexPath?.row,"bvspVisible")
                        self.visibleIndexPathRow=(visibleIndexPath?.row)!
                    }
                }
                }
                else
                {
                    UserDefaults.standard.set(nil, forKey: "bookString")
                    let alert=UIAlertController(title: "Alert", message: "BookMarks are Empty", preferredStyle: .alert)
                    let action=UIAlertAction(title: "Ok", style: .cancel) { (ACTION) in
                        let st=UIStoryboard(name: "Main", bundle: nil)
                        let vc=st.instantiateViewController(withIdentifier: "abc") as! UIViewController
                        self.present(vc, animated: true, completion: nil)
                    }
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                 
                    
                }
                
            }
          
            
        }
        @objc func astricButtonTappedRemoveRow(sender:UIButton)
        {
            let button = sender as? UIButton
            let cell = button?.superview?.superview as? UICollectionViewCell
            var indexPath = homecollection.indexPath(for: cell!)
            
            print(indexPath!.row,"bvspRemove index")
            
            
            self.remove(indexPath!.row)
            
            if UserDefaults.standard.object(forKey: "astricDictionay") != nil
            {var dummyDict:[NSDictionary]=UserDefaults.standard.object(forKey: "astricDictionay") as! [NSDictionary]
                dummyDict.remove(at: (indexPath!.row))
                
                astricDictionay.append(contentsOf: dummyDict)
                UserDefaults.standard.set(astricDictionay, forKey: "astricDictionay")
                self.showToast(message: "removed from ख़ास ख़बरें")
                //homecollection.reloadData()
                
                
                
            }
            else{
                self.showToast(message: "ख़ास ख़बरें is empty")
            }
            
            
            
        }
        func remove(_ i: Int) {
            
            storesList.remove(at: i)
            
            let indexPath = IndexPath(row: i, section: 0)
            
            self.homecollection.performBatchUpdates({
                self.homecollection.deleteItems(at: [indexPath])
            }) { (finished) in
                self.homecollection.reloadItems(at: self.homecollection.indexPathsForVisibleItems)
               
            }
            
        }
        
        
        @objc func bookmarkButtonTappedRemoveRow(sender:UIButton)
        {
            let button = sender as? UIButton
            let cell = button?.superview?.superview as? UICollectionViewCell
            let indexPath = homecollection.indexPath(for: cell!)
            let simpleEntry : NSDictionary = self.storesList[indexPath!.row]
            if UserDefaults.standard.object(forKey: "bookDictionay") != nil
            {var dummyDict:[NSDictionary]=UserDefaults.standard.object(forKey: "bookDictionay") as! [NSDictionary]
                bookDictionay.append(simpleEntry)
                bookDictionay.append(contentsOf: dummyDict)
                
                UserDefaults.standard.set(bookDictionay, forKey: "bookDictionay")
            }
            else{
                bookDictionay.append(simpleEntry)
                UserDefaults.standard.set(bookDictionay, forKey: "bookDictionay")
            }
            self.showToast(message: "Added intoबुकमार्क्स")
            
        }
        
        
        @objc func shareButtontapped(sender: UIButton!)
        {
            
            let bounds = UIScreen.main.bounds
            UIGraphicsBeginImageContextWithOptions(bounds.size, true, 0.0)
            self.view.drawHierarchy(in: bounds, afterScreenUpdates: false)
            let img = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            let activityViewController = UIActivityViewController(activityItems: [img!], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            self.present(activityViewController, animated: true, completion: nil)
        }
        
        
        @IBAction func nextPage(_ sender: UIButton) {
           let st=UIStoryboard(name: "Main", bundle: nil)
                let vc=st.instantiateViewController(withIdentifier: "abc") as! UIViewController
                self.present(vc, animated: true, completion: nil)
            
      
        }
        func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
            
            
            /* if indexPath.row==0
             {indexVariable=indexPath.row
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
             {indexVariable=indexPath.row-1
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
            let cell=homecollection.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! BookAndMarkCollectionViewCell
            
            cell.layer.cornerRadius=10
            //indexVariable=indexPath.row
            
            var storeList=storesList[indexPath.row] as! NSDictionary
            
            var image1:String!
            
            
            
            image1=storeList.object(forKey: "image") as! String
            print("image1 value\(image1!)")
            let numberCheck200=UserDefaults.standard.object(forKey: "category") as! String
            print(numberCheck200)
            
            if  Int(numberCheck200) == 200
            {
                
                if storeList["id"] as! String == "0"
                {cell.backgroundColor=UIColor.black
                    
                    
                    
                    cell.title2.isHidden=true
                    cell.title.isHidden=true
                    cell.title2.isHidden=true
                    cell.astric.isHidden=true
                    cell.bookmark.isHidden=true
                    cell.time.isHidden=true
                    cell.smallImage.isHidden=true
                    cell.shareButton.isHidden=true
                    cell.ReadMoreButton.isHidden=true
                    cell.label1.isHidden=true
                    cell.image1.layer.cornerRadius=10
                    cell.image1.frame=CGRect(x:0, y:0, width: self.view.bounds.width, height: self.view.bounds.height)
                    cell.image1.sd_setImage(with: URL(string: image1!), placeholderImage: UIImage(named: "placeholder.png"))
                    
                    
                    
                }
                else{
                    cell.backgroundColor=UIColor.white
                    let simpleEntry : NSDictionary = self.storesList[indexPath.row]
                    var photonamelink:String=simpleEntry["image"] as! String
                    /*  DispatchQueue.global().async {
                     let url = URL(string: "\(photonamelink!)")
                     
                     let imageData = try? Data(contentsOf: url!)
                     
                     DispatchQueue.main.async {
                     
                     cell.image1.image = UIImage(data: imageData!)
                     
                     cell.image1.frame=CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 236)
                     }
                     }*/
                    var smallImage:String=simpleEntry["publisher_image"] as! String
                    /* DispatchQueue.global().async {
                     let url = URL(string: "\(smallImage!)")
                     
                     let imageData = try? Data(contentsOf: url!)
                     
                     DispatchQueue.main.async {
                     
                     cell.smallImage.image = UIImage(data: imageData!)
                     
                     
                     }
                     }*/
                    var image=UIImage(named: "delet50.png") as! UIImage
                    cell.astric.isHidden=false
                    cell.astric.addTarget(self, action:#selector(astricButtonTapped), for: .touchUpInside)
                    cell.bookmark.isHidden=false
                    cell.bookmark.setImage(image, for: .normal)
                   cell.bookmark.addTarget(self, action:#selector(bookmarkButtonTapped), for: .touchUpInside)
                    cell.shareButton.isHidden=false
                    cell.title2.isHidden=false
                    cell.title.isHidden=false
                    cell.title2.isHidden=false
                    
                    
                    cell.time.isHidden=false
                    cell.smallImage.isHidden=false
                    cell.ReadMoreButton.isHidden=false
                    cell.label1.isHidden=false
                    
                    cell.title2.font=UIFont.boldSystemFont(ofSize: 21.0)
                    DispatchQueue.main.async {
                        cell.title.text = "\(simpleEntry["description"]!)".htmlAttributedString?.string
                        cell.title.font = UIFont(name:"Avenir", size:16)
                    }
                    cell.title2.text = "\(simpleEntry["title"]!)"
                    cell.time.text = simpleEntry["time"] as? String
                    cell.title.font = UIFont(name:"Avenir", size:16)
                    cell.image1.layer.cornerRadius=0
                    //cell.image1.frame=CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 298)
                    if self.screenHeight==558
                    {
                        cell.image1.frame=CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height/2-50)
                        cell.image1Height.constant=self.view.bounds.height/2-50
                    }
                    else if self.screenHeight==667
                    {
                        cell.image1.frame=CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height/2-40)
                        cell.image1Height.constant=self.view.bounds.height/2-40
                    }
                    else if self.screenHeight>667
                    {
                        cell.image1.frame=CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height/2)
                        cell.image1Height.constant=self.view.bounds.height/2
                    }
                    else
                    {cell.image1.frame=CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 250)
                        cell.image1Height.constant=250
                    }
                    cell.image1.sd_setImage(with: URL(string: image1!), placeholderImage: UIImage(named: "placeholder.png"))
                    cell.smallImage.sd_setImage(with: URL(string: smallImage), placeholderImage: UIImage(named: "placeholder.png"))
                    
                    
                    
                    cell.shareButton.layer.cornerRadius=5
                    cell.shareButton.layer.borderWidth=2
                    cell.shareButton.layer.borderColor=UIColor.orange.cgColor
                    cell.shareButton.addTarget(self, action:#selector(shareButtontapped), for: .touchUpInside)
                    cell.ReadMoreButton.addTarget(self, action:#selector(webView), for: .touchUpInside)
                    // cell.tabButton.addTarget(self, action:#selector(tabButtonTapped), for: .touchUpInside)
                    
                }
            }
            else {
                if storeList["id"] as! String == "0"
                {cell.backgroundColor=UIColor.black
                    
                    
                    
                    cell.title2.isHidden=true
                    cell.title.isHidden=true
                    cell.title2.isHidden=true
                    cell.astric.isHidden=true
                    cell.bookmark.isHidden=true
                    cell.time.isHidden=true
                    cell.smallImage.isHidden=true
                    cell.shareButton.isHidden=true
                    cell.ReadMoreButton.isHidden=true
                    cell.label1.isHidden=true
                    cell.image1.layer.cornerRadius=10
                    cell.image1.frame=CGRect(x:0, y:0, width: self.view.bounds.width, height: self.view.bounds.height)
                    cell.image1.sd_setImage(with: URL(string: image1!), placeholderImage: UIImage(named: "placeholder.png"))
                    
                    
                    
                }
                else{
                    cell.backgroundColor=UIColor.white
                    let simpleEntry : NSDictionary = self.storesList[indexPath.row]
                    var photonamelink:String=simpleEntry["image"] as! String
                    /*  DispatchQueue.global().async {
                     let url = URL(string: "\(photonamelink!)")
                     
                     let imageData = try? Data(contentsOf: url!)
                     
                     DispatchQueue.main.async {
                     
                     cell.image1.image = UIImage(data: imageData!)
                     
                     cell.image1.frame=CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 236)
                     }
                     }*/
                    var smallImage:String=simpleEntry["publisher_image"] as! String
                    /* DispatchQueue.global().async {
                     let url = URL(string: "\(smallImage!)")
                     
                     let imageData = try? Data(contentsOf: url!)
                     
                     DispatchQueue.main.async {
                     
                     cell.smallImage.image = UIImage(data: imageData!)
                     
                     
                     }
                     }*/
                     var image=UIImage(named: "delet50.png") as! UIImage
                    cell.astric.isHidden=false
                    cell.astric.setImage(image, for: .normal)
                    cell.astric.addTarget(self, action:#selector(astricButtonTapped), for: .touchUpInside)
                    cell.bookmark.isHidden=false
                    cell.bookmark.addTarget(self, action:#selector(bookmarkButtonTapped), for: .touchUpInside)
                    cell.shareButton.isHidden=false
                    cell.title2.isHidden=false
                    cell.title.isHidden=false
                    cell.title2.isHidden=false
                    
                    
                    cell.time.isHidden=false
                    cell.smallImage.isHidden=false
                    cell.ReadMoreButton.isHidden=false
                    cell.label1.isHidden=false
                    
                    cell.title2.font=UIFont.boldSystemFont(ofSize: 21.0)
                    DispatchQueue.main.async {
                        cell.title.text = "\(simpleEntry["description"]!)".htmlAttributedString?.string
                        cell.title.font = UIFont(name:"Avenir", size:16)
                    }
                    cell.title2.text = "\(simpleEntry["title"]!)"
                    cell.time.text = simpleEntry["time"] as? String
                    cell.title.font = UIFont(name:"Avenir", size:16)
                    cell.image1.layer.cornerRadius=0
                    //cell.image1.frame=CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 298)
                    if self.screenHeight==558
                    {
                        cell.image1.frame=CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height/2-50)
                        cell.image1Height.constant=self.view.bounds.height/2-50
                    }
                    else if self.screenHeight==667
                    {
                        cell.image1.frame=CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height/2-40)
                        cell.image1Height.constant=self.view.bounds.height/2-40
                    }
                    else if self.screenHeight>667
                    {
                        cell.image1.frame=CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height/2)
                        cell.image1Height.constant=self.view.bounds.height/2
                    }
                    else
                    {cell.image1.frame=CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 250)
                        cell.image1Height.constant=250
                    }
                    cell.image1.sd_setImage(with: URL(string: image1!), placeholderImage: UIImage(named: "placeholder.png"))
                    cell.smallImage.sd_setImage(with: URL(string: smallImage), placeholderImage: UIImage(named: "placeholder.png"))
                    
                    
                    
                    cell.shareButton.layer.cornerRadius=5
                    cell.shareButton.layer.borderWidth=2
                    cell.shareButton.layer.borderColor=UIColor.orange.cgColor
                    cell.shareButton.addTarget(self, action:#selector(shareButtontapped), for: .touchUpInside)
                    cell.ReadMoreButton.addTarget(self, action:#selector(webView), for: .touchUpInside)
                    // cell.tabButton.addTarget(self, action:#selector(tabButtonTapped), for: .touchUpInside)
                    
                }
            }
            
            return cell
        }
        
        
        /*  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         let simpleEntry : NSDictionary = self.storesList[indexPath.row]
         var urlLink:String=simpleEntry.object(forKey:"url") as! String
         UserDefaults.standard.set(urlLink, forKey: "urlLink")
         var publisherLink:String=simpleEntry.object(forKey:"publisher_image") as! String
         UserDefaults.standard.set(publisherLink, forKey: "publisherLink")
         print("\(urlLink)bvsp")
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
                
                print("\(visibleIndexPath?.row)visibileIndexPath.row")
                print("\(storesList.count-1)storeListCount")
                print(visibleIndexPath?.row,"bvspVisible")
                visibleIndexPathRow=(visibleIndexPath?.row)!
                
                var storeList=storesList[visibleIndexPathRow] as! NSDictionary
                timer.invalidate()
                print(visibleIndexPathRow,"indexpathRowValue")
                print(storeList["id"],"storeList(id)")
                indexVariable=visibleIndexPathRow
                
               /* if storeList["id"] as! String != "0"
                {
                    self.timer = Timer.scheduledTimer(timeInterval:5, target: self, selector: #selector(HomeView.counter), userInfo: nil, repeats: false)
                    
                    
                }
                */
                
                if visibleIndexPath?.row==storesList.count-3
                {if skipConditionStatus==true
                {CollectionViewIndex=1
                    
                    }
                }
                /*22/05/18 if lastItemIndex == visibleIndexPath?.row {
                 CollectionViewIndex = 1
                 if skipConditionStatus==true
                 {
                 self.skipCondition=0
                 self.downLoadAds()
                 DispatchQueue.main.async {
                 
                 }
                 }
                 
                 }*/
                if visibleIndexPath?.row == 0
                {
                    refreshCount = refreshCount+1
                    print(refreshCount)
                    if refreshCount==2
                    {
                        refreshCount=0
                       // refreshAutomatic()
                    }
                }
            }
        }
        func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
            topBarView.isHidden = true
            if CollectionViewIndex==1
            {if skipConditionStatus==true
            {
                skipCondition=0
                let numberCheck200=UserDefaults.standard.object(forKey: "category") as! String
                
                if Int(numberCheck200) == 200{
                    self.bookCategory()
                }
                else if Int(numberCheck200) == 300
                {
                    self.astricCategory()
                }
                
                
                }
                
                
            }
            
        }
        
        /*func refreshAutomatic()
        {
            print("refreshing The data Automatically")
            refreshCount=0
            
            /*   var width=(self.view.bounds.width/2)-20
             var height=(self.view.bounds.height/2)-20
             activityIndicator.frame=CGRect(x:width, y: height, width: 40, height: 40)
             activityIndicator.activityIndicatorViewStyle=UIActivityIndicatorViewStyle.whiteLarge
             activityIndicator.backgroundColor=UIColor.darkGray
             self.view.addSubview(activityIndicator)
             activityIndicator.startAnimating()
             activityIndicator.hidesWhenStopped=true
             */
            
            self.gettingCategoryList()
            self.activityIndicator.isHidden=true
            self.showToast(message: "Updated data")
        }*/
        
    }

    // MARK: - UICollectionViewDelegate


    extension BookAndMarkViewController: UIGestureRecognizerDelegate {
        @objc func handleTap(_ gesture: UITapGestureRecognizer){
            print("doubletapped")
            hideTopBarView()
            
        }
    }


