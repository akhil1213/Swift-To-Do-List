//
//  AddErrand.swift
//  Todoey
//
//  Created by Akhil Khanna on 7/1/18.
//  Copyright © 2018 Akhil Khanna. All rights reserved.
//

import UIKit
protocol retrieveListItems{
    func addToList(data : String);
}
class AddErrand: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    var delegate : ToDoListViewController?

    @IBOutlet weak var errandString: UITextField!
    @IBAction func enteredAnErrand(_ sender: Any) {
        delegate?.addToList(data: errandString.text!)
        //If you chose show when you created your segue on stoyboard. Call this in your button click:
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    
    func addToList(data: String) {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
