//
//  MyCitiesViewController.swift
//  NaradPosts
//
//  Created by Apple on 05/07/18.
//  Copyright © 2018 Narayan. All rights reserved.
//

import UIKit

class MyCitiesViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,customeDelegate {
    var cityNameList=[String]()
    var countryIDList=[String]()
    var stateIDList=[String]()
    var cityIDList=[String]()
    var myCitiesString=String()
    var dynamicURl=String()
    
    
    func dataSaved(name: String, CountryID: String, StateID: String, CityID: String) {
       
        if UserDefaults.standard.object(forKey: "MyCities") != nil
        { var myCitiesNames:String=UserDefaults.standard.object(forKey: "MyCitiesNames") as! String
            myCitiesNames=myCitiesNames+name+"^"
            UserDefaults.standard.set(myCitiesNames, forKey:"MyCitiesNames")
            
            
            
            cityNameList=[String]()
          countryIDList=[String]()
      stateIDList=[String]()
       cityIDList=[String]()
            myCitiesString=UserDefaults.standard.object(forKey: "MyCities") as! String
            
            var dummyArray123=myCitiesString.components(separatedBy: "^")
            if dummyArray123.count != 0
            {
                for value in dummyArray123
                {
                    var d1=value.components(separatedBy: "~")
                    if d1.count==4
                    {
                        cityNameList.append(d1[0])
                        countryIDList.append(d1[1])
                        stateIDList.append(d1[2])
                        cityIDList.append(d1[3])
                    }
                }
                myCitiesString=myCitiesString+name+"~"+CountryID+"~"+StateID+"~"+CityID+"^"
                  UserDefaults.standard.set(myCitiesString, forKey: "MyCities")
            }
            cityNameList.append(name)
            countryIDList.append(CountryID)
            stateIDList.append(StateID)
            cityIDList.append(CityID)
            DispatchQueue.main.async {
                self.tableView1.reloadData()
            }
            
          
        }
        else
        {
            let myCitiesNames:String=name+"^"
             UserDefaults.standard.set(myCitiesNames, forKey:"MyCitiesNames")
                let MyCitiesString:String="\(name)"+"~"+"\(CountryID)"+"~"+"\(StateID)"+"~"+"\(CityID)"+"^"
                UserDefaults.standard.set(MyCitiesString, forKey:"MyCities")
            cityNameList.append(name)
            countryIDList.append(CountryID)
            stateIDList.append(StateID)
            cityIDList.append(CityID)

            DispatchQueue.main.async {
                self.tableView1.reloadData()
            }
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityNameList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView1.dequeueReusableCell(withIdentifier: "cell") as! UITableViewCell
        cell.textLabel?.text=cityNameList[indexPath.row]
        return cell
    }
    
    @IBOutlet weak var tableView1: UITableView!
    
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
        if UserDefaults.standard.object(forKey: "MyCities") != nil
        {
            myCitiesString=UserDefaults.standard.object(forKey: "MyCities") as! String
            
            var dummyArray123=myCitiesString.components(separatedBy: "^")
            if dummyArray123.count != 0
            {
                for value in dummyArray123
                {
                    var d1=value.components(separatedBy: "~")
                    if d1.count==4
                    {
                        cityNameList.append(d1[0])
                        countryIDList.append(d1[1])
                        stateIDList.append(d1[2])
                        cityIDList.append(d1[3])
                    }
                }
               
            }
            DispatchQueue.main.async {
                self.tableView1.reloadData()
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var getNewsUrl:String=dynamicURl+"GetNewsByLocations_with_ads.php?country=\(countryIDList[indexPath.row])&state=\(stateIDList[indexPath.row])&city=\(cityIDList[indexPath.row])&ward=0"
        UserDefaults.standard.set(getNewsUrl, forKey: "getNewsUrl")
        UserDefaults.standard.set(3, forKey: "StateNewsShowCondition")
       let storyboard=UIStoryboard(name: "Main", bundle: nil)
        let vc=storyboard.instantiateViewController(withIdentifier: "StateNewsShow") as! UIViewController
        UIApplication.topViewController()?.present(vc, animated: true, completion: nil)
        
        
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
 func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {if cityNameList.count != 0
    {
        if editingStyle == .delete
        {
            cityNameList.remove(at: indexPath.row)
            countryIDList.remove(at: indexPath.row)
            stateIDList.remove(at: indexPath.row)
            cityIDList.remove(at: indexPath.row)
         
           var finalString=String()
            var myCitiesName=String()
                for index in 0..<cityNameList.count
                {if finalString.isEmpty==true || finalString=="" || finalString == nil
                {
                    finalString=cityNameList[index]+"~"+countryIDList[index]+"~"+stateIDList[index]+"~"+cityIDList[index]+"^"
                    myCitiesName=cityNameList[index]+"^"
                    }
                    else
                {
                    finalString=finalString+cityNameList[index]+"~"+countryIDList[index]+"~"+stateIDList[index]+"~"+cityIDList[index]+"^"
                    myCitiesName=myCitiesName+cityNameList[index]+"^"
                    }
                }
                UserDefaults.standard.set(finalString, forKey: "MyCities")
                UserDefaults.standard.set(myCitiesName, forKey:"MyCitiesNames")
            }
            tableView1.reloadData()
   
        }
        
    }
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        
        
        
        let st=UIStoryboard(name: "Main", bundle: nil)
        let vc=st.instantiateViewController(withIdentifier: "abc") as! UIViewController
        
        self.present(vc, animated: true, completion: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "saveCity"
        {
            let sc=segue.destination as! saveCityViewController
            sc.delegate=self
        }
    }
    
    
}
