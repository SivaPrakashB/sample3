//
//  SelectCountryViewController.swift
//  NaradPosts
//
//  Created by Narayan on 5/25/18.
//  Copyright © 2018 Narayan. All rights reserved.
//

import UIKit

class SelectCountryViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource{
    
    @IBOutlet weak var shadowView: UIView!
    var countryIDS=[String]()
    var countryNames=[String]()
    var countryImageURlLinks=[String]()
    var time:Int=810
    var dynamicURl=String()
  
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return countryIDS.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=countryCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CountrySelectCollectionViewCell
       
        DispatchQueue.global().async {
            let url = URL(string: "\(self.countryImageURlLinks[indexPath.row])")
            
            let imageData = try? Data(contentsOf: url!)
            
            DispatchQueue.main.sync {
                
                cell.image1.image = UIImage(data: imageData!)
                
            }
        }
    cell.stateSelect.setTitle(countryNames[indexPath.row], for: .normal)
        //setTitle(countryNames[indexPath.row])
        cell.stateSelect.addTarget(self, action:#selector(selectState1), for: .touchUpInside)
        //cell..addTarget(self, action:#selector(viewNews), for: .touchUpInside)
        cell.countryNewsShow.addTarget(self, action: #selector(viewNews), for: .touchUpInside)
       
        return cell
    }
   
    @IBOutlet weak var countryCollectionView: UICollectionView!
   
    @IBAction func close(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOpacity = 1
        shadowView.layer.shadowOffset = CGSize.zero
        shadowView.layer.shadowRadius = 8
        shadowView.layer.shouldRasterize = true
        
        shadowView.layer.shadowPath = UIBezierPath(rect: shadowView.bounds).cgPath
        
        
        
      /*  let tapGR = UITapGestureRecognizer(target: self, action: #selector(HomeView.handleTap(_:)))
        tapGR.delegate = self
        tapGR.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGR)*/
        if UserDefaults.standard.object(forKey: "dynamicURL") != nil && UserDefaults.standard.object(forKey: "dynamicURL")as! String != ""
        {
            dynamicURl=UserDefaults.standard.object(forKey: "dynamicURL") as! String
        }
        else
        {
            dynamicURl=staticURL
        }
        getCountryList()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func getCountryList()
    {
        let date = Date()
        let calendar = Calendar.current
        
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        time=seconds
        
        //       let urlString = RequiredURLS().storesUrl
        //   print("urlString : \(urlString)")
        let url = URL(string: dynamicURl+"GetCountries.php?tm=\(time)")
        
        URLSession.shared.dataTask(with:url!)
        { (data, response, error) in
            if error != nil {
                print(error)
            }
            else {
                do{
                    let resultJSON = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                    print(resultJSON,"250718")
                    let dummyArray=resultJSON.object(forKey: "posts") as! [NSDictionary]
                    for value in dummyArray
                    {
                        var dummyDict=value as! NSDictionary
                        self.countryIDS.append(dummyDict.object(forKey: "id")! as! String)
                        self.countryNames.append(dummyDict.object(forKey: "name") as! String)
                        self.countryImageURlLinks.append(dummyDict.object(forKey: "url") as! String )
                    }
                    print(resultJSON,"11111")
                }
                catch {
                    print("Received not-well-formatted JSON")
                }
              
            }
            DispatchQueue.main.async(execute: {
                self.countryCollectionView.reloadData()
                //self.imageView.isHidden=true
                self.view.isUserInteractionEnabled=true
            })
            
            }.resume()
    }

   
   
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        UserDefaults.standard.set(countryIDS[indexPath.row], forKey: "countryID")
       
        let st=UIStoryboard(name: "Main", bundle: nil)
        let vc=st.instantiateViewController(withIdentifier: "state") as! UIViewController
        self.present(vc, animated: true, completion: nil)
    }

    
    @objc func selectState1(sender: UIButton!)
    { let button = sender as? UIButton
        let cell = button?.superview?.superview?.superview as? UICollectionViewCell
        let indexPath = countryCollectionView.indexPath(for: cell!)
        /* let simpleEntry : NSDictionary = self.storesList[indexPath!.row]
         var urlLink:String=simpleEntry.object(forKey:"url") as! String
         UserDefaults.standard.set(urlLink, forKey: "urlLink")
         print("\(urlLink)bvsp")
         var publisherLink:String=simpleEntry.object(forKey:"publisher_image") as! String*/
        UserDefaults.standard.set(countryIDS[indexPath!.row], forKey: "countryID")
        
        let storyboard=UIStoryboard(name: "Main", bundle: nil)
        let vc=storyboard.instantiateViewController(withIdentifier: "state") as! UIViewController
        self.present(vc, animated: true, completion: nil)
    }
    @objc func viewNews(sender: UIButton!)
    { let button = sender as? UIButton
        let cell = button?.superview?.superview?.superview as? UICollectionViewCell
        let indexPath = countryCollectionView.indexPath(for: cell!)
        /* let simpleEntry : NSDictionary = self.storesList[indexPath!.row]
         var urlLink:String=simpleEntry.object(forKey:"url") as! String
         UserDefaults.standard.set(urlLink, forKey: "urlLink")
         print("\(urlLink)bvsp")
         var publisherLink:String=simpleEntry.object(forKey:"publisher_image") as! String*/
       // let countryID:String=UserDefaults.standard.object(forKey: "countryID") as! String
        UserDefaults.standard.set(countryIDS[indexPath!.row], forKey: "countryID")
        //UserDefaults.standard.set(4, forKey: "StateNewsShowCondition")
        var getNewsUrl:String=dynamicURl+"GetNewsByLocations_with_ads.php?country=\(countryIDS[indexPath!.row])&state=0&city=0&ward=0"
        UserDefaults.standard.set(getNewsUrl, forKey: "getNewsUrl")
        UserDefaults.standard.set(4, forKey: "StateNewsShowCondition")
        let storyboard=UIStoryboard(name: "Main", bundle: nil)
        let vc=storyboard.instantiateViewController(withIdentifier: "StateNewsShow") as! UIViewController
        UIApplication.topViewController()?.present(vc, animated: true, completion: nil)
    }
  
}
extension SelectCountryViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow:CGFloat = 3
        let hardCodedPadding:CGFloat = 5
        let itemWidth = (countryCollectionView.bounds.width/itemsPerRow)-10
        
        return CGSize(width: itemWidth, height: 127)
    }
   /* override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: true, completion: nil)
    }*/
}
/*extension SelectCountryViewController: UIGestureRecognizerDelegate {
    @objc func handleTap(_ gesture: UITapGestureRecognizer){
        print("doubletapped")
        dismiss(animated: true, completion: nil)
    }
}*/
