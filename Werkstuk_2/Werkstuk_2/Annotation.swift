//
//  Annotation.swift
//  Werkstuk_2
//
//  Created by Stijn Rooselaers on 2/06/18.
//  Copyright © 2018 Stijn Rooselaers. All rights reserved.
//

import UIKit

import MapKit

class Annotation: MKPointAnnotation {
    var villo: Villo
    
    override init() {
        self.villo = Villo()
        super.init()
        self.title = nil
        self.subtitle = nil
        self.coordinate = CLLocationCoordinate2D()
    }
    
}
