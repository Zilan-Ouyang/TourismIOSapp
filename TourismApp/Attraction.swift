//
//  Attraction.swift
//  TourismApp
//
//  Created by ZILAN OUYANG on 2020-12-02.
//  Copyright © 2020 ZILAN OUYANG. All rights reserved.
//

import Foundation
struct Attraction:Codable {
    var name:String = ""
    var address:String = ""
    var coverImg:String = ""
    var phone:String = ""
    var website:String = ""
    var images:[String] = []
    var descrption:String = ""
    var pricing:String = ""
}
