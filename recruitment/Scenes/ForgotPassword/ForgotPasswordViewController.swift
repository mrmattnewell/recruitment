//
//  ForgotPasswordViewController.swift
//  recruitment
//
//  Created by Pablo Martinez Piles on 18/07/2018.
//  Copyright © 2018 Iris connect. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView


class ForgotPasswordViewController: UIViewController, UITextFieldDelegate, NVActivityIndicatorViewable {
    
    @IBOutlet weak var txtEmail: LeftViewTextField!
    let irisApi = IrisApi()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtEmail.delegate = self
        self.title = "Forgot Password"
    }
    
    func resetPassword(){
        startAnimating(CGSize(width: 50, height: 50), message: nil, type: .ballGridPulse, color: .white, padding: 0)
        let request = ResetPasswordRequest(email: txtEmail.text!)
        irisApi.resetPassword(resetRequest: request) {
            self.stopAnimating()
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func tappedReset(_ sender: Any) {
        resetPassword()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtEmail {
            self.resetPassword()
        }
        return true
    }
}
