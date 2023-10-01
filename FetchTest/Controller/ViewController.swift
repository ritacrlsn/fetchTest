//
//  ViewController.swift
//  FetchTest
//
//  Created by Rita Carlson on 9/29/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var getDataButton: UIButton!
    
    var dataManager = ListManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func getDataPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToData", sender: self)
    }
    
}
