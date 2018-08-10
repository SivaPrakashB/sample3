//
//  StatesViewController.swift
//  NaradPosts
//
//  Created by Narayan on 5/18/18.
//  Copyright © 2018 Narayan. All rights reserved.
//

import UIKit

class StatesViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    var stateNamesArray=[String]()
    var stateIDArray=[String]()
    var dynamicURl=String()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stateNamesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell=statesCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! StatesCollectionViewCell
        cell.statesNamesButton.setTitle(stateNamesArray[indexPath.row], for: .normal)
        cell.viewNewsButton.setTitle("View News", for: .normal)
        let myColor : UIColor = UIColor( red: 45/225, green: 98/255, blue:220/225, alpha: 1.0 )
        cell.statesNames.layer.masksToBounds = true
        cell.statesNames.layer.borderWidth=1
        cell.statesNames.layer.cornerRadius=4
      
        cell.statesNames.layer.borderColor = myColor.cgColor
        cell.statesNamesButton.addTarget(self, action:#selector(selectCity), for: .touchUpInside)
          cell.viewNewsButton.addTarget(self, action:#selector(viewNews), for: .touchUpInside)
        return cell
        
    }
    var imageView=UIImageView()

    @IBOutlet weak var statesCollectionView: UICollectionView!
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
        let jeremyGif = UIImage.gifImageWithName("abc1234")
        imageView = UIImageView(image: jeremyGif)
        
        imageView.frame = CGRect(x: (self.view.frame.size.width/2) - 40 , y: (self.view.frame.size.height/2)-40, width: 80, height: 80)
        self.view.addSubview(imageView)
        self.view.isUserInteractionEnabled=false
       
        
    }
    override func viewDidAppear(_ animated: Bool) {
        getStateNames()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var close: NSLayoutConstraint!
    var time:Int=410
    func getStateNames()
    {//http://thenaradnews.com/WService/GetStates.php?CountryID=1&tm=11
        //http://thenaradnews.com/WService/GetNewsByLocations.php?state=22&city=15&ward=0&skip=1&get=1
        let countryID=UserDefaults.standard.object(forKey: "countryID") as! String
        //       let urlString = RequiredURLS().storesUrl
        //   print("urlString : \(urlString)")
        let date = Date()
        let calendar = Calendar.current
        
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        time=seconds
        let url = URL(string: dynamicURl+"GetStates.php?CountryID=\(countryID)&tm=\(time)")
        
        URLSession.shared.dataTask(with:url!)
        { (data, response, error) in
            if error != nil {
                print(error)
            }
            else {
                do{
                    let resultJSON = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                    let dummyArray=resultJSON.object(forKey: "posts") as! [NSDictionary]
                    for value in dummyArray
                    {
                        var dummyDict=value as! NSDictionary
                        self.stateIDArray.append(dummyDict.object(forKey: "id")! as! String)
                        self.stateNamesArray.append(dummyDict.object(forKey: "name") as! String)
                    }
                    print(resultJSON,"11111")
                    if dummyArray.count==0
                    {/*DispatchQueue.main.async {
                         self.imageView.isHidden=true
                         self.view.isUserInteractionEnabled=true
                         }*/
                        
                        let alert = UIAlertController(title: "Alert", message: "State List Not Available Please Choose Another one", preferredStyle: .alert)
                        let action=UIAlertAction(title: "ok", style: .cancel, handler: { (ACTION) in
                            let st=UIStoryboard(name: "Main", bundle: nil)
                            let vc=st.instantiateViewController(withIdentifier: "abc") as! UIViewController
                            self.present(vc, animated: true, completion: nil)
                            
                        })
                        alert.addAction(action)
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                }
                catch {
                    print("Received not-well-formatted JSON")
                }
               
                
            }
            DispatchQueue.main.async(execute: {
                self.statesCollectionView.reloadData()
                self.imageView.isHidden=true
                self.view.isUserInteractionEnabled=true
            })
           
            }.resume()
    }
    
    @objc func selectCity(sender: UIButton!)
    { let button = sender as? UIButton
        let cell = button?.superview?.superview?.superview as? UICollectionViewCell
        let indexPath = statesCollectionView.indexPath(for: cell!)
     
       UserDefaults.standard.set(stateIDArray[indexPath!.row], forKey: "stateID")
        
        
        let storyboard=UIStoryboard(name: "Main", bundle: nil)
        let vc=storyboard.instantiateViewController(withIdentifier: "selectCity") as! UIViewController
        self.present(vc, animated: true, completion: nil)
    }
    @objc func viewNews(sender: UIButton!)
    { let button = sender as? UIButton
        let cell = button?.superview?.superview?.superview as? UICollectionViewCell
        let indexPath = statesCollectionView.indexPath(for: cell!)
       
        let countryID:String=UserDefaults.standard.object(forKey: "countryID") as! String
        UserDefaults.standard.set(stateIDArray[indexPath!.row], forKey: "stateID")
        
        var getNewsUrl:String=dynamicURl+"GetNewsByLocations_with_ads.php?country=\(countryID)&state=\(stateIDArray[indexPath!.row])&city=0&ward=0"
        UserDefaults.standard.set(getNewsUrl, forKey: "getNewsUrl")
        UserDefaults.standard.set(0, forKey: "StateNewsShowCondition")
        let storyboard=UIStoryboard(name: "Main", bundle: nil)
        let vc=storyboard.instantiateViewController(withIdentifier: "StateNewsShow") as! UIViewController
    UIApplication.topViewController()?.present(vc, animated: true, completion: nil)
    }
    
   
    
}
extension StatesViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow:CGFloat = 3
        let hardCodedPadding:CGFloat = 5
        let itemWidth = (statesCollectionView.bounds.width / itemsPerRow) - 15
        
        return CGSize(width: itemWidth, height: 62)
    }
}
extension UIApplication
{
    class func topViewController(base:UIViewController?=UIApplication.shared
        .keyWindow?.rootViewController)->UIViewController?{
        if let nav=base as? UINavigationController{
            return topViewController(base:nav.visibleViewController)
        }
        if let tab=base as? UITabBarController{
            if let selected = tab.selectedViewController{
                return topViewController(base:selected)
            }
        }
        if let presented=base?.presentedViewController{
            return topViewController(base:presented)
        }
        
        return base
    }
    
}
