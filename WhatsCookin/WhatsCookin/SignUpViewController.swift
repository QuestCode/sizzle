//
//  SignUpViewController.swift
//  FUDI
//
//  Created by Devontae Reid on 11/27/15.
//  Copyright © 2015 Devontae Reid. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    let actId : UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        actId.center = self.view.center
        actId.hidesWhenStopped = true
        actId.activityIndicatorViewStyle = .gray
        view.addSubview(actId)
        backGrdSetup()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    private let backGrdImage: UIImageView = UIImageView()

    private func backGrdSetup()
    {
        backGrdImage.translatesAutoresizingMaskIntoConstraints = false;
        view.addSubview(backGrdImage);
        view.addConstraints([
            NSLayoutConstraint(item: backGrdImage, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: backGrdImage, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: backGrdImage, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: backGrdImage, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1.0, constant: 0)
            ])
        backGrdImage.animationImages = [
            UIImage(named: "dinner")!,
            UIImage(named: "chipotleCheeseSteakPasta")!
        ];
        backGrdImage.animationDuration = 18;
        backGrdImage.startAnimating();
        
        
        let tint: UIView = UIView(frame: view.frame);
        tint.backgroundColor = UIColor.black
        tint.alpha = 0.7;
        view.addSubview(tint);
        
        buttonsSetup()
    }
    
    private func buttonsSetup()
    {
        let backButton: ZFRippleButton = ZFRippleButton()
        backButton.layer.cornerRadius = 10
        backButton.setTitle("Already have an account", for: .normal)
        backButton.titleLabel?.textColor = UIColor.white
        backButton.titleLabel?.font = UIFont.LatoRegular(fontSize: 14)
        backButton.backgroundColor = UIColor.deepPink()
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self, action: Selector(("goToLogin")), for: .touchUpInside)
        view.addSubview(backButton)
        view.addConstraints([
            
            NSLayoutConstraint(item: backButton, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.0, constant: 50),
            NSLayoutConstraint(item: backButton, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1.0, constant: 10),
            NSLayoutConstraint(item: backButton, attribute: .right, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: -10),
            NSLayoutConstraint(item: backButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 40)
            ])
        
        let loginButton: ZFRippleButton = ZFRippleButton()
        loginButton.layer.cornerRadius = 10
        loginButton.setTitle("Sign In", for: .normal)
        loginButton.titleLabel?.textColor = UIColor.white
        loginButton.titleLabel?.font = UIFont.LatoRegular(fontSize: 14)
        loginButton.backgroundColor = UIColor.deepPink()
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.addTarget(self, action: Selector(("signUp")), for: .touchUpInside)
        view.addSubview(loginButton)
        view.addConstraints([
            
            NSLayoutConstraint(item: loginButton, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.0, constant: 50),
            NSLayoutConstraint(item: loginButton, attribute: .left, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 10),
            NSLayoutConstraint(item: loginButton, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1.0, constant: -10),
            NSLayoutConstraint(item: loginButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 40)
            ])
        
        textFieldsForLoginAndPassword()
    }
    
    func goToLogin()
    {
        self.present(LoginViewController(), animated: true) { () -> Void in
            print("Going back to back to cali")
        }
    }
    
    
    private let usernameTextField: JOTextField = JOTextField()
    private let emailTextField: JOTextField = JOTextField()
    private let passwordFirstTextField: JOTextField = JOTextField()
    private let passwordSecondTextField: JOTextField = JOTextField()
    
    private func textFieldsForLoginAndPassword()
    {
        let textFieldContainer: UIView = UIView()
        textFieldContainer.translatesAutoresizingMaskIntoConstraints = false
        //textFieldContainer.backgroundColor = UIColor.blueColor()
        view.addSubview(textFieldContainer)
        view.addConstraints([
            
            NSLayoutConstraint(item: textFieldContainer, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1.0, constant: 15),
            NSLayoutConstraint(item: textFieldContainer, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1.0, constant: -15),
            NSLayoutConstraint(item: textFieldContainer, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 100),
            NSLayoutConstraint(item: textFieldContainer, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 240)
            ])
        
        
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        usernameTextField.textColor = UIColor.white
        usernameTextField.type = 103
        usernameTextField.config()
        textFieldContainer.addSubview(usernameTextField)
        textFieldContainer.addConstraints([
            
            NSLayoutConstraint(item: usernameTextField, attribute: .left, relatedBy: .equal, toItem: textFieldContainer, attribute: .left, multiplier: 1.0, constant: 10),
            NSLayoutConstraint(item: usernameTextField, attribute: .right, relatedBy: .equal, toItem: textFieldContainer, attribute: .right, multiplier: 1.0, constant: -10),
            NSLayoutConstraint(item: usernameTextField, attribute: .top, relatedBy: .equal, toItem: textFieldContainer, attribute: .top, multiplier: 1.0, constant: 10),
            NSLayoutConstraint(item: usernameTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 50)
            ])
        
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.textColor = UIColor.white
        emailTextField.type = 100
        emailTextField.config()
        textFieldContainer.addSubview(emailTextField)
        textFieldContainer.addConstraints([
            
            NSLayoutConstraint(item: emailTextField, attribute: .left, relatedBy: .equal, toItem: textFieldContainer, attribute: .left, multiplier: 1.0, constant: 10),
            NSLayoutConstraint(item: emailTextField, attribute: .right, relatedBy: .equal, toItem: textFieldContainer, attribute: .right, multiplier: 1.0, constant: -10),
            NSLayoutConstraint(item: emailTextField, attribute: .top, relatedBy: .equal, toItem: usernameTextField, attribute: .bottom, multiplier: 1.0, constant: 5),
            NSLayoutConstraint(item: emailTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 50)
            ])
        
        
        passwordFirstTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordFirstTextField.textColor = UIColor.white
        passwordFirstTextField.type = 104
        passwordFirstTextField.config()
        textFieldContainer.addSubview(passwordFirstTextField)
        textFieldContainer.addConstraints([
            
            NSLayoutConstraint(item: passwordFirstTextField, attribute: .left, relatedBy: .equal, toItem: textFieldContainer, attribute: .left, multiplier: 1.0, constant: 10),
            NSLayoutConstraint(item: passwordFirstTextField, attribute: .right, relatedBy: .equal, toItem: textFieldContainer, attribute: .right, multiplier: 1.0, constant: -10),
            NSLayoutConstraint(item: passwordFirstTextField, attribute: .top, relatedBy: .equal, toItem: emailTextField, attribute: .bottom, multiplier: 1.0, constant: 5),
            NSLayoutConstraint(item: passwordFirstTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 50)
            ])

        
        passwordSecondTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordSecondTextField.textColor = UIColor.white
        passwordSecondTextField.type = 104
        passwordSecondTextField.config()
        textFieldContainer.addSubview(passwordSecondTextField)
        textFieldContainer.addConstraints([
            
            NSLayoutConstraint(item: passwordSecondTextField, attribute: .left, relatedBy: .equal, toItem: textFieldContainer, attribute: .left, multiplier: 1.0, constant: 10),
            NSLayoutConstraint(item: passwordSecondTextField, attribute: .right, relatedBy: .equal, toItem: textFieldContainer, attribute: .right, multiplier: 1.0, constant: -10),
            NSLayoutConstraint(item: passwordSecondTextField, attribute: .top, relatedBy: .equal, toItem: passwordFirstTextField, attribute: .bottom, multiplier: 1.0, constant: 5),
            NSLayoutConstraint(item: passwordSecondTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 50)
            ])
        
        let password = String(describing: passwordFirstTextField.text)
        if (password.count >= 7) {
            
            if (passwordFirstTextField.text == passwordSecondTextField.text)
            {
            }
            else
            {
                
            }
        }
    }
    


}
