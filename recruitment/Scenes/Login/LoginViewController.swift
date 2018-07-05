//
//  LoginViewController.swift
//  recruitment
//
//  Created by Pablo Martinez Piles on 20/06/2018.
//  Copyright © 2018 Iris connect. All rights reserved.
//

import Foundation
import UIKit


class LoginViewController: UIViewController, LoginView {
    var presenter: LoginPresenter!
    
    @IBOutlet weak var txtPassword: LeftViewTextField!
    @IBOutlet weak var txtUser: LeftViewTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupPresenter()
    }
    
    func setupPresenter() {
        self.presenter = LoginPresenter(view: self)
        let interactor = LoginInteractorImpl()
        presenter.interactor = interactor
    }
    
    // MARK: LoginView
    func loginOk() {
        
    }
    
    
    @IBAction func tappedLogin(_ sender: Any) {
        guard let username = txtUser.text, let password = txtPassword.text else { return }
        self.presenter.login(username: username, password: password)
    }
}


protocol LoginView {
    func loginOk()
}
