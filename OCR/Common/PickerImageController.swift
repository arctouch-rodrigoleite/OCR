//
//  PickerImageController.swift
//  Kobeios
//
//  Created by Rodrigo Leite on 7/10/18.
//

import UIKit
import Foundation

/**
    PickerImage allows the user select an image from the camera or the album
    Called in your view controller should be as the follow
    ```
    let pickerController = PickerController()
    pickerController.imageClosure = { (image) in  }
    present(pickerController, animated: true, completion: nil)
    ```
 */
public class PickerImageController: UIViewController, UINavigationControllerDelegate {
    
    public var imageClosure: ((_ image: UIImage?) -> Void)? // Each time a image is selected by the user, it should call this closure to retrieve the photo
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        view.isOpaque = false
    }
    
    /// Display the ActionSheet to choose the photo or the album
    ///  The source is relative to display on iPad
    public func displayActionSheetPhotoPicker(source: UIView? = nil) {
        
        let alertController = UIAlertController(title: nil,
                                                message: nil,
                                                preferredStyle: .actionSheet)
        let photoAction = UIAlertAction(title: "Take Photo", style: .default) { (_) in
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
            self.present(picker, animated: true, completion: nil)
        }
        let albumAction = UIAlertAction(title: "Choose Photo", style: .default) { (_) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let picker = UIImagePickerController()
                picker.delegate = self
                picker.sourceType = .photoLibrary
                self.present(picker, animated: true, completion: nil)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            self.dismiss(animated: true, completion: nil)
        })
        alertController.addAction(photoAction)
        alertController.addAction(albumAction)
        alertController.addAction(cancelAction)
        
        if let popOverPresentation = alertController.popoverPresentationController {
            popOverPresentation.sourceView = source
        }
        
        self.present(alertController, animated: true, completion: nil)
    }

}

extension PickerImageController: UIImagePickerControllerDelegate {
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self,
                    let closure = strongSelf.imageClosure else { return }
               closure(image)
            }
        }
        picker.dismiss(animated: true) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}
