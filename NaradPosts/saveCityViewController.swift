//
//  saveCityViewController.swift
//  NaradPosts
//
//  Created by Apple on 06/07/18.
//  Copyright © 2018 Narayan. All rights reserved.
//

import UIKit
protocol customeDelegate
{
   func dataSaved(name:String,CountryID:String,StateID:String,CityID:String)
    
}
class saveCityViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var countryID=String()
    var stateID=String()
    var cityID=String()
    var cityName=String()
    var countryNameList=[String]()
    var countryIDList=[String]()
    var stateNameList=[String]()
    var stateIDList=[String]()
    var cityNameList=[String]()
    var cityIDList=[String]()
    var dynamicURl=String()
    var time=7300
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
        countryTableView.separatorStyle = .none
        stateTableView.separatorStyle = .none
        cityTableView.separatorStyle = .none
        
        countryTableView.isHidden=true
        stateTableView.isHidden=true
        cityTableView.isHidden=true
       
        getCountryList()
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBOutlet weak var countryTableView: UITableView!
    
    @IBOutlet weak var stateTableView: UITableView!
    
    
    @IBOutlet weak var cityTableView: UITableView!
    
    var delegate:customeDelegate?=nil
    
    
    @IBAction func saveData(_ sender: UIButton)
    {
        if selectCountryLabel.text!=="--Select Country--"
        {
            let alert=UIAlertController(title: "Alert", message: "Select The Country", preferredStyle: .alert)
            let action=UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        else if selectStateLabel.text!=="--Select State--"
        {
            let alert=UIAlertController(title: "Alert", message: "Select The State", preferredStyle: .alert)
            let action=UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        else if selectCityLabel.text!=="--Select City--"{
            let alert=UIAlertController(title: "Alert", message: "Select The City", preferredStyle: .alert)
            let action=UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            
        }
        else if delegate != nil
        {
    delegate?.dataSaved(name: cityName ,CountryID: countryID,StateID: stateID,CityID:cityID)
    self.navigationController?.popViewController(animated: true)
    
    }else
        {
            
        }
}
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView==countryTableView
        {
          
            return countryNameList.count
        }
        else if tableView==stateTableView
        {
            
            return stateNameList.count
        }
        else
        {
            return cityNameList.count
            
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView==countryTableView
        {
            let cell=countryTableView.dequeueReusableCell(withIdentifier: "cell") as! UITableViewCell
            cell.textLabel?.text=countryNameList[indexPath.row]
            return cell
        }
      else if tableView==stateTableView
        {
            let cell=stateTableView.dequeueReusableCell(withIdentifier: "cell") as! UITableViewCell
            cell.textLabel?.text=stateNameList[indexPath.row]
            return cell
        }
        else
        {let cell=cityTableView.dequeueReusableCell(withIdentifier: "cell") as! UITableViewCell
            cell.textLabel?.text=cityNameList[indexPath.row]
            return cell
            
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView==countryTableView
        {
            selectCountryLabel.text="  \(countryNameList[indexPath.row])"
            countryTableView.isHidden=true
            countryID=countryIDList[indexPath.row]
            self.selectStateLabel.text="--Select State--"
            self.selectCityLabel.text="--Select City--"
            stateNameList=[String]()
            stateIDList=[String]()
            stateID=String()
            getStateNames()
            
        }
        else if tableView==stateTableView
        {
            selectStateLabel.text="  \(stateNameList[indexPath.row])"
            stateTableView.isHidden=true
            stateID=stateIDList[indexPath.row]
            self.selectCityLabel.text="--Select City--"
            cityNameList=[String]()
            cityIDList=[String]()
            cityID=String()
            cityName=String()
            getCityNames()
            
        }
        else
        {
            selectCityLabel.text="  \(cityNameList[indexPath.row])"
            cityTableView.isHidden=true
            cityID=cityIDList[indexPath.row]
            cityName=cityNameList[indexPath.row]
        }
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
                    let dummyArray=resultJSON.object(forKey: "posts") as! [NSDictionary]
                    for value in dummyArray
                    {
                        var dummyDict=value as! NSDictionary
                        self.countryIDList.append(dummyDict.object(forKey: "id")! as! String)
                        self.countryNameList.append(dummyDict.object(forKey: "name") as! String)
                        
                    }
                    print(resultJSON,"11111")
                }
                catch {
                    print("Received not-well-formatted JSON")
                }
                
            }
            DispatchQueue.main.async(execute: {
              print(self.countryNameList,"11111")
                self.countryTableView.reloadData()
             
             
               
            })
            
            }.resume()
    }
    func getStateNames()
    {
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
                        self.stateIDList.append(dummyDict.object(forKey: "id")! as! String)
                        self.stateNameList.append(dummyDict.object(forKey: "name") as! String)
                    }
                    print(resultJSON,"11111")
                    if dummyArray.count==0
                    {
                        
                        let alert = UIAlertController(title: "Alert", message: "State List Not Available Please Choose Another one", preferredStyle: .alert)
                        let action=UIAlertAction(title: "ok", style: .cancel, handler: { (ACTION) in
                            self.selectCountryLabel.text="--Select Country--"
                            
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
                self.stateTableView.reloadData()
              
            })
            
            }.resume()
    }
    func getCityNames()
    {
        let date = Date()
        let calendar = Calendar.current
        
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        time=seconds
        
        
        let url = URL(string: dynamicURl+"GetCities.php?StateID=\(stateID)&tm=\(time)")
        print(url,"bvspURL********")
        
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
                    {var dummyDict=value as! NSDictionary
                        if UserDefaults.standard.object(forKey: "MyCitiesNames") != nil
                        {
                        var mycitiesNameString:String=UserDefaults.standard.object(forKey: "MyCitiesNames") as! String
                        if mycitiesNameString.contains(dummyDict.object(forKey: "name") as! String) == true
                        {
                            
                        }
                        else
                        {
                            self.cityIDList.append(dummyDict.object(forKey: "id")! as! String)
                            self.cityNameList.append(dummyDict.object(forKey: "name") as! String)
                            }
                        
                        }
                        else
                        {
                            self.cityIDList.append(dummyDict.object(forKey: "id")! as! String)
                            self.cityNameList.append(dummyDict.object(forKey: "name") as! String)
                        }
                        
                        
                    }
                    print(dummyArray,"11111")
                    if dummyArray.count==0
                    {
                        
                        let alert = UIAlertController(title: "Alert", message: "City List Not Available Please Choose Another one", preferredStyle: .alert)
                        let action=UIAlertAction(title: "ok", style: .cancel, handler: { (ACTION) in
                            self.selectStateLabel.text="--Select State--"
                            
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
                self.cityTableView.reloadData()
                
            })
            
            }.resume()
    }
    @IBOutlet weak var selectCountryLabel: UILabel!
    @IBAction func selectCountryButton(_ sender: UIButton) {
        if countryTableView.isHidden==true
        {
            countryTableView.isHidden=false
            cityTableView.isHidden=true
            
            stateTableView.isHidden=true
        }
        else
        {
            countryTableView.isHidden=true
        }
    }
    
    @IBOutlet weak var selectStateLabel: UILabel!
    
    @IBAction func selectStateButton(_ sender: UIButton) {
        if selectCountryLabel.text!=="--Select Country--"
        {
            let alert=UIAlertController(title: "Alert", message: "Select The Country", preferredStyle: .alert)
            let action=UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            
        alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        else
        {if stateTableView.isHidden==true
        {
            stateTableView.isHidden=false
            
            
            countryTableView.isHidden=true
            cityTableView.isHidden=true
        }
        else
        {
            stateTableView.isHidden=true
            }
            
        }
        
    }
    
    
    @IBOutlet weak var selectCityLabel: UILabel!
    
    @IBAction func selectCityButton(_ sender: UIButton) {
        if selectCountryLabel.text!=="--Select Country--"
        {
            let alert=UIAlertController(title: "Alert", message: "Select The Country", preferredStyle: .alert)
            let action=UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        else if selectStateLabel.text!=="--Select State--"
        {
            let alert=UIAlertController(title: "Alert", message: "Select The State", preferredStyle: .alert)
            let action=UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        else
        {if cityTableView.isHidden==true
        {
            cityTableView.isHidden=false
            countryTableView.isHidden=true
            stateTableView.isHidden=true
        }
        else
        {
            cityTableView.isHidden=true
            }
            
        }
        
    }
    
 override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
     countryTableView.isHidden=true
        stateTableView.isHidden=true
        cityTableView.isHidden=true
    }
   
    
    
}
