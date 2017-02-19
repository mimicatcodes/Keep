//
//  ScanReceiptVC.swift
//  Keep
//
//  Created by Luna An on 2/7/17.
//  Copyright © 2017 Mimicatcodes. All rights reserved.
//

import UIKit
import TesseractOCR

// TODO: Activitiy indicator / progress bar/ 

class ScanReceiptVC: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate, G8TesseractDelegate {
    
    var selectedImage: UIImage?
    var textsScanned:String = ""
    var emptyArray = [String]()
    
    @IBOutlet weak var viewUnderImgV: UIView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var libraryButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        adjustBorder()
        saveButton.isEnabled = false
        enableSaveButton()
        styleSubViews()
    }
    
    func adjustBorder(){
        
        cameraButton.layer.cornerRadius = 5
        cameraButton.layer.masksToBounds = true
        libraryButton.layer.cornerRadius = 5
        libraryButton.layer.masksToBounds = true
        saveButton.layer.cornerRadius = 5
        saveButton.layer.masksToBounds = true
    }
    
    @IBAction func cancelTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
 
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        enableSaveButton()
        emptyArray.removeAll()
    }
    
    func processScanning(){
        
        guard let img = imageView.image  else { return }
        let tesseract:G8Tesseract = G8Tesseract(language: TesseractLang.english)
        tesseract.engineMode = .tesseractCubeCombined
        tesseract.pageSegmentationMode = .auto
        tesseract.maximumRecognitionTime = 30.0
        tesseract.delegate = self
        tesseract.image = img
        tesseract.recognize()
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
        
        performSegue(withIdentifier: Identifiers.Segue.toScannedItems, sender: self)
        imageView.image = nil
        print(emptyArray)
    }
    
    func progressImageRecognition(for tesseract: G8Tesseract!) {
        
        updateProgress(with: Float(tesseract.progress))
        //  print("Recognition progress \(tesseract.progress) %...")
        
    }
    
    func updateProgress(with value: Float) {
        
        print("\n")
        print("value: \(value)")

//        progressView.setProgress(value, animated: false)
//        progressView.setNeedsLayout()
//        progressView.setNeedsDisplay()
//        progressView.setNeedsFocusUpdate()
        
    }

    @IBAction func takePhotoButtonTapped(_ sender: Any) {
        handleCameraImage()
    }
    
    @IBAction func importButtonTapped(_ sender: Any) {
        handleLibraryImage()
    }
    
    @IBAction func scanButtonTapped(_ sender: Any) {
        //addActivityIndicator()
        processScanning()
        
        /*
        if emptyArray.isEmpty == false {
            performSegue(withIdentifier: "toNavForScannedItems", sender: self)
            imageView.image = nil
        }
 */
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
    
    func enableSaveButton(){
        
        if imageView.image != nil {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
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
    
    func styleSubViews(){
        viewUnderImgV.layer.borderWidth = 1
        viewUnderImgV.layer.masksToBounds = true
        viewUnderImgV.layer.borderColor = Colors.tealish.cgColor
        cameraButton.layer.cornerRadius = 8
        libraryButton.layer.cornerRadius = 8
        saveButton.layer.cornerRadius = 8
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == Identifiers.Segue.toScannedItems {
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
        if segue.identifier == Identifiers.Segue.toScannedItems {
            let dest = segue.destination as! ScannedItemsVC
            if !emptyArray.isEmpty {
                dest.resultsArray = emptyArray
            }
        }
    }
}
