//
//  ViewController.swift
//  Werkstuk_2
//
//  Created by Stijn Rooselaers on 2/06/18.
//  Copyright © 2018 Stijn Rooselaers. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import CoreData

class ViewController: UIViewController, MKMapViewDelegate {
   
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var UpdatedTime: UILabel!
    @IBOutlet weak var herlaad: UIButton!
    
    var pointAnnotation:Annotation!
    var pinAnnotationView:MKPinAnnotationView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var locationManager = CLLocationManager()
    
    var villoStations: [Villo] = []
    var villo: Villo = Villo()
    var language: String = ""
    var lastupdated: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        if(self.language=="nl"){
            herlaad.setTitle("Herlaad", for: .normal)
            lastupdated="Laatst geüpdate op: "
            
        }
        if(self.language=="fr"){
            herlaad.setTitle("Recharger", for: .normal)
            lastupdated="Dernière mise à jour: "
        }
       
        deleteVilloStationsFromCoreData()
           getVillostations()
        
        
        
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func getVillostations() {
        
        var urllink = ""
        
            urllink = "https://api.jcdecaux.com/vls/v1/stations?apiKey=6d5071ed0d0b3b68462ad73df43fd9e5479b03d6&contract=Bruxelles-Capitale"
        
        
        let url = URL(string: urllink)
        
        let urlRequest = URLRequest(url: url!)
        
        
        // set up the session
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            
            
            guard error == nil else {
                print("error GET")
                print(error!)
                return
            }
            
         
            guard let responseData = data else {
                print("Error: didn't receiver data")
                return
            }
            
         
            
            do {
                guard let json = try JSONSerialization.jsonObject(with: responseData, options: []) as? [[String: Any]] else {
                    print("error trying to convert data to JSON")
                    return
                }
                for fields in json {
            
                                guard let number = fields["number"] as? Int else {
                                    continue
                                }
                                guard let name = fields["name"] as? String else {
                                    continue
                                }
                                guard let address = fields["address"] as? String else {
                                    continue
                                }
                                guard let banking = fields["banking"] as? Bool else {
                                    continue
                                }
                                guard let bonus = fields["bonus"] as? Bool else {
                                    continue
                                }
                                guard let status = fields["status"] as? String else {
                                    continue
                                }
                                guard let contract_name = fields["contract_name"] as? String else {
                                    continue
                                }
                                guard let bike_stands = fields["bike_stands"] as? Int else {
                                    continue
                                }
                                guard let available_bike_stands = fields["available_bike_stands"] as? Int else {
                                    continue
                                }
                                guard let available_bikes = fields["available_bikes"] as? Int else {
                                    continue
                                }
                                guard let last_update = fields["last_update"] as? Int else {
                                    continue
                                }
                                var pos_lat: Double=0
                                var pos_lng: Double=0
                                
                                if let positions = fields["position"] as? [String : Any]{
                                    
                                    guard let lat = positions["lat"] as? Double else {
                                        continue
                                    }
                                    pos_lat=lat
                                    guard let lng = positions["lng"] as? Double else {
                                        continue
                                    }
                                    pos_lng=lng
                                   
                                    
                                }
                                
                                
                               //toevoegen van nieuw station
                                DispatchQueue.main.async {
                                    self.addVilloToCoreData(number: number, name: name, address: address, banking: banking, bonus: bonus, status: status, contract_name: contract_name, bike_stands: bike_stands, available_bike_stands: available_bike_stands, available_bikes: available_bikes, last_update: last_update, pos_lat: pos_lat, pos_lng: pos_lng)
                                 
                                }
                                
                    
                    }
            
                
                print("VilloStations opgehaald van webservice")
                //haal de fietsstations uit Core Data
                DispatchQueue.main.async {
                    
                    self.getVilloStationsFromCoreData()
                }
                
                
                
                
            } catch  {
                print("Cannot convert JSON")
                return
            }
        }
        
