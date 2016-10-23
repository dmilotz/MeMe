//
//  ViewController.swift
//  ImagePicker
//
//  Created by Dirk Milotz on 10/20/16.
//  Copyright © 2016 Dirk Milotz. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet var imagePicker: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    var bottomTextCleared = false
    var topTextCleared = false
    
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor .black,
        NSForegroundColorAttributeName : UIColor .white,
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : 10.0
    ] as [String : Any]
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 1 && !topTextCleared{
            topText.text = ""
            topTextCleared = true
        }
        else if textField.tag == 2 && !bottomTextCleared{
            bottomText.text = ""
            bottomTextCleared = true
        }
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    func subscribeToKeyboardNotifications() {
       NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
        
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    func keyboardWillShow(notification: Notification) {
        self.view.frame.origin.y -= getKeyboardHeight(notification: notification)
    }
    
    func keyboardWillHide(notification: Notification) {
        self.view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo!
        let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    // Unsubscribe
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bottomText.text = "Bottom"
        bottomText.defaultTextAttributes = memeTextAttributes
        bottomText.delegate = self
        bottomText.textAlignment = NSTextAlignment.center
            
        topText.text = "Top"
        topText.defaultTextAttributes = memeTextAttributes
        topText.delegate = self
        topText.textAlignment = .center
        
        

        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
        self.subscribeToKeyboardNotifications()
    }


    
    @IBAction func pickImageFromAlbum(_ sender: AnyObject) {
        let controller = UIImagePickerController()
        
        controller.delegate = self
        controller.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(controller, animated: true, completion: nil)
       self.imagePickerController(controller, didFinishPickingMediaWithInfo: ["Blah":"Blah"])
        
    }
    

    
    
    @IBAction func pickImageFromCamera(_ sender: AnyObject) {
        let controller = UIImagePickerController()
       
        controller.delegate = self
        controller.sourceType = UIImagePickerControllerSourceType.camera
         self.present(controller, animated: true, completion: nil)
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            imagePicker.image = image
            picker.dismiss(animated: true, completion: nil)
        }
    
        
    }
    
    

}

