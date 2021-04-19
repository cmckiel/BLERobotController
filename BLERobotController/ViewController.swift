//
//  ViewController.swift
//  BLERobotController
//
//  Created by Guest on 4/18/21.
//

import UIKit

class ViewController: UIViewController, BLEModelDelegate {

    var bleModel: BLEModel?
    
    @IBOutlet weak var connectButton: UIButton!
    @IBOutlet weak var infoLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bleModel = BLEModel()
        bleModel?.delegate = self
    }
    
    @IBAction func connect(_ sender: Any) {
        bleModel?.initCentralManager()
        connectButton.isEnabled = false
    }
    
    @IBAction func forward(_ sender: Any) {
        bleModel?.sendData([65])
    }
    
    @IBAction func left(_ sender: Any) {
        bleModel?.sendData([66])
    }
    
    @IBAction func right(_ sender: Any) {
        bleModel?.sendData([67])
    }
    
    @IBAction func disconnect(_ sender: Any) {
        bleModel?.disconnect()
        connectButton.isEnabled = true
    }
    
    //MARK - BLEModelDelegate
    func updateInfo(info: String) {
        infoLabel.text = info
    }
}