        task.resume()
        
    }
    //herlaad de data
    @IBAction func herlaad(_ sender: Any) {
        mapView.removeAnnotations(self.mapView.annotations)
        deleteVilloStationsFromCoreData()
        getVillostations()
    }
    
    //Voegt alles toe aan core data
    func addVilloToCoreData(number: Int, name: String, address: String, banking: Bool, bonus: Bool, status: String, contract_name: String, bike_stands: Int, available_bike_stands: Int, available_bikes: Int, last_update: Int, pos_lat: Double, pos_lng: Double)
        
       {
        
        let villo = NSEntityDescription.insertNewObject(forEntityName:"Villo", into: context) as! Villo
        villo.number=Int32(number)
        villo.name=name
        villo.addresse=address
        villo.banking=banking
        villo.bonus=bonus
        villo.status=status
        villo.contract_name=contract_name
        villo.bike_stands=Int16(bike_stands)
        villo.available_bike_stands=Int16(available_bike_stands)
        villo.available_bikes=Int16(available_bikes)
        villo.last_update=Int64(last_update)
        villo.pos_lat=pos_lat
        villo.pos_lng=pos_lng
       
        do {
            try context.save()
        } catch {
            fatalError("cannot save content: \(error)")
        }
        
    }
    
    
 
    //Verwijderd alle stations
    func deleteVilloStationsFromCoreData() {
        
        let villoFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Villo")
        
        do {
            
            let teVerwijderen = try context.fetch(villoFetch) as! [Villo]
            for villo in teVerwijderen {
                context.delete(villo)
                do {
                    try context.save()
                } catch {
                    fatalError("cannot save content: \(error)")
                }
            }
            
            villoStations.removeAll()
            
        } catch {
            fatalError("failed to get all bikes: \(error)")
        }
        
    }
  //haal de fietsen op
    func getVilloStationsFromCoreData() {
        
        let villoFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Villo")
        
        do {
            villoStations = try context.fetch(villoFetch) as! [Villo]
            print(villoStations.count)
            
            UpdatedTime.text = lastupdated + getCurrentTime()
            
            
            var counter = 0
           //zal over de hele array van stations gaan
                while counter < self.villoStations.count{
 
               //zet elk station 1 per 1 op de map
                    let villo = self.villoStations[counter]
                    let annotation = Annotation()
                    
                    //zal de naam aanpassen naargelang NL of FR
                    var token = villo.name!.components(separatedBy: "-")
                    var naam: String=""
                  
                    if(token.count==3){
                    
                        token[1]+=token[2]
                    }
                    if(token.count==4){
                        
                        token[1]+=token[2]+token[3]
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
                        
                    }
                    else{
                        naam=token[1]
                        
                    }
                                    annotation.title = naam
            
                    //zet de lat & long om in een coordinate
           let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: villo.pos_lat, longitude: villo.pos_lng)
            
                                    annotation.coordinate = coordinate
                                    annotation.villo = villo
                    //zet deze coordinate op de map
                                    self.pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
                                    self.mapView.addAnnotation(self.pinAnnotationView.annotation!)
                    
                    counter+=1
                     }
            
        } catch {
            fatalError("cannot get Bikes \(error)")
        }
        
        
        
        
    }
    //haal de huidige tijd op
    func getCurrentTime() -> String{
        
        let date = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale(identifier: "nl_BE")
        
        let time = dateFormatter.string(from: date)
        
        return time
        
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
       let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated: true)
       // let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.04, longitudeDelta: 0.04))
        
     //   mapView.setRegion(region, animated: true)
    }
    //kijkt wanneer er op de infoknop van een fiets gebeurd is
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        let annotation = view.annotation as! Annotation
        
        villo = annotation.villo
        
        if control == view.rightCalloutAccessoryView {
            performSegue(withIdentifier: "detailVillo", sender: villo)
        }
    }
    
    
    //Geef de gekozen fietsenstalliing door
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailVillo" {
            if let villo = sender as? Villo {
                let nextVC = segue.destination as! DetailViewController
                nextVC.villo = villo
                nextVC.language=self.language
            }
        }
    }
   
    //bron: http://swiftdeveloperblog.com/code-examples/mkannotationview-display-custom-pin-image/
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        let annotationId = "Identifier"
        var annotationImage: MKAnnotationView?
        if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationId) {
            annotationImage = dequeuedAnnotationView
            annotationImage?.annotation = annotation
        }
        else {
            annotationImage = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationId)
            annotationImage?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        
        if let annotationImage = annotationImage {
            
            annotationImage.canShowCallout = true
            annotationImage.image = #imageLiteral(resourceName: "fiets")
        }
        return annotationImage
    }
   


}

