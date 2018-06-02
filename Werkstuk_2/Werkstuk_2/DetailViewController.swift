//
//  DetailViewController.swift
//  Werkstuk_2
//
//  Created by Stijn Rooselaers on 2/06/18.
//  Copyright © 2018 Stijn Rooselaers. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var last_update: UILabel!
    @IBOutlet weak var bike_stands: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var available_bike_stands: UILabel!
    @IBOutlet weak var available_bikes: UILabel!
    var villo: Villo = Villo()
    var language: String = ""
  //  var lang: String
    
    override func viewDidLoad() {
        print(language)
        
        
        
        let naam: String = changeName(name: villo.name!)
        name.text = naam
          let adres: String = changeName(name: villo.addresse!)
       address.text=adres
        let date = NSDate(timeIntervalSince1970: TimeInterval(villo.last_update))
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "dd mm YYYY hh:mm:ss"
        let dateString = dayTimePeriodFormatter.string(from: date as Date)
        if (self.language=="nl")
            {
                status.text = "Status: " + villo.status!
                bike_stands.text = "Totaal aantal fietsplaatsen: " + String(villo.bike_stands)
                available_bike_stands.text = "Aantal fietsen beschikbaar: " + String(villo.available_bike_stands)
                available_bikes.text = "Aantal lege fietsplaatsen: " + String(villo.available_bikes)
                
                last_update.text = "Laatst geupdate op: " + dateString
        
        }
            else if(self.language=="fr"){
            status.text = "Statut: " + villo.status!
            bike_stands.text = "Nombre total de places de vélo: " + String(villo.bike_stands)
            available_bike_stands.text = "Nombre de vélos disponibles: " + String(villo.available_bike_stands)
            available_bikes.text = "Nombre de places de vélo vides: " + String(villo.available_bikes)
            
            last_update.text = "Laatst geupdate opsh: " + dateString
            
            }
        
 
          
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func changeName(name: String) -> String {
        var token = name.components(separatedBy: "-")
        var naam: String=""
        //print(token.count)
        if(token.count==3){
            // print(token)
            token[1]+="-"+token[2]
        }
        if(token.count==4){
            // print(token)
            token[1]+="-"+token[2]+"-"+token[3]
        }
        
        if(token[1].range(of:"/") != nil){
            var naam2 = token[1].components(separatedBy: "/")
            if(self.language=="nl")
            {
                naam=naam2[1]
            }
            else if(self.language=="fr")
            {
                naam=naam2[0]
                
            }
            
            //  print(naam2[1] )
        }
        else{
            naam=token[1]
            
        }
        //   print(naam)
        
        
        //  //print(villo.name!)
        return naam
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
