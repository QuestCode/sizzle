

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn


class LoginViewController: UIViewController {

    
    // MARK: UI Properties
    let backGrdImage: UIImageView = UIImageView()
    let actId : UIActivityIndicatorView = UIActivityIndicatorView()
    
    var usernameTextField: JOTextField = JOTextField()
    var passwordTextField: JOTextField = JOTextField()
    var emailTextField: JOTextField = JOTextField()
    var passwordSecondTextField: JOTextField = JOTextField()
    
    let loginButton: ZFRippleButton = ZFRippleButton()
    
    lazy var segContr : UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Login","Sign Up"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = UIColor.white
        sc.selectedSegmentIndex = 0
        sc.addTarget(self, action: "handlerLoginSignUp", forControlEvents: .ValueChanged)
        return sc
    }()
    
    // MARK: Overriden Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        actId.center = self.view.center
        actId.hidesWhenStopped = true
        actId.activityIndicatorViewStyle = .Gray
        view.addSubview(actId)
        backGrdSetup(true)
        
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.navigationBar.hidden = false
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func handleLoginSignupAction() {
        if segContr.selectedSegmentIndex == 0 {
            loginAction()
        } else {
            signUpAction()
        }
    }
    
    
    // MARK: Email Sign In / Sign Up
    
    func loginAction()
    {
        
        guard let email = emailTextField.text , let password = passwordTextField.text else {
            print("Form is invalid")
            return
        }
        
        FIRAuth.auth()?.signInWithEmail(email, password: password, completion: { (user, error) -> Void in
            if error != nil {
                print(error)
            } else {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        })
    }
    
    private func displayAlert(title: String,message: String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func signUpAction()
    {
        guard let email = emailTextField.text , let password = passwordTextField.text, let name = usernameTextField.text else {
            print("Form is invalid")
            return
        }
        
        FIRAuth.auth()?.createUserWithEmail(email, password: password, completion: { (user, error) -> Void in
            
            if error != nil {
                print(error)
            }
            
            guard let uid = user?.uid else {
                return
            }
            
            let ref = FIRDatabase.database().referenceFromURL("https://crumblestorage.firebaseio.com/")
            let userRef = ref.child("users").child(uid)
            let values = ["username": name, "email" : email]
            
            userRef.updateChildValues(values, withCompletionBlock: { (error, ref) -> Void in
                if error != nil {
                    print("Error \(error)")
                } else {
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            })
        })
        
    }
    
    
    private func goToHomeView()
    {
        
    }


}

// MARK: UI Setup

extension LoginViewController
{
    private func backGrdSetup(log:Bool)
    {
        backGrdImage.translatesAutoresizingMaskIntoConstraints = false;
        view.addSubview(backGrdImage);
        view.addConstraints([
            NSLayoutConstraint(item: backGrdImage, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: backGrdImage, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: backGrdImage, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: backGrdImage, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 1.0, constant: 0)
            ])
        backGrdImage.animationImages = [
            UIImage(named: "dinner")!,
            UIImage(named: "chipotleCheeseSteakPasta")!
        ];
        backGrdImage.animationDuration = 18;
        backGrdImage.startAnimating();
        
        let tint: UIView = UIView(frame: view.frame);
        tint.backgroundColor = UIColor.blackColor();
        tint.alpha = 0.7;
        view.addSubview(tint);
        
        logoLabels()
        
        
        loginButton.backgroundColor = UIColor.orangeColor()
        loginButton.clipsToBounds = true
        loginButton.titleLabel?.textColor = UIColor.whiteColor()
        loginButton.titleLabel?.font = UIFont.LatoRegular(18)
        loginButton.addTarget(self, action: "handleLoginSignupAction", forControlEvents: .TouchUpInside)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginButton)
        view.addConstraints([
            
            NSLayoutConstraint(item: loginButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1.0, constant: 40),
            NSLayoutConstraint(item: loginButton, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1.0, constant: 20),
            NSLayoutConstraint(item: loginButton, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1.0, constant: -20),
            NSLayoutConstraint(item: loginButton, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .CenterY, multiplier: 1.0, constant: 80)
            ])
        
        signInWithGoogleOrFacebook()
        
        if log {
            textFieldsForLoginAndPassword()
            loginButton.setTitle("Login", forState: UIControlState.Normal)
        } else {
            signupTextFieldsForLoginAndPassword()
        }
        
    }
    
    
    private func logoLabels()
    {
        let helpingHandLogo: UIImageView = UIImageView()
        helpingHandLogo.translatesAutoresizingMaskIntoConstraints = false
        helpingHandLogo.image = UIImage(named: "sizzle_logo")
        view.addSubview(helpingHandLogo)
        view.addConstraints([
            
            NSLayoutConstraint(item: helpingHandLogo, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1.0, constant: 10),
            NSLayoutConstraint(item: helpingHandLogo, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1.0, constant: -10),
            NSLayoutConstraint(item: helpingHandLogo, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1.0, constant: 180),
            NSLayoutConstraint(item: helpingHandLogo, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1.0, constant: 60)
            ])
        
        
        view.addSubview(segContr)
        view.addConstraints([
            NSLayoutConstraint(item: segContr, attribute: .CenterY, relatedBy: .Equal, toItem: view, attribute: .CenterY, multiplier: 1.0, constant: -140),
            NSLayoutConstraint(item: segContr, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1.0, constant: 30),
            NSLayoutConstraint(item: segContr, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1.0, constant: 20),
            NSLayoutConstraint(item: segContr, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1.0, constant: -20)
            ])
    }
    
    private func textFieldsForLoginAndPassword()
    {
        let textFieldContainer: UIView = UIView()
        textFieldContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textFieldContainer)
        view.addConstraints([
            
            NSLayoutConstraint(item: textFieldContainer, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1.0, constant: 15),
            NSLayoutConstraint(item: textFieldContainer, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1.0, constant: -15),
            NSLayoutConstraint(item: textFieldContainer, attribute: .CenterY, relatedBy: .Equal, toItem: view, attribute: .CenterY, multiplier: 1.0, constant: -30),
            NSLayoutConstraint(item: textFieldContainer, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1.0, constant: 90)
            ])
        
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        usernameTextField.type = 100
        usernameTextField.config()
        textFieldContainer.addSubview(usernameTextField)
        textFieldContainer.addConstraints([
            
            NSLayoutConstraint(item: usernameTextField, attribute: .Left, relatedBy: .Equal, toItem: textFieldContainer, attribute: .Left, multiplier: 1.0, constant: 10),
            NSLayoutConstraint(item: usernameTextField, attribute: .Right, relatedBy: .Equal, toItem: textFieldContainer, attribute: .Right, multiplier: 1.0, constant: -10),
            NSLayoutConstraint(item: usernameTextField, attribute: .Top, relatedBy: .Equal, toItem: textFieldContainer, attribute: .Top, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: usernameTextField, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1.0, constant: 40)
            ])
        
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.type = 104
        passwordTextField.config()
        textFieldContainer.addSubview(passwordTextField)
        textFieldContainer.addConstraints([
            
            NSLayoutConstraint(item: passwordTextField, attribute: .Left, relatedBy: .Equal, toItem: textFieldContainer, attribute: .Left, multiplier: 1.0, constant: 10),
            NSLayoutConstraint(item: passwordTextField, attribute: .Right, relatedBy: .Equal, toItem: textFieldContainer, attribute: .Right, multiplier: 1.0, constant: -10),
            NSLayoutConstraint(item: passwordTextField, attribute: .Bottom, relatedBy: .Equal, toItem: textFieldContainer, attribute: .Bottom, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: passwordTextField, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1.0, constant: 40)
            ])
        
        loginButton.backgroundColor = UIColor.orangeColor()
        loginButton.layer.cornerRadius = 10
        loginButton.clipsToBounds = true
        loginButton.titleLabel?.textColor = UIColor.whiteColor()
        loginButton.titleLabel?.font = UIFont.LatoRegular(18)
        loginButton.addTarget(self, action: "loginAction", forControlEvents: .TouchUpInside)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginButton)
    }
    
    func handlerLoginSignUp() {
        let title = segContr.titleForSegmentAtIndex(segContr.selectedSegmentIndex)
        loginButton.setTitle(title, forState: UIControlState.Normal)
        
        switch (segContr.selectedSegmentIndex) {
        case 0:
            backGrdSetup(true)
        case 1 :
            backGrdSetup(false)
        default  :
            print("Not a value")
        }
    }
}

