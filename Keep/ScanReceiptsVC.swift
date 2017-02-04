//
//  ScanReceiptsVC.swift
//  Keep
//
//  Created by Luna An on 2/3/17.
//  Copyright © 2017 Mimicatcodes. All rights reserved.
//

import UIKit
import TesseractOCR

class ScanReceiptsVC: UIViewController, G8TesseractDelegate {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tesseract:G8Tesseract = G8Tesseract(language: "eng")
            tesseract.delegate = self
            tesseract.image = imageView.image?.g8_blackAndWhite()
            tesseract.recognize()
        print(tesseract.recognizedText)
            textView.text = tesseract.recognizedText

    }
    
    func progressImageRecognition(for tesseract: G8Tesseract!) {
        print("Recognition progress \(tesseract.progress) %...")
    }
    
}

