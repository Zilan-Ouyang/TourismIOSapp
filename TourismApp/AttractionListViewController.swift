//
//  AttractionListViewController.swift
//  TourismApp
//
//  Created by ZILAN OUYANG on 2020-12-02.
//  Copyright © 2020 ZILAN OUYANG. All rights reserved.
//

import UIKit

class AttractionListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
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
        return attractionsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "attractionsCell") as? ItemTableViewCell
                
        if(cell == nil) {
            cell = ItemTableViewCell()
        }
        cell?.itemImg.image = UIImage(named: attractionsList[indexPath.row].coverImg)
        cell?.itemName.text = attractionsList[indexPath.row].name
        if(existWishList.contains(attractionsList[indexPath.row].name)){
            //wishButton
            let btnImage = UIImage(named: "heart.fill")
            cell?.wishButton.setImage(btnImage , for: .normal)
        }
        cell?.itemAddress.text = attractionsList[indexPath.row].address
        cell?.username = self.username
        return cell!
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 150
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.loadJson()
        self.loadExistJson()
        //self.filteredList = attractionsList.filter({existWishList.contains($0.name)})
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        if let index = self.tableView.indexPathForSelectedRow{
            self.tableView.deselectRow(at: index, animated: true)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "attrShowDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let selectedAttr = self.attractionsList[indexPath.row]
                
                let controller = segue.destination as! DetailViewController
                //DetailViewController
                controller.attraction = selectedAttr
//                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
//                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    func loadJson() {
        if let filepath = Bundle.main.path(forResource:"Attractions", ofType:"json") {
            do {
                let contents = try String(contentsOfFile: filepath)
                print(contents)
                let jsonData = contents.data(using: .utf8)!
                let decoder = JSONDecoder()
                self.attractionsList = try! decoder.decode([Attraction].self, from:jsonData)
            } catch {
                print("Cannot load file")
            }
        } else {
            print("File not found")
        }
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