extension LoginViewController {
    
    private func signupTextFieldsForLoginAndPassword()
    {
        let textFieldContainer: UIView = UIView()
        textFieldContainer.translatesAutoresizingMaskIntoConstraints = false
        //textFieldContainer.backgroundColor = UIColor.blueColor()
        view.addSubview(textFieldContainer)
        view.addConstraints([
            
            NSLayoutConstraint(item: textFieldContainer, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1.0, constant: 15),
            NSLayoutConstraint(item: textFieldContainer, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1.0, constant: -15),
            NSLayoutConstraint(item: textFieldContainer, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .CenterY, multiplier: 1.0, constant: 55),
            NSLayoutConstraint(item: textFieldContainer, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 180)
            ])
        
        
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        usernameTextField.textColor = UIColor.whiteColor()
        usernameTextField.type = 103
        usernameTextField.config()
        textFieldContainer.addSubview(usernameTextField)
        textFieldContainer.addConstraints([
            
            NSLayoutConstraint(item: usernameTextField, attribute: .Left, relatedBy: .Equal, toItem: textFieldContainer, attribute: .Left, multiplier: 1.0, constant: 10),
            NSLayoutConstraint(item: usernameTextField, attribute: .Right, relatedBy: .Equal, toItem: textFieldContainer, attribute: .Right, multiplier: 1.0, constant: -10),
            NSLayoutConstraint(item: usernameTextField, attribute: .Top, relatedBy: .Equal, toItem: textFieldContainer, attribute: .Top, multiplier: 1.0, constant: 10),
            NSLayoutConstraint(item: usernameTextField, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1.0, constant: 40)
            ])
        
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.textColor = UIColor.whiteColor()
        emailTextField.type = 100
        emailTextField.config()
        textFieldContainer.addSubview(emailTextField)
        textFieldContainer.addConstraints([
            
            NSLayoutConstraint(item: emailTextField, attribute: .Left, relatedBy: .Equal, toItem: textFieldContainer, attribute: .Left, multiplier: 1.0, constant: 10),
            NSLayoutConstraint(item: emailTextField, attribute: .Right, relatedBy: .Equal, toItem: textFieldContainer, attribute: .Right, multiplier: 1.0, constant: -10),
            NSLayoutConstraint(item: emailTextField, attribute: .Top, relatedBy: .Equal, toItem: usernameTextField, attribute: .Bottom, multiplier: 1.0, constant: 5),
            NSLayoutConstraint(item: emailTextField, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1.0, constant: 40)
            ])
        
        
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.textColor = UIColor.whiteColor()
        passwordTextField.type = 104
        passwordTextField.config()
        textFieldContainer.addSubview(passwordTextField)
        textFieldContainer.addConstraints([
            
            NSLayoutConstraint(item: passwordTextField, attribute: .Left, relatedBy: .Equal, toItem: textFieldContainer, attribute: .Left, multiplier: 1.0, constant: 10),
            NSLayoutConstraint(item: passwordTextField, attribute: .Right, relatedBy: .Equal, toItem: textFieldContainer, attribute: .Right, multiplier: 1.0, constant: -10),
            NSLayoutConstraint(item: passwordTextField, attribute: .Top, relatedBy: .Equal, toItem: emailTextField, attribute: .Bottom, multiplier: 1.0, constant: 5),
            NSLayoutConstraint(item: passwordTextField, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1.0, constant: 40)
            ])
        
        
        passwordSecondTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordSecondTextField.textColor = UIColor.whiteColor()
        passwordSecondTextField.type = 104
        passwordSecondTextField.config()
        textFieldContainer.addSubview(passwordSecondTextField)
        textFieldContainer.addConstraints([
            
            NSLayoutConstraint(item: passwordSecondTextField, attribute: .Left, relatedBy: .Equal, toItem: textFieldContainer, attribute: .Left, multiplier: 1.0, constant: 10),
            NSLayoutConstraint(item: passwordSecondTextField, attribute: .Right, relatedBy: .Equal, toItem: textFieldContainer, attribute: .Right, multiplier: 1.0, constant: -10),
            NSLayoutConstraint(item: passwordSecondTextField, attribute: .Top, relatedBy: .Equal, toItem: passwordTextField, attribute: .Bottom, multiplier: 1.0, constant: 5),
            NSLayoutConstraint(item: passwordSecondTextField, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1.0, constant: 40)
            ])
    }
}

