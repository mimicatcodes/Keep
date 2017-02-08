//
//  ScanReceiptVC.swift
//  Keep
//
//  Created by Luna An on 2/7/17.
//  Copyright © 2017 Mimicatcodes. All rights reserved.
//

import UIKit
import TesseractOCR

class ScanReceiptVC: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate, G8TesseractDelegate {
    
    var selectedImage: UIImage?
    var textsScanned:String = ""
    var emptyArray = [String]()
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true
        
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func dismissScanne(_ sender: Any) {
       dismiss(animated: true, completion: nil)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        emptyArray.removeAll()
    }
    
    func processScanning(){
    
        let tesseract:G8Tesseract = G8Tesseract(language: "eng")
        tesseract.engineMode = .tesseractCubeCombined
        tesseract.pageSegmentationMode = .auto
        tesseract.maximumRecognitionTime = 30.0
        tesseract.delegate = self
        
        guard let img = imageView.image  else { return }
        DispatchQueue.main.async {
            self.addActivityIndicator()
        }
        
        tesseract.image = img.g8_blackAndWhite()
        tesseract.recognize()
        addActivityIndicator()
        
        print(tesseract.recognizedText)
        
        textsScanned = tesseract.recognizedText
        print(textsScanned)
        let newlineChars = NSCharacterSet.newlines
        let elementsArray = textsScanned.components(separatedBy: newlineChars).filter {!$0.isEmpty        }
        print(elementsArray)
        
        for string in elementsArray {
            
            let result = string.trimmingCharacters(in: CharacterSet(charactersIn: "01234567890.,"))
            emptyArray.append(result)
            
        }
        print(emptyArray)
    }
    
    func progressImageRecognition(for tesseract: G8Tesseract!) {
        print("Recognition progress \(tesseract.progress) %...")
        
    }


    @IBAction func takePhotoButtonTapped(_ sender: Any) {
        handleCameraImage()
    }
    @IBAction func importButtonTapped(_ sender: Any) {
        handleLibraryImage()
        
    }
    @IBAction func scanButtonTapped(_ sender: Any) {
        processScanning()
        if emptyArray.isEmpty == false {
            performSegue(withIdentifier: "toNavForScannedItems", sender: self)
            imageView.image = nil
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        if let selectedImage = selectedImageFromPicker {
            imageView.image = selectedImage
        }

        dismiss(animated: true, completion: nil)
    }
    
    func handleCameraImage(){
        
        let picker = UIImagePickerController()
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.delegate = self
            picker.sourceType = .camera
            present(picker, animated: true, completion: nil)
        } else {
            print("No camera")
        }
        
        picker.allowsEditing = false
        
    }
    
    func handleLibraryImage(){
        
        let picker = UIImagePickerController()
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            picker.delegate = self
            picker.sourceType = .photoLibrary
            present(picker, animated: true, completion: nil)
            
        } else {
            print("No photo library")
        }
        
        picker.allowsEditing = true
    }
    
    func addActivityIndicator() {
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false

    }
    
    func removeActivityIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "toNavForScannedItems" {
            
            if emptyArray.isEmpty {
                
                return false
            }
                
            else {
                return true
            }
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toNavForScannedItems" {
            let destNav = segue.destination as! UINavigationController
            let targetController = destNav.topViewController as! ScanReceiptsVC
  
            if !emptyArray.isEmpty {
                targetController.resultsArray = emptyArray
            }
        }
    }
}
