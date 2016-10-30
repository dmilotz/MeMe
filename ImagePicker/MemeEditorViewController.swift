//
//  MemeEditorViewController.swift
//  ImagePicker
//
//  Created by Dirk Milotz on 10/20/16.
//  Copyright © 2016 Dirk Milotz. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet var imagePicker: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    var bottomTextCleared = false
    var topTextCleared = false
    var memeImage : UIImage!
    
    @IBAction func cancelMeme(_ sender: AnyObject) {
       //defaultState()
        popController()
    }
    
    
    func popController(){
        
        self.navigationController?.popViewController(animated: true)
    }
    func defaultState(){
        shareButton.isEnabled = false
        prepareTextField(textField: bottomText,defaultText:"Bottom")
        prepareTextField(textField: topText, defaultText: "Top")
        imagePicker.image = nil
    }
    
    func prepareTextField(textField: UITextField, defaultText: String) {
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor .black,
            NSForegroundColorAttributeName : UIColor .white,
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : -1.0
            ] as [String : Any]
        
        textField.delegate = self
        textField.defaultTextAttributes = memeTextAttributes
        textField.text = defaultText
        textField.autocapitalizationType = .allCharacters
        textField.textAlignment = .center
        
    }
    
    
    @IBAction func share(_ sender: AnyObject) {
        
        memeImage = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [memeImage], applicationActivities: nil)
        
        present(controller, animated: true, completion: nil)
        
        controller.completionWithItemsHandler = {(activityType, completed, returnedItems, error) in
            
            // Return if cancelled
            if (!completed) {
                return
            }
            
            //controller.dismiss(animated: true, completion: {
            self.save()
        }

    }
  

    

    
    func save(){
       let meme = Meme(botText: bottomText.text!, topText: topText.text!, originalImage:imagePicker.image!, memeImage: memeImage )
        (UIApplication.shared.delegate as! AppDelegate).memes.append(meme)

        popController()

    }
    
    
    func generateMemedImage() -> UIImage
    {
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.isToolbarHidden = true
        // Render view to an image
        UIGraphicsBeginImageContext(view.frame.size)
        let finished = view.drawHierarchy(in: view.frame,
                                     afterScreenUpdates: true)
        let memedImage : UIImage =
            UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        if finished{
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.setToolbarHidden(true, animated: false)

        }
        
        return memedImage
    }
    
    
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor .black,
        NSForegroundColorAttributeName : UIColor .white,
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -3.3
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
            textField.resignFirstResponder()
            return false
    }
    
    func subscribeToKeyboardNotifications() {
       NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
       NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    func keyboardWillShow(notification: Notification) {
        if bottomText.isEditing  == true{
            view.frame.origin.y -= getKeyboardHeight(notification: notification) - 15.0
        }
    }
    
    func keyboardWillHide(notification: Notification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo!
        let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    // Unsubscribe
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()

    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        //self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        defaultState()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
        subscribeToKeyboardNotifications()
        self.tabBarController?.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }


    func pick(sourceType:UIImagePickerControllerSourceType){
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType = sourceType
        present(controller, animated: true, completion: nil)
        imagePickerController(controller, didFinishPickingMediaWithInfo: ["Blah":"Blah"])
    }
    
    @IBAction func pickImageFromAlbum(_ sender: AnyObject) {
        pick(sourceType: UIImagePickerControllerSourceType.photoLibrary)
        
    }
    

    
    
    @IBAction func pickImageFromCamera(_ sender: AnyObject) {
        pick(sourceType: UIImagePickerControllerSourceType.camera)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
       
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage{
            imagePicker.image = fixOrientation(img: img)
            
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

