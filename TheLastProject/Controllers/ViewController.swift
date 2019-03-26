//
//  ViewController.swift
//  TheLastProject
//
//  Created by Tien Le P. on 3/18/19.
//  Copyright © 2019 Tien Le P. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var endpointLabel: UILabel!
    @IBOutlet weak var consumerKeyLabel: UILabel!
    @IBOutlet weak var consumerSecretLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let temp = infoForKey("Backend Url")
        endpointLabel.text = temp
        consumerKeyLabel.text = infoForKey("Consumer Key")
        consumerSecretLabel.text = infoForKey("Consumer Secret")
    }

    // MARK: Get value from Infor
    func infoForKey(_ key: String) -> String? {
        return (Bundle.main.infoDictionary?[key] as? String)?.replacingOccurrences(of: "\\", with: "")
    }

}
