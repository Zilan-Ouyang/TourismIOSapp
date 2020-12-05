//
//  WishListViewController.swift
//  TourismApp
//
//  Created by ZILAN OUYANG on 2020-12-02.
//  Copyright © 2020 ZILAN OUYANG. All rights reserved.
//

import UIKit

class WishListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
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
    var attractionsList:[Attraction] = []
    var filteredList:[Attraction] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "wishCell") as? ItemTableViewCell
                
        if(cell == nil) {
            cell = ItemTableViewCell()
        }
        cell?.itemImg.image = UIImage(named: filteredList[indexPath.row].coverImg)
        cell?.itemName.text = filteredList[indexPath.row].name
        cell?.itemAddress.text = filteredList[indexPath.row].address
        cell?.username = self.username
        return cell!
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 150
        self.loadExistJson()
        self.loadAttractionJson()
        self.filteredList = attractionsList.filter({existWishList.contains($0.name)})
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
    }
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
        tableView.reloadData()
    }
    override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
        tableView.reloadData()
    }
    override func viewDidDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
        tableView.reloadData()
    }
    
    func loadExistJson () {
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
        existWishList = list
    }
    func loadAttractionJson() {
        if let filepath = Bundle.main.path(forResource:"Attractions", ofType:"json") {
            do {
                let contents = try String(contentsOfFile: filepath)
                print(contents)
                let jsonData = contents.data(using: .utf8)!
                let decoder = JSONDecoder()
                attractionsList = try! decoder.decode([Attraction].self, from:jsonData)
                //return attractionsList
            } catch {
                print("Cannot load file")
            }
        } else {
            print("File not found")
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "wishShowDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let selectedAttr = self.attractionsList[indexPath.row]
                
                let controller = segue.destination as! DetailViewController
                controller.attraction = selectedAttr
//                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
//                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

}
