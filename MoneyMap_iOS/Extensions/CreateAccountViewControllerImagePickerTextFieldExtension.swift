//
//  CreateAccountViewControllerImagePickerTextFieldExtension.swift
//  MoneyMap-iOS
//
//  Created by Venugopal Reddy M on 13/02/24.
//

import UIKit

extension CreateAccountViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileImageView.image = selectedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard when return key is pressed
        textField.resignFirstResponder()
        return true
    }
}