// MARK: Google Sign In or Facebook
extension LoginViewController: GIDSignInUIDelegate, FBSDKLoginButtonDelegate {
    func signInWithGoogleOrFacebook()
    {
        let socialButtonContainer = UIView()
        socialButtonContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(socialButtonContainer)
        view.addConstraints([
            NSLayoutConstraint(item: socialButtonContainer, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1.0, constant: 20),
            NSLayoutConstraint(item: socialButtonContainer, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1.0, constant: -20),
            NSLayoutConstraint(item: socialButtonContainer, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .CenterY, multiplier: 1.0, constant: 180),
            NSLayoutConstraint(item: socialButtonContainer, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1.0, constant: 45)
            ])
        
        GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
        GIDSignIn.sharedInstance().uiDelegate = self
        
        let googleButton: GIDSignInButton = GIDSignInButton()
        googleButton.layer.cornerRadius = 0
        googleButton.translatesAutoresizingMaskIntoConstraints = false
        socialButtonContainer.addSubview(googleButton)
        socialButtonContainer.addConstraints([
            NSLayoutConstraint(item: googleButton, attribute: .Left, relatedBy: .Equal, toItem: socialButtonContainer, attribute: .Left, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: googleButton, attribute: .Right, relatedBy: .Equal, toItem: socialButtonContainer, attribute: .CenterX, multiplier: 1.0, constant: -5),
            NSLayoutConstraint(item: googleButton, attribute: .Bottom, relatedBy: .Equal, toItem: socialButtonContainer, attribute: .Bottom, multiplier: 1.0, constant: 0)
            ])
        
        let facebookButton = FBSDKLoginButton()
        facebookButton.layer.cornerRadius = 30
        facebookButton.readPermissions = ["public_profile","email"]
        facebookButton.delegate = self
        facebookButton.translatesAutoresizingMaskIntoConstraints = false
        socialButtonContainer.addSubview(facebookButton)
        socialButtonContainer.addConstraints([
            NSLayoutConstraint(item: facebookButton, attribute: .Right, relatedBy: .Equal, toItem: socialButtonContainer, attribute: .Right, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: facebookButton, attribute: .Left, relatedBy: .Equal, toItem: socialButtonContainer, attribute: .CenterX, multiplier: 1.0, constant: 5),
            NSLayoutConstraint(item: facebookButton, attribute: .Bottom, relatedBy: .Equal, toItem: socialButtonContainer, attribute: .Bottom, multiplier: 1.0, constant: -3),
            NSLayoutConstraint(item: facebookButton, attribute: .Top, relatedBy: .Equal, toItem: socialButtonContainer, attribute: .Top, multiplier: 1.0, constant: 1)
            ])

    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("User log in")
        print(FBSDKAccessToken.currentAccessToken().tokenString)
        
//        let cred = FIRFacebookAuthProvider.credentialWithAccessToken(FBSDKAccessToken.currentAccessToken().tokenString)
//        
//        FIRAuth.auth()?.signInWithCredential(cred, completion: { (user, error) -> Void in
//            if (error != nil) {
//                print(error?.localizedDescription)
//            }
//        })
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User log out")
    }
}
