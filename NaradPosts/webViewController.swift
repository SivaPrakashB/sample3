//
//  webViewController.swift
//  NaradPosts
//
//  Created by Narayan on 2/20/18.
//  Copyright © 2018 Narayan. All rights reserved.
//

import UIKit

class webViewController: UIViewController {
    
    @IBAction func shareButton(_ sender: Any) {
        let bounds = UIScreen.main.bounds
        UIGraphicsBeginImageContextWithOptions(bounds.size, true, 0.0)
        self.view.drawHierarchy(in: bounds, afterScreenUpdates: false)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let activityViewController = UIActivityViewController(activityItems: [img!], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    let activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    @IBOutlet weak var shareOutlet: UIButton!
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var webView1: UIWebView!
    override func viewDidLoad() {
       
        super.viewDidLoad()
        
        var width=(self.view.bounds.width/2)-40
        var height=(self.view.bounds.height/2)-40
        activityIndicator.frame=CGRect(x:width, y: height, width: 80, height: 80)
        activityIndicator.activityIndicatorViewStyle=UIActivityIndicatorViewStyle.whiteLarge
        activityIndicator.backgroundColor=UIColor.darkGray
        self.webView1.addSubview(activityIndicator)
        activityIndicator.startAnimating()
       activityIndicator.hidesWhenStopped=true
        shareOutlet.layer.cornerRadius=5
        shareOutlet.layer.borderWidth=2
        shareOutlet.layer.borderColor=UIColor.orange.cgColor
        var urlLink:String=UserDefaults.standard.object(forKey:"urlLink") as! String
         var publisherLink:String=UserDefaults.standard.object(forKey:"publisherLink") as! String
        DispatchQueue.global().async {
            let url = URL(string: "\(publisherLink)")
            
            let imageData = try? Data(contentsOf: url!)
            
            DispatchQueue.main.async {
                
                self.image1.image = UIImage(data: imageData!)
                
                self.activityIndicator.stopAnimating()
            }
        }
        DispatchQueue.main.async{
        let url=NSURL(string: urlLink)
        let req=NSURLRequest(url: url as! URL)
        
        /*let settingsUrl = URL(string:"http://\(url4)") as! URL
         
         //let url4 = NSURL (string: url3);
         let requestObj = NSURLRequest(URL: settingsUrl)*/
        self.webView1.loadRequest(req as URLRequest)

            
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    @IBAction func backButton(_ sender: Any) {
       /* let category:String=UserDefaults.standard.object(forKey: "category") as! String
        var zero:Int=0
        print("\(category)bvspCategory")
        if category == "\(zero)"
        {
            let storyBoard=UIStoryboard(name: "Main", bundle: nil)
            let vc=storyBoard.instantiateViewController(withIdentifier: "Home") as! UIViewController
            present(vc, animated: true, completion: nil)
            
        }
        else
        {
            let storyBoard=UIStoryboard(name: "Main", bundle: nil)
            let vc=storyBoard.instantiateViewController(withIdentifier: "Home1") as! UIViewController
            present(vc, animated: true, completion: nil)
            
        }
        
        
    }
    */
        
        dismiss(animated: true, completion: nil)
    }
}
