//
//  PopUpViewController.swift
//  NaradPosts
//
//  Created by Narayan on 6/4/18.
//  Copyright © 2018 Narayan. All rights reserved.
//

import UIKit

class PopUpViewController: UIViewController {
    
    @IBOutlet weak var update: UIButton!
    @IBOutlet weak var okButtonName: UIButton!
    @IBOutlet weak var titleName: UILabel!
    @IBOutlet weak var messageDescription: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        update.isHidden=true
        okButtonName.setTitle("Ok", for:.normal)
        if UserDefaults.standard.object(forKey: "oKaction") as! Int != nil
        {
            var oKaction:Int=UserDefaults.standard.object(forKey: "oKaction") as! Int
            if oKaction == 3
            {okButtonName.setTitle("Skip", for:.normal)
                update.isHidden=false
            }
            else
            {
                update.isHidden=true
            }
        }
        
        if UserDefaults.standard.object(forKey: "messageDescription") != nil
        {
            let messageDescription1:String=UserDefaults.standard.object(forKey: "messageDescription") as! String
            messageDescription.text=messageDescription1
            
        }else{
            messageDescription.text="""
            Incorrect Credentials!
            Please try again.....
            """
        }
        if UserDefaults.standard.object(forKey: "message") != nil
        {
            let message:String=UserDefaults.standard.object(forKey: "message") as! String
            titleName.text=message
        }else{
            titleName.text="Message"
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func dismiss(_ sender: UIButton) {
        var oKaction:Int=UserDefaults.standard.object(forKey: "oKaction") as! Int
        if oKaction == 1
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "multipleCompany") as! UIViewController
            self.present(vc, animated: true, completion: nil)
        }
        else if oKaction == 2
        {okButtonName.setTitle("Skip", for:.normal)
            dismiss(animated: true, completion: nil)
        }
        else if oKaction == 3
        {
            okButtonName.setTitle("Skip", for:.normal)
            dismiss(animated: true, completion: nil)
        }
        else if oKaction == 4
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "saleList") as! UIViewController
            self.present(vc, animated: false, completion: nil)
        }
        else if oKaction == 5
        {
            dismiss(animated: true, completion: nil)
        }
        else if oKaction == 6
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "purchaseList") as! UIViewController
            self.present(vc, animated: false, completion: nil)
        }
        else if oKaction == 7
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "login") as! UIViewController
            self.present(vc, animated: false, completion: nil)
        }
        else
        {
            dismiss(animated: true, completion: nil)
        }
    }
    
    
    
    @IBAction func upadateButtonClicked(_ sender: UIButton) {
        
        //https://itunes.apple.com/us/app/naradpost/id1357606717?ls=1&mt=8
        UIApplication.shared.openURL(NSURL(string: "https://itunes.apple.com/us/app/naradpost/id1357606717?ls=1&mt=8")! as URL)
    }
    
    
}
