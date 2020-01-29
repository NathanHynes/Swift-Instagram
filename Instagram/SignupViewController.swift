//
//  SignupViewController.swift
//  Instagram
//
//  Created by Nathan Hynes on 29/01/2020.
//  Copyright © 2020 Nathan Hynes. All rights reserved.
//

import UIKit
import Firebase

class SignupViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var conPw: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nextBtn: UIButton!
    
    let picker = UIImagePickerController()
    var userStorage: StorageReference!
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
        
        let storage = Storage.storage().reference(forURL: "gs://instagram-85ed2.appspot.com")
        
        ref = Database.database().reference()
        
        userStorage = storage.child("users")

    }
    
    @IBAction func selectImagePressed(_ sender: Any) {
        
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.imageView.image = image
            nextBtn.isHidden = false
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextPressed(_ sender: Any) {
        
        guard !nameField.text!.isEmpty, !emailField.text!.isEmpty, !password.text!.isEmpty, !conPw.text!.isEmpty else { return}
        
        if password.text == conPw.text {
            Auth.auth().createUser(withEmail: emailField.text!, password: password.text!) { (user, error) in
                if let error = error {
                      print(error.localizedDescription)
                  }
                  
                  if let user = user {
                    
                    let changeRequest = Auth.auth().currentUser!.createProfileChangeRequest()
                    
                    changeRequest.displayName = self.nameField.text!
                    changeRequest.commitChanges(completion: nil)
                    
                    let imageRef = self.userStorage.child("\(user.user.uid).jpg")
                      
                      let data = self.imageView.image!.jpegData(compressionQuality: 0.5 )
                      
                      let uploadTask = imageRef.putData(data!, metadata: nil) { (metadata, error) in
                          if error != nil {
                              print(error!.localizedDescription)
                          }
                        
                        imageRef.downloadURL { (url, error) in
                            if error != nil {
                                print(error!.localizedDescription)
                            }
                            
                            if let url = url {
                                let userInfo: [String : Any] = ["uid" : user.user.uid,
                                                                "userName" : self.nameField.text!,
                                                                "urlToImage" : url.absoluteString]
                                
                                self.ref.child("users").child(user.user.uid).setValue(userInfo)
                                
                                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "userVC")
                                
                                self.present(vc, animated: true, completion: nil)
                                
                            }
                        }
                      }
                    
                    uploadTask.resume()
                      
                  }
            }
            
        } else {
            print("Password does not match")
        }
    }
}
