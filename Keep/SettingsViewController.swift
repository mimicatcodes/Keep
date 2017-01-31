//
//  SettingsViewController.swift
//  Keep
//
//  Created by Luna An on 1/3/17.
//  Copyright © 2017 Mimicatcodes. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var sections = ["My Account","Settings","Privacy Policy","Logout"]
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var midView: UIView!
    

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorInset = .zero
        topView.underlinedBorder()
        midView.underlinedBorder()
        leftView.rightBorder()

    }
    
    // TV Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "accountCell", for: indexPath) as! AccountCell
        cell.title.text = sections[indexPath.row]
        
        return cell
    }
}

class AccountCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
}
