//
//  ViewController.swift
//  On the Map
//
//  Created by Amal Alqadhibi on 12/05/2019.
//  Copyright © 2019 Amal Alqadhibi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.    
    }
    
    @IBAction func loginButton(_ sender: Any) {
        updateUI(isProcess: true)
        if userName.text == "" || password.text == "" {
            let alertController = UIAlertController(title: "Oops!", message: "Please Enter your Email and password.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
            updateUI(isProcess: false)
        } else {
            
            APICalls.login(username: userName.text!, password: password.text!, completion: handleloginResponse(succes:sessionID:error:))
        }
    }
    
    @IBAction func signUpButton(_ sender: Any) {
       let url = URL(string: "https://auth.udacity.com/sign-up?next=https://classroom.udacity.com/authenticated")!
        UIApplication.shared.open( url , options: [:], completionHandler: nil)
    }
    //MARK:- Response handler
    func handleloginResponse(succes:Bool,sessionID: String,error: Error?){
        updateUI(isProcess: false)
        guard error == nil else {
            let alertController = UIAlertController(title: "Oops!", message: "Network error, Please try again!" , preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        print(succes)
        if succes {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "ShowMap", sender: self)
            }
            Global.uniqueKey = sessionID
            APICalls.getStudentInfo(completion: { (error) in
                guard error == nil else {
                    let alertController = UIAlertController(title: "Oops!", message: "Network error, Please try again!" , preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                    return
                }
            })
        } else {
            let alertController = UIAlertController(title: "Oops!", message: "Encorrect Email or password" , preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    // hide the keyboard when user touch the view
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func updateUI(isProcess:Bool) {
        DispatchQueue.main.async {
            if isProcess {
                self.activityIndicator.startAnimating()
            } else {
                self.activityIndicator.stopAnimating()
            }
            self.userName.isUserInteractionEnabled = !isProcess
            self.password.isUserInteractionEnabled = !isProcess
            self.loginButton.isEnabled = !isProcess
        }
    }
    
}

