//
//  StartViewController.swift
//  XO-game
//
//  Created by aprirez on 12/28/20.
//  Copyright © 2020 plasmon. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    @IBOutlet weak var twoPlayers: UIButton!
    @IBOutlet weak var playWithPC: UIButton!
    @IBOutlet weak var sequenceMode: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func twoPlayers(_ sender: UIButton) {
        self.performSegue(withIdentifier: "GameSegue", sender: sender)
    }
    
    @IBAction func playWithPC(_ sender: UIButton) {
        self.performSegue(withIdentifier: "GameSegue", sender: sender)
    }
    
    @IBAction func sequenceMode(_ sender: UIButton) {
        self.performSegue(withIdentifier: "GameSegue", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let sender = sender as? UIButton else {return}
        switch segue.identifier {
        case "GameSegue":
            guard let gameViewController = segue.destination as? GameViewController else {return}
            
            switch sender {
            case twoPlayers:
                gameViewController.withHuman = true
                gameViewController.sequentalMode = false
            case playWithPC:
                gameViewController.withHuman = false
                gameViewController.sequentalMode = false
            case sequenceMode:
                gameViewController.withHuman = true
                gameViewController.sequentalMode = true
            default:
                break
            }

        default:
            break
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
