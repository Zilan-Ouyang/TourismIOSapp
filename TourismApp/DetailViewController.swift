//
//  DetailViewController.swift
//  TourismApp
//
//  Created by ZILAN OUYANG on 2020-12-03.
//  Copyright © 2020 ZILAN OUYANG. All rights reserved.
//

import UIKit
import WebKit
extension UserDefaults {

    static func exists(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }

}
class DetailViewController: UIViewController, UIScrollViewDelegate {
    let defaults = UserDefaults.standard
    var attraction:Attraction?
    var images:[String] = []
    var imagesDisplayArr:[UIImage] = []
//    var webView = WKWebView()
//    override func loadView() {
//        self.view = webView
//    }
    @IBOutlet weak var Name: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var ratingButton: UIButton!
    
    var index = 0
    let animationDuration: TimeInterval = 0.25
    let switchingInterval: TimeInterval = 3
    var transition = CATransition()
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var phone: UIButton!
    @IBOutlet weak var websiteButton: UIButton!
   
    @IBOutlet weak var ratingSlider: UISlider!
    
    @IBOutlet weak var descriptionBox: UILabel!
    override func viewDidLayoutSubviews() {
        navigationController?.navigationBar.isHidden = false
    }
    var timer = Timer()
    var counter = 0
    override func viewDidLoad() {
        //self.resetDefaults()
        super.viewDidLoad()
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = true

        guard let currAttr = self.attraction else {
            print("detail item is null")
            return
        }
        if(UserDefaults.exists(key: self.attraction!.name)){
            let existRating:Int? = self.defaults.integer(forKey: self.attraction!.name)
            if let rating = existRating {
                print(rating)
                self.ratingButton.isEnabled = false
                self.ratingButton.isHidden = true
                self.ratingButton.setTitle("\(String(format: "%.2f", rating))", for: .normal)
                self.ratingButton.backgroundColor = UIColor.systemYellow
                self.ratingSlider.isEnabled = false
                self.ratingSlider.setValue(Float(rating), animated: true)
            }
        }
        
        print(currAttr.name)
        //image.image = UIImage(named: images[index])//images[index]
        print(currAttr)
        Name.text = currAttr.name
        images = currAttr.images
        if(images.count > 0){
            for image in images{
                //let display:UIImage = UIImage(named: image)!
                if let disImg = UIImage(named: image) {
                    self.imagesDisplayArr.append(disImg)
                }
            }
        }
        let phoneNum = currAttr.phone
        phone.setTitle(phoneNum, for: .normal)
        address.text = currAttr.address
        price.text = currAttr.pricing
        let webLink = currAttr.website
        websiteButton.setTitle(webLink, for: .normal)
        descriptionBox.text = currAttr.descrption
        self.setupImages(self.imagesDisplayArr)
        
    
        // Do any additional setup after loading the view.
    }
    func setupImages(_ images: [UIImage]){

        for i in 0..<images.count {

            let imageView = UIImageView()
            imageView.image = images[i]
            let xPosition = UIScreen.main.bounds.width * CGFloat(i)
            imageView.frame = CGRect(x: xPosition, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
            imageView.contentMode = .scaleAspectFit

            scrollView.contentSize.width = scrollView.frame.width * CGFloat(i + 1)
            scrollView.addSubview(imageView)
            scrollView.delegate = self


        }

    }
//    func resetDefaults() {
//        let defaults = UserDefaults.standard
//        let dictionary = defaults.dictionaryRepresentation()
//        dictionary.keys.forEach { key in
//            defaults.removeObject(forKey: key)
//        }
//    }
    @IBAction func submitRatingPressed(_ sender: Any) {
        let rating = self.ratingSlider.value
        //let res = self.saveData(rating: rating, fileName: self.attraction?.name)
        let keyName = (self.attraction?.name)!
        self.defaults.set(rating, forKey: keyName)
        ratingButton.isEnabled = false
        ratingButton.isHidden = true
        self.ratingSlider.isEnabled = false
        ratingButton.backgroundColor = UIColor.systemYellow
        ratingButton.setTitle("\(String(format: "%.2f", rating))", for: .normal)
        ratingSlider.setValue(Float(rating), animated: true)
    }
    
    @IBAction func phoneNumPressed(_ sender: Any) {
        var CleanphoneNumber:String = ""
        if let phoneNumber = phone.titleLabel?.text {
            CleanphoneNumber = phoneNumber.replacingOccurrences(of: " ", with: "")
        }
        if let phoneCallURL:NSURL = NSURL(string: "tel://\(CleanphoneNumber)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL as URL)) {
                application.open(phoneCallURL as URL)
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "webViewSegue" {
            let webLink = self.attraction?.website
            let controller = segue.destination as! WebViewController
            controller.webLink = webLink!
        }
    }
    @IBAction func openWebView(_ sender: Any) {
        
        performSegue(withIdentifier: "webViewSegue", sender: nil)
        
        //self.view.send(webView)
    }
}
//extension ViewController:UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int)-> UIEdgeInsets {
//        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: frame.size.width, height: frame.size.height)
//    }
//}
