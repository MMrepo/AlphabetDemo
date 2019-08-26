//
//  AnimationsViewControler.swift
//  Alphabet
//
//  Created by Mateusz Małek on 24.01.2018.
//  Copyright © 2018 Mateusz Małek. All rights reserved.
//

import UIKit

class AnimationsViewControler: UIViewController {
    
    let textView = AlpahetText()
    public var textColor: UIColor = .black {
        didSet {
            textView.textColor = textColor
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(textView)
        textView.stringToPrint = "test"
        
        textView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        textView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant:-20).isActive = true
        textView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant:20).isActive = true
        textView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant:-20).isActive = true
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func handleTextField(_ sender: UITextField) {
        self.textView.stringToPrint = sender.text ?? ""
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func handleBuildTextButtonTapped(_ sender: UIButton) {
        self.view.endEditing(true)
    }
    
    @IBAction func startAnimation1(_ sender: UIButton) {
        textView.startAnimation1(withDelay: 0.1)
    }
    @IBAction func startAnimation2(_ sender: UIButton) {
        textView.startAnimation2(withDelay: 0.1)

    }
    @IBAction func startAnimation3(_ sender: UIButton) {
        textView.startAnimation3(withDelay: 0.1)

    }
    @IBAction func startAnimation4(_ sender: UIButton) {
        textView.startAnimation4(withDelay: 0.1)

    }
    @IBAction func startAnimation5(_ sender: UIButton) {
        textView.startAnimation5(withDelay: 0.1)

    }
    @IBAction func startAnimation6(_ sender: UIButton) {
        textView.startAnimation6(withDelay: 0.1)

    }
    
}

