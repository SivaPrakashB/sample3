//
//  ViewController.swift
//  NaradPosts
//
//  Created by Narayan on 2/16/18.
//  Copyright © 2018 Narayan. All rights reserved.
///

import UIKit
import LTMorphingLabel
class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,LTMorphingLabelDelegate{
    
    var dynamicURl=String()
    var tm=1000
    @IBOutlet weak var registerButton:UIButton!
    @IBOutlet weak var blinkingView:UIView!
    @IBAction func shareButton(_ sender: UIButton)
    {
        var share_link:String="https://itunes.apple.com/us/app/naradpost/id1357606717?ls=1&mt=8" as! String
        
        let myWebsite = NSURL(string:share_link)
        //let img: UIImage = image!
        print("\(myWebsite)**********")
        guard let url = myWebsite else {
            print("nothing found")
            return
        }
        
        ////whats appp Image Code
       
        /////////////////////////////////
  
        let img = UIImage(named: "AppShareImage.jpg")
       
        let shareItems:Array = [img!, url]
        let activityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
       
        
    }
    
var storesList = [NSDictionary]()
   
    var name = [String]()
    var pics = [String]()
    var ids = [String]()
    var updateTime = [String]()
   
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
        // Do any additional setup after loading the view, typically from a nib.
        /*registerButton.layer.cornerRadius=10
        registerButton.layer.borderWidth=3
        registerButton.layer.borderColor=UIColor.darkGray.cgColor*/
     DispatchQueue.main.async{
            UIView.animate(withDuration:1.0, delay:3.0, options: [.curveEaseOut, .autoreverse, .repeat], animations: {
                //self.blinking12345.alpha = 1.0
                
            }, completion: nil)
        }
     
        gettingCategoryList()
       
    self.collectionView1.reloadData()
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func homePage(_ sender: UIButton) {
       UserDefaults.standard.set(nil, forKey: "category")
        let storyboard=UIStoryboard(name: "Main", bundle: nil)
        let vc=storyboard.instantiateViewController(withIdentifier: "Home") as! UIViewController
        self.present(vc, animated: true, completion: nil)
      //  dismiss(animated: true, completion: nil)
    }
    /*UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
 UIViewController *smallViewController = [storyboard instantiateViewControllerWithIdentifier:@"bigViewController"];
     @IBAction func menu(_ sender: UIButton) {
     }
     
 BIZPopupViewController *popupViewController = [[BIZPopupViewController alloc] initWithContentViewController:smallViewController contentSize:CGSizeMake(300, 400)];
 [self presentViewController:popupViewController animated:NO completion:nil];
 */
    
    @IBAction func pramukKabhare(_ sender: Any) {
        var id:String="0"
       
        UserDefaults.standard.set("\(id)", forKey: "category")
        
        var name:String="प्रमुख खबरें" as! String
        UserDefaults.standard.set("\(name)", forKey: "name")
      
        let storyboard=UIStoryboard(name: "Main", bundle: nil)
        let vc=storyboard.instantiateViewController(withIdentifier: "Home1") as! UIViewController
        present(vc, animated: true, completion: nil)
        
        
        
        
    }
    
    @IBAction func astric(_ sender: UIButton) {
        if UserDefaults.standard.object(forKey: "astricString") != nil
        {
            let astricString:String=UserDefaults.standard.object(forKey: "astricString") as! String
            print(astricString,"rock")
            if  astricString.count>1
            {
        var id:String="300"
        
        UserDefaults.standard.set("\(id)", forKey: "category")
        
        var name:String="ख़ास ख़बरें" as! String
        UserDefaults.standard.set("\(name)", forKey: "name")
        
        let storyboard=UIStoryboard(name: "Main", bundle: nil)
        let vc=storyboard.instantiateViewController(withIdentifier: "BookAndMark") as! UIViewController
        present(vc, animated: true, completion: nil)
        }
        else{
                   self.showToast(message: "ख़ास ख़बरें are emty")
        }
        }
        else
        {
            self.showToast(message: "ख़ास ख़बरें are emty")
        }
        
        
        
        
    }
    
    
    @IBAction func bookmark(_ sender: UIButton) {
        if UserDefaults.standard.object(forKey: "bookString") != nil
        {
        let bookString:String=UserDefaults.standard.object(forKey: "bookString") as! String
       // print(bookString,"rock")
      if  bookString.count>1
      {
        
        var id:String="200"
        
        UserDefaults.standard.set("\(id)", forKey: "category")
        
        var name:String="बुकमार्क्स" as! String
        UserDefaults.standard.set("\(name)", forKey: "name")
        
        let storyboard=UIStoryboard(name: "Main", bundle: nil)
        let vc=storyboard.instantiateViewController(withIdentifier: "BookAndMark") as! UIViewController
        present(vc, animated: true, completion: nil)
        
        }
      else{
        self.showToast(message: "book marks are emty")
        }
        }
        else
        {
            self.showToast(message: "book marks are emty")
        }
    }
    
    
    @IBAction func closeButton(_ sender: UIButton) {
        
        let storyBoard=UIStoryboard(name: "Main", bundle: nil)
        let vc=storyboard?.instantiateViewController(withIdentifier: "Home") as! UIViewController
        presentDetailRight(vc)
        
        
    }
    
    
    @IBOutlet weak var blinking12345: UIView!
    @IBOutlet weak var collectionView1: UICollectionView!
    
