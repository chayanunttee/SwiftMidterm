//
//  TableMysegmentController.swift
//  dbmidterm
//
//  Created by Admin on 5/3/2562 BE.
//  Copyright © 2562 Admin. All rights reserved.
//

import UIKit

class TableMysegmentController: UIViewController {
    
    @IBOutlet weak var showHello: UILabel!
    @IBAction func quiet(_ sender: UIButton) {
        var num : Int32
        num = 1
        num += num
        let mynum = String(num)
        showHello.text = "เฉยๆ " + mynum
    }
    @IBAction func happy(_ sender: UIButton) {
        var num : Int32
        num = 1
        num += num
        let mynum = String(num)
        showHello.text = "พอใจ " + mynum
    }
    @IBAction func unhappy(_ sender: UIButton) {
        var num : Int32
        num = 1
        num += num
        let mynum = String(num)
        showHello.text = "ไม่พอใจ " + mynum
    }
    
    
    @IBAction func mySegmentInput(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.view.backgroundColor = UIColor.yellow
        case 1:
            self.view.backgroundColor = UIColor.green
        case 2:
            self.view.backgroundColor = UIColor.red
        default:
            self.view.backgroundColor = UIColor.yellow
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.yellow
        showHello.text = ""
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
