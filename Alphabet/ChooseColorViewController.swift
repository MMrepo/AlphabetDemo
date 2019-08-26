//
//  ChooseColorViewController.swift
//  Alphabet
//
//  Created by Mateusz Małek on 24.01.2018.
//  Copyright © 2018 Mateusz Małek. All rights reserved.
//

import UIKit
import ColorWheel

class ChooseColorViewController: UIViewController {
    
    @IBOutlet weak var colorWheelContainer: UIView!
    public var color:UIColor!
    public weak var senderViewController: ViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let colorWheel = ColorWheel(frame: colorWheelContainer.frame, color: color, colorSelected: { (color) in
            self.color = color
        })
        colorWheel.translatesAutoresizingMaskIntoConstraints = false
        
        self.colorWheelContainer.addSubview(colorWheel)
        
        NSLayoutConstraint.activate([
            colorWheel.bottomAnchor.constraint(equalTo: self.colorWheelContainer.bottomAnchor, constant: 0),
            colorWheel.topAnchor.constraint(equalTo: self.colorWheelContainer.topAnchor, constant: 0),
            colorWheel.leadingAnchor.constraint(equalTo: self.colorWheelContainer.leadingAnchor, constant: 0),
            colorWheel.trailingAnchor.constraint(equalTo: self.colorWheelContainer.trailingAnchor, constant:0)
            ])
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    

    @IBAction func handleChooseColorButtonTapped(_ sender: Any) {
        self.senderViewController?.textColor = color
        self.dismiss(animated: true) {
            
        }
    }
    
}