    func gettingCategoryList()
    {
        tm=tm+1
        //       let urlString = RequiredURLS().storesUrl
        //   print("urlString : \(urlString)")
        let url = URL(string: dynamicURl+"GetCategory.php?tm=\(tm)")
        
        
        
        //http://naradpost.news/WebServices/getCategory
        
        
        
        URLSession.shared.dataTask(with:url!)
        { (data, response, error) in
            if error != nil {
                print(error)
            }
            else {
                do{
                    let resultJSON = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                let category=resultJSON["posts"] as! [NSDictionary]
                    
                   print("******\(category)")
                    for value in category{
                        let dicValue = value as! NSDictionary
                        self.storesList.append(dicValue)
                        self.name.append(dicValue.object(forKey: "name") as! String)
                        self.pics.append(dicValue.object(forKey: "pics") as! String)
                        self.ids.append(dicValue.object(forKey: "id") as! String)
                        self.updateTime.append(dicValue.object(forKey: "updated_at") as! String)
                      
                    }
                      print("***\(self.storesList)***")
                }
                catch {
                    print("Received not-well-formatted JSON")
                }
               
                
          
            }
            DispatchQueue.main.async(execute: {
                self.collectionView1.reloadData()
            })
            
            }.resume()
    }
    
    
   
    
   
    /*    if viewabc.isHidden==true
        {
            viewabc.isHidden=false
        }
        else
        {
            viewabc.isHidden=true
        }*/
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return storesList.count-1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView1.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell1
        
        let simpleEntry : NSDictionary = self.storesList[indexPath.row]
       
            cell.name1.morphingEnabled=true
            cell.name1.delegate=self
            cell.name1.morphingEffect =  .evaporate
            
        cell.name1.text = simpleEntry["name"] as? String
        
        print("\(simpleEntry["name"])")
        /* websiteurl=simpleEntry["websitenae"] as String
         print(websiteurl)
         let url1=NSURL(string: websiteurl) as! URL
         
         UIApplication.shared.open(url1, options: [:], completionHandler: nil)*/
        
        //cell.location.text = simpleEntry["location"] as? String
        //let img = simpleEntry.object(forKey: "image") as! String
        // OperationQueue.main.addOperation{
        // print("image name:\(img)")
        
        //cell.photo.downloadImageFrom(link: "http://zenith.instest.net/groceryapi/public/img/", contentMode:.scaleToFill)
        
        
        var photonamelink:String=simpleEntry["pics"] as! String
        cell.image1.sd_setImage(with: URL(string: photonamelink), placeholderImage: UIImage(named: "placeholder.png"))
             cell.image1.layer.cornerRadius = 10
            cell.image1.layer.borderWidth = 2
       let myColor : UIColor = UIColor( red: 45/225, green: 98/255, blue:220/225, alpha: 1.0 )
           cell.image1.layer.masksToBounds = true
        cell.image1.layer.borderColor = myColor.cgColor
            //cell.image1.layer.borderColor = UIColor.blue.cgColor
    /*    DispatchQueue.global().async {
            let url = URL(string: "\(photonamelink!)")
            
            let imageData = try? Data(contentsOf: url!)
            
            DispatchQueue.main.async {
                
                cell.image1.image = UIImage(data: imageData!)
                
                
            }
        }*/
      
        return cell
    }
    
   
    

    
    
    
   /* func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool
    {
        if menuView.isHidden==true
        {
            menuView.isHidden=false
        }
        else
        {
            menuView.isHidden=true
        }
        return true
    }*/
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         let simpleEntry : NSDictionary = self.storesList[indexPath.row]
        var id:String=simpleEntry.object(forKey: "id") as! String
        var name:String=simpleEntry.object(forKey: "name") as! String
         UserDefaults.standard.set("\(name)", forKey: "name")
        UserDefaults.standard.set("\(id)", forKey: "category")
        let storyboard=UIStoryboard(name: "Main", bundle: nil)
        let vc=storyboard.instantiateViewController(withIdentifier: "Home1") as! UIViewController
        presentDetailRight(vc)
    }
}
extension ViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow:CGFloat = 3
        let hardCodedPadding:CGFloat = 5
        let itemWidth = (collectionView1.bounds.width / itemsPerRow) - 15
        
        return CGSize(width: itemWidth, height: 160)
    }
}

