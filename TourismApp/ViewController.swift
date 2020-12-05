//
//  ViewController.swift
//  TourismApp
//
//  Created by ZILAN OUYANG on 2020-12-02.
//  Copyright © 2020 ZILAN OUYANG. All rights reserved.
//

import UIKit
//import MaterialComponents.MaterialButton
class ViewController: UIViewController {
    var usersList:[User] = []
    var usernameEntered:String = ""
    var passwordEntered:String = ""
    @IBOutlet weak var logoImg: UIImageView!
    
    @IBOutlet weak var usernameInput: UITextField!
    
    @IBOutlet weak var passwordInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logoImg.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0).cgColor
        logoImg.layer.masksToBounds = true
        logoImg.layer.borderWidth = 5
        self.loadJson()
        // Do any additional setup after loading the view.
        
    }
    func loadJson() {
        if let filepath = Bundle.main.path(forResource:"users", ofType:"json") {
            do {
                let contents = try String(contentsOfFile: filepath)
                print(contents)
                let jsonData = contents.data(using: .utf8)!
                let decoder = JSONDecoder()
                self.usersList = try! decoder.decode([User].self, from:jsonData)
            } catch {
                print("Cannot load file")
            }
        } else {
            print("File not found")
        } 
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let barViewControllers = segue.destination as! UITabBarController
        let destinationAttractionViewController = barViewControllers.viewControllers?[0] as! AttractionListViewController
        destinationAttractionViewController.username = usernameEntered

        // access the second tab bar
        let destinationWishViewController = barViewControllers.viewControllers?[1] as! WishListViewController
        destinationWishViewController.username = usernameEntered
    }
    @IBAction func handleLogInPressed(_ sender: Any) {
        usernameEntered = usernameInput.text!
        passwordEntered = passwordInput.text!
        var loginSuccess = false
        for user in usersList {
            if(user.username == usernameEntered && user.password == passwordEntered){
                loginSuccess = true
            }
        }
        if(loginSuccess){
            //perform segue
            performSegue(withIdentifier: "loginSuccess", sender: nil)
        }
        else{
            let alert = UIAlertController(title: "Invalid credentials", message: "Your username or password is incorrect!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}

