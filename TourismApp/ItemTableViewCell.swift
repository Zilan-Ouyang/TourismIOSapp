//
//  ItemTableViewCell.swift
//  TourismApp
//
//  Created by ZILAN OUYANG on 2020-12-02.
//  Copyright © 2020 ZILAN OUYANG. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {
    var username:String = ""
    let finalPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    //let finalPath = paths[0]
    var fileName:String {
        get {
            return self.username.components(separatedBy: "@")[0]
        }
    }
    var fileNameWext:String {
        get {
            return "\(self.fileName).json"
        }
    }
    var actualfilename:URL {
        get {
            return self.finalPath.appendingPathComponent(fileNameWext)
        }
    }
    var existWishList:[String] = []
    @IBOutlet weak var itemImg: UIImageView!
    
    @IBOutlet weak var itemName: UILabel!
    
    @IBOutlet weak var itemAddress: UILabel!
    @IBOutlet weak var wishButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
//    "name":"St. Florian's Gate",
//    "address":"30-001 Kraków, Poland",
//    "coverImg":"gate1",
//    "phone":"+48 338448000",
//    "website":"http://www.krakow.travel/en/17748-krakow-saint-florians-gate",
//    "images":["gate1","gate2","gate3","gate4"],
//    "descrption":"St. Florian's Gate or Florian Gate in Kraków, Poland, is one of the best-known Polish Gothic towers, and a focal point of Kraków's Old Town. It was built about the 14th century as a rectangular Gothic tower of wild stone, part of the city fortifications against Turkish attack.",
//    "pricing":"Free"
    @IBAction func wishAddPressed(_ sender: Any) {
        let btnImage = UIImage(named: "heart.fill")//?.withRenderingMode(
        
        //var newWish:Attraction = Attraction()
        let wishName = itemName.text
        self.existWishList = self.loadExistJson ()
        self.existWishList.append(wishName!)
        //let fname = self.username.components(separatedBy: "@")[0]
//        print(self.fileName)
        let res = self.saveData(attractionsList: self.existWishList, fileName: "\(self.fileName).json")
        if(res){
            print("Saved!")
        }
        else{
            print("NO")
        }
        wishButton.setImage(btnImage , for: .normal)
    }
    
    func loadExistJson () ->[String] {
        var list:[String] = []
        print(self.actualfilename.absoluteString)
        let jsonData = NSData(contentsOf: actualfilename)
        if let jsonReadData = jsonData {
            let decoder = JSONDecoder()
            list = try! decoder.decode([String].self, from: jsonReadData as Data)
            for i in list {
                print(i)
            }
        }
        return list
    }
    func saveData(attractionsList:[String], fileName:String) -> Bool {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let jsonData = try encoder.encode(attractionsList)
            
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("jsonString is")
                print("=============")
                print(jsonString)
                print("Path to output file: \(self.actualfilename)")
                try jsonString.write(to: self.actualfilename, atomically:true, encoding: String.Encoding.utf8)
                return true
            }
            else {
                print("Error when converting data to a string")
                return false
            }
            
        }
        catch {
            print("Error converting or saving to JSON")
            print(error.localizedDescription)
            return false
        }
    }
}
