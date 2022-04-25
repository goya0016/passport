//
//  SplashViewController.swift
//  goya0016-FinalProject
//
//  Created by Nipun Goyal on 2020-12-14.
//

import UIKit

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //delaying the excution by 3 seconds
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3.0) {
            // Code for delayed execution
            self.performSegue(withIdentifier: "showPassportTableView", sender: Any?.self)
        }

        // Do any additional setup after loading the view.
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
