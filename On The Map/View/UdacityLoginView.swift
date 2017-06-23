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
    
    
    // MARK:- View and Storyboard Setup
    
    func setup() {
        self.view = UINib(nibName: nibName, bundle: Bundle(for: type(of: self))).instantiate(withOwner: self, options: nil)[0] as! UIView // Loads the xib file and creates a UIView isntance
        self.loginButton.setCornerRadius(radius: 5) // Rounded Corner on Button
        
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
    
    // MARK:-  IBActions
    
    @IBAction func loginButtonClicked(_ sender: Any) {
        delegate?.loginAttempted(with: emailTextField.text!, password: passwordTextField.text!)
        
        let udacityClient = UdacityClient.shared
        udacityClient.startSession(completion: (delegate?.loginCompleted)!)
        
    }
    
    @IBAction func signUpButtonClicked(_ sender: Any) {
        delegate?.signUp?() // Sign up might not have been implemented
    }
}

extension UdacityLoginView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.loginButton.isEnabled = !(emailTextField.text?.isEmpty)! && !(passwordTextField.text?.isEmpty)! // Enable loginButton if both Fields are not empty
    }
}
