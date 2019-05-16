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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func loginButton(_ sender: Any) {
        print("login")
        APICalls.login(username: userName.text ?? "", password: password.text ?? "", completion: handleloginResponse(succes:sessionID:error:))
    }
    
    func handleloginResponse(succes:Bool,sessionID: String,error: Error?){
        if succes {
            DispatchQueue.main.async {
              
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
            self.navigationController!.pushViewController(controller, animated: true)
            //In on the map, you need to use the key to call a function in the API class to get the user's first name and last name, but here we're just printing the key. So, in your app, instead of printing it, you'll call that function and be passing it as an argument to that function.
                print ("the key is \(sessionID)")}
        }
          print ("waaaaaaaa ")
        
    }
}

