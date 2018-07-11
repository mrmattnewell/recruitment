//
//  LoginViewController.swift
//  recruitment
//
//  Created by Pablo Martinez Piles on 20/06/2018.
//  Copyright © 2018 Iris connect. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView


class LoginViewController: UIViewController, LoginView, NVActivityIndicatorViewable {
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
        stopAnimating()
        let storyBoard = UIStoryboard(name: "JobsStoryboard", bundle: nil)
        let jobsController = storyBoard.instantiateViewController(withIdentifier: "JobListViewController")
        jobsController.modalTransitionStyle = .coverVertical
        let navigationController = UINavigationController(rootViewController: jobsController)
        
        //self.present(navigationController, animated: true, completion: nil)
        self.show(navigationController, sender: self)
    }
    
    
    @IBAction func tappedLogin(_ sender: Any) {
        
        guard let username = txtUser.text, let password = txtPassword.text else { return }
        startAnimating(CGSize(width: 50, height: 50), message: nil, type: .ballGridPulse, color: .white, padding: 0)
        self.presenter.login(username: username, password: password)
        txtPassword.resignFirstResponder()
        txtUser.resignFirstResponder()
    }
}


protocol LoginView {
    func loginOk()
}
