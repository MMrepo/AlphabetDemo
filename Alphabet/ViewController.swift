//
//  ViewController.swift
//  Alphabet
//
//  Created by Mateusz Małek on 23.01.2018.
//  Copyright © 2018 Mateusz Małek. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var colorButton: UIButton!
    let textView = AlpahetText()
    public var textColor: UIColor = .black {
        didSet {
            self.colorButton.backgroundColor = textColor
            textView.textColor = textColor
        }
    }
    @IBOutlet weak var contourSlide: UISlider!
    @IBOutlet weak var radiusSlider: UISlider!
    
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

    @IBAction func handleContourSlider(_ sender: UISlider) {
        textView.strokeEnd = CGFloat(sender.value)
    }
    
    @IBAction func handleRadiusSlider(_ sender: UISlider) {
        textView.shadowRadius = CGFloat(sender.value)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func handleColorButtonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ChooseColorViewController") as! ChooseColorViewController

        controller.color = self.textColor
        controller.senderViewController = self
        self.present(controller, animated: true, completion: nil)
    }

    @IBAction func handleLineWidthSlider(_ sender: UISlider) {
        self.textView.lineWidth = CGFloat(sender.value)
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
    @IBAction func RandomizeLettersPositionButton(_ sender: UIButton) {
        self.textView.randomizePosition()
    }
}

