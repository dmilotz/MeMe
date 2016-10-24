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
    @IBOutlet weak var shareButton: UIBarButtonItem!
    var bottomTextCleared = false
    var topTextCleared = false
    var memeImage : UIImage!
    
    @IBAction func cancelMeme(_ sender: AnyObject) {
       defaultState()
    }
    
    
    func defaultState(){
        shareButton.isEnabled = false
        bottomText.text = "Bottom"
        bottomText.defaultTextAttributes = memeTextAttributes
        bottomText.delegate = self
        bottomText.textAlignment = NSTextAlignment.center
        
        topText.text = "Top"
        topText.defaultTextAttributes = memeTextAttributes
        topText.delegate = self
        topText.textAlignment = .center
        
        
        
        imagePicker.image = nil
    }
    
    
    @IBAction func share(_ sender: AnyObject) {
        memeImage = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [memeImage], applicationActivities: nil)
        
        self.present(controller, animated: true, completion: nil)
        
        controller.completionWithItemsHandler = {(activityType, completed, returnedItems, error) in
            
            // Return if cancelled
            if (!completed) {
                return
            }
            self.save()
            controller.dismiss(animated: true, completion: nil)
            
            
        }
    }
  

    
    struct Meme {
        let botText: String
        let topText : String
        let originalImage: UIImage
        let memeImage: UIImage
        
   }
    
    func save(){
       let meme = Meme(botText: bottomText.text!, topText: topText.text!, originalImage:imagePicker.image!, memeImage: memeImage )
    }
    
    
    func generateMemedImage() -> UIImage
    {
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.isToolbarHidden = true
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame,
                                     afterScreenUpdates: true)
        let memedImage : UIImage =
            UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.isToolbarHidden = false
        
        return memedImage
    }
    
    
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor .black,
        NSForegroundColorAttributeName : UIColor .white,
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -1.0
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
        
        if textField.tag == 2 {
            self.subscribeToKeyboardNotifications()
        }
        else if textField.tag == 1{
            self.unsubscribeFromKeyboardNotifications()
        }
       
        
    }
    

    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return false
    }
    
    func subscribeToKeyboardNotifications() {
       NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
       NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
        
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardDidHide, object: nil)
    }
    
    
    func keyboardWillShow(notification: Notification) {
        self.view.frame.origin.y = 0
            
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
        
        self.defaultState()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
        
        
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
       
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage{
            imagePicker.image = self.fixOrientation(img: img)
            
            picker.dismiss(animated: true, completion: nil)
        }
         shareButton.isEnabled = true
        
        
    
        
    }
    
    func fixOrientation(img:UIImage) -> UIImage {
        
        if (img.imageOrientation == UIImageOrientation.up) {
            return img;
        }
        
        UIGraphicsBeginImageContextWithOptions(img.size, false, img.scale);
        let rect = CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height)
        img.draw(in: rect)
        
        let normalizedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext();
        return normalizedImage;
        
    }
    
    

}

