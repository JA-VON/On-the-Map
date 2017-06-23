//
//  UdacityLoginView.swift
//  On The Map
//
//  Created by Javon Davis on 22/06/2017.
//  Copyright © 2017 Javon Davis. All rights reserved.
//

import UIKit

// In case I need to Login with Udacity again :)
@IBDesignable // So I can see it in my main storyboard
class UdacityLoginView: UIView {

    @IBInspectable var nibName:String = "UdacityLoginView"
    var view: UIView!
    
    func setup() {
        self.view = UINib(nibName: nibName, bundle: Bundle(for: type(of: self))).instantiate(withOwner: self, options: nil)[0] as! UIView // Loads the xib file and creates a UIView isntance
        
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
}
