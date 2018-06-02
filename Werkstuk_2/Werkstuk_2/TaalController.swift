//
//  TaalController.swift
//  Werkstuk_2
//
//  Created by Stijn Rooselaers on 2/06/18.
//  Copyright © 2018 Stijn Rooselaers. All rights reserved.
//

import UIKit

class TaalController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueFR" {
           
                let nextVC = segue.destination as! ViewController
                nextVC.language = "fr"
            }
      else  if segue.identifier == "segueNL" {
            
            let nextVC = segue.destination as! ViewController
            nextVC.language = "nl"
        }
        
        }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
