//
//  OnboardingViewController.swift
//  Keep
//
//  Created by Mirim An on 3/4/17.
//  Copyright © 2017 Mimicatcodes. All rights reserved.
//

import UIKit
import paper_onboarding

class OnboardingViewController: UIViewController, PaperOnboardingDataSource {

    @IBOutlet weak var onboarding: PaperOnboarding!
 
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func onboardingItemAtIndex(_ index: Int) -> OnboardingItemInfo {
        let backgroundColor = Colors.duckEggBlue
        let titleFont = UIFont(name: Fonts.montserratSemiBold, size: 20)
        let descriptionFont = UIFont(name: Fonts.montserratRegular, size: 14.0)
        
        return [
            (UIImage.Asset.checkList.rawValue, "Stay Organized", "Running out of stock? Create a shopping list to remind yourself and start shopping easily", UIImage.Asset.checkList.rawValue, backgroundColor, Colors.greyishBrown, Colors.brownishGreyThree, titleFont!,descriptionFont!),
            (UIImage.Asset.piggyBank.rawValue, "Save Money", "By keeping track of your food, you are actually reducing chances of  food waste and saving your money.", UIImage.Asset.piggyBank.rawValue, backgroundColor, Colors.greyishBrown, Colors.brownishGreyThree, titleFont!,descriptionFont!),
            (UIImage.Asset.produce.rawValue, "Be Healthy", "KEEP alerts you before your food expires, so you can always eat your produce at its best condition.", UIImage.Asset.produce.rawValue, backgroundColor, Colors.greyishBrown, Colors.brownishGreyThree, titleFont!,descriptionFont!)
            ][index]
    }
    
    func onboardingItemsCount() -> Int {
        return 3
    }

}

