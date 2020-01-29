//
//  SignupViewController.swift
//  Instagram
//
//  Created by Nathan Hynes on 29/01/2020.
//  Copyright © 2020 Nathan Hynes. All rights reserved.
//

import UIKit
import Firebase

class SignupViewController: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var conPw: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nextBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func selectImagePressed(_ sender: Any) {
    }
    
    @IBAction func nextPressed(_ sender: Any) {
    }
}
