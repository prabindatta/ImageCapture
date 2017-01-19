//
//  IPViewControllerCustom.swift
//  ImageCapture
//
//  Created by Prabin K Datta on 19/01/17.
//  Copyright © 2017 Prabin K Datta. All rights reserved.
//

import UIKit
import MobileCoreServices
import AVFoundation;

class IPViewControllerCustom: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    // MARK: IBOutlet Objects Declaration
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet var overlayView: UIView!
    
    // MARK: Variable Declaration
    var pickerViewController: UIImagePickerController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.didTapTakePhoto(nil)
        
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
    
    // MARK: Instance Method
    func takePictures(){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            pickerViewController = UIImagePickerController()
            pickerViewController.delegate = self
            pickerViewController?.view.frame = UIScreen.main.bounds
            pickerViewController?.sourceType = .camera //.savedPhotosAlbum //.photoLibrary //
            pickerViewController.mediaTypes = [kUTTypeImage as String]
            pickerViewController.allowsEditing = false
            pickerViewController.showsCameraControls=false
            
            pickerViewController.modalPresentationStyle = .currentContext
            pickerViewController.modalPresentationStyle = .fullScreen
            
            Bundle.main.loadNibNamed("OverlayView", owner: self, options: nil)
            self.overlayView.frame = (pickerViewController.cameraOverlayView?.frame)!
            pickerViewController.cameraOverlayView = self.overlayView
            self.overlayView=nil
            
            present(pickerViewController!, animated: true, completion: nil)
        }
    }
    
    // MARK: - UIAction
    @IBAction func didTapTakePhoto(_ sender: Any?) {
        let authStatus:AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        if authStatus == .denied {
            // Denies access to camera, alert the user.
            // The user has previously denied access. Remind the user that we need camera access to be useful.
            let alertController:UIAlertController = UIAlertController.init(title: "Unable to access the Camera", message: "To enable access, go to Settings > Privacy > Camera and turn on Camera access for this app.", preferredStyle: .alert)
            let ok:UIAlertAction = UIAlertAction.init(title: "OK", style: .default, handler: nil)
            alertController.addAction(ok)
            self.present(alertController, animated: true, completion: nil)
        }else if authStatus == .notDetermined {
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { (granted: Bool) in
                if granted {
                    // Allowed access to camera, go ahead and present the UIImagePickerController.
                    self.takePictures()
                }
            })
        }else{
            self.takePictures()
        }
    }
    
    @IBAction func didTapCancel(_ sender: Any) {
        imageView.image = nil
    }
    
    @IBAction func didTapCapture(_ sender: Any) {
        self.pickerViewController.takePicture();
    }
    
    @IBAction func didTapDone(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - UIImagePickerController Delegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.contentMode = .scaleAspectFit
            imageView.image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
}
