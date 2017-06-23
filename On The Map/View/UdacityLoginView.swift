//
//  UdacityLoginView.swift
//  On The Map
//
//  Created by Javon Davis on 22/06/2017.
//  Copyright © 2017 Javon Davis. All rights reserved.
//

import UIKit

// In case I need to Login with Udacity again :), P.S. Gonna Need the client code if using this in another project
@IBDesignable // So I can see it in my main storyboard
class UdacityLoginView: UIView {

    @IBInspectable var nibName:String = "UdacityLoginView"
    var view: UIView!
    weak var delegate: UdacityDelegate? // Not completely sure why this needs to be weak, why do we not want it to be retained? TODO: Google more
    
    // MARK:- IBOutlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var noAccountLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    enum ViewState{ case idle, logginIn }
    
    
    // MARK:- View and Storyboard Setup
    
    func setup() {
        self.view = UINib(nibName: nibName, bundle: Bundle(for: type(of: self))).instantiate(withOwner: self, options: nil)[0] as! UIView // Loads the xib file and creates a UIView isntance
        self.loginButton.setCornerRadius(radius: 5) // Rounded Corner on Button
        errorLabel.isHidden = true
        loadingIndicator.stopAnimating()
        
        self.view.frame = bounds
        self.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setup()
        self.view.prepareForInterfaceBuilder()
    }
    
    // TODO: Function for allowing Login with accessToken
    
    func setUserInteraction(enabled: Bool) {
        self.isUserInteractionEnabled = enabled
    }
    
    func changeViewState(state: ViewState) {
        
        let enabled = state == .idle
        
        if enabled {
            loadingIndicator.stopAnimating()
        } else {
            loadingIndicator.startAnimating()
        }
        emailTextField.isEnabled = enabled
        passwordTextField.isEnabled = enabled
        loginButton.isEnabled = enabled
    }
    // MARK:-  IBActions
    
    @IBAction func loginButtonClicked(_ sender: Any) {
        
        guard !(emailTextField.text?.isEmpty)! && !(passwordTextField.text?.isEmpty)! else {
            errorLabel.isHidden = false
            errorLabel.text = "Please enter both an email and a password"
            return
        }
        
        errorLabel.isHidden = true
        
        let username = emailTextField.text!
        let password = passwordTextField.text!
        
        self.changeViewState(state: .logginIn)
        
        delegate?.didAttemptLogin(with: username, password: password)
        
        let udacityClient = UdacityClient.shared
        udacityClient.startSession(username: username, password: password, completion: { sessionId, userId, error in
            
            performUIUpdatesOnMain {
                self.changeViewState(state: .idle)
                self.delegate?.didCompleteLogin(sessionId: sessionId, userId: userId, error: error)
            }
            
        })
        
    }
    
    @IBAction func signUpButtonClicked(_ sender: Any) {
        delegate?.didClickSignUp?()
    }
}

extension UdacityLoginView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.loginButton.isEnabled = !(emailTextField.text?.isEmpty)! && !(passwordTextField.text?.isEmpty)! // Enable loginButton if both Fields are not empty
    }
}
