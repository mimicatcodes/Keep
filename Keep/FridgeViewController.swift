////
////  FridgeViewController.swift
////  Keep
////
////  Created by Luna An on 1/2/17.
////  Copyright © 2017 Mimicatcodes. All rights reserved.
////
//
//import UIKit
//
//class FridgeViewController: UIViewController {
//
//    var fridgeSectionVC: UIViewController!
//    var freezerSectionVC: UIViewController!
//    var pantrySectionVC: UIViewController!
//    var otherSectionVC: UIViewController!
//    var viewControllers: [UIViewController]!
//    
//    var selectedIndex: Int = 0
//
//    @IBOutlet weak var menuBarView: UIView!
//    @IBOutlet weak var contentView: UIView!
//    @IBOutlet var buttons: [UIButton]!
//
//    @IBOutlet var underBars: [UIView]!
//
//    override func viewDidLoad() {
//        
//        super.viewDidLoad()
//
//        //styleButtons()
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        
//        fridgeSectionVC = storyboard.instantiateViewController(withIdentifier: "fridge")
//        freezerSectionVC = storyboard.instantiateViewController(withIdentifier: "freezer")
//        pantrySectionVC = storyboard.instantiateViewController(withIdentifier: "pantry")
//        otherSectionVC = storyboard.instantiateViewController(withIdentifier: "other")
//
//        viewControllers = [fridgeSectionVC, freezerSectionVC, pantrySectionVC, otherSectionVC]
//        
//        buttons[selectedIndex].isSelected = true
//        underBars[selectedIndex].backgroundColor = UIColor.darkGray
//        
//        didPressStockSection(buttons[selectedIndex])
//        
//    
//    }
//
//    @IBAction func didPressStockSection(_ sender: UIButton) {
//        
//        let previousIndex = selectedIndex
//        selectedIndex = sender.tag
//        
//        buttons[selectedIndex].isEnabled = false
//        buttons[previousIndex].isEnabled = true
//        
//        // Set previous button to the non-selected state
//        buttons[previousIndex].isSelected = false
//        
//        let previousVC = viewControllers[previousIndex]
//        
//        // Remove the previous VC
//        previousVC.willMove(toParentViewController: nil)
//        previousVC.view.removeFromSuperview()
//        previousVC.removeFromParentViewController()
//
//        sender.isSelected = true
//
//        let vc = viewControllers[selectedIndex]
//        addChildViewController(vc)
//        
//        vc.view.frame = contentView.bounds
//        contentView.addSubview(vc.view)
//        vc.didMove(toParentViewController: self)
//        
//        switch selectedIndex {
//        case 0:
//            navigationItem.title = "Fridge"
//        case 1:
//            navigationItem.title = "Freezer"
//        case 2:
//            navigationItem.title = "Pantry"
//        default:
//            navigationItem.title = "Other"
//        }
//        
//        // Button underbar background color changes when tapped.
//        if buttons[selectedIndex].isHighlighted {
//            underBars[selectedIndex].backgroundColor = UIColor.darkGray
//            underBars[previousIndex].backgroundColor = UIColor.clear
//        }
//
//    }
//    
//    @IBAction func addItemTapped(_ sender: Any) {
//        
//        
//        
//    }
//    
//    @IBAction func searchButtonTapped(_ sender: Any) {
//        
//    }
//    
//}
