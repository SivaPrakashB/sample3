//
//  RegisterViewController.swift
//  NaradPosts
//
//  Created by Narayan on 2/23/18.
//  Copyright © 2018 Narayan. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    @IBOutlet weak var nameCentre:NSLayoutConstraint!
    @IBOutlet weak var MAILCentre:NSLayoutConstraint!
     @IBOutlet weak var passwordCentre:NSLayoutConstraint!
     @IBOutlet weak var phoneCentre:NSLayoutConstraint!
    
    @IBOutlet weak var backOulet: UIButton!
    @IBOutlet weak var registerOutlet: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        registerOutlet.layer.cornerRadius=10
        registerOutlet.layer.borderWidth=5
        registerOutlet.layer.borderColor=UIColor.black.cgColor
        
        backOulet.layer.cornerRadius=10
        backOulet.layer.borderWidth=5
        backOulet.layer.borderColor=UIColor.black.cgColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nameCentre.constant += view.bounds.width
       MAILCentre.constant += view.bounds.width
        passwordCentre.constant += view.bounds.width
         phoneCentre.constant += view.bounds.width
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 2.0, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.nameCentre.constant -= self.view.bounds.width
            self.passwordCentre.constant -= self.view.bounds.width
            self.phoneCentre.constant -= self.view.bounds.width
            self.MAILCentre.constant -= self.view.bounds.width
            
            self.view.layoutIfNeeded()
        }, completion: nil)
        
    }
}
