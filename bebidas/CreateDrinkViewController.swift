//
//  CreateDrinkViewController.swift
//  bebidas
//
//  Created by Carlos Valdes on 28/02/23.
//

import UIKit
import AVFoundation

class CreateDrinkViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var directionsTextField: UITextField!
    @IBOutlet weak var ingredientsTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    
    var imgPickCon : UIImagePickerController?
    
    var drinks : [DrinkModel] = []
    
    var imgName = ""
    
    @IBOutlet weak var imageDrink: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        //Looks for single or multiple taps.
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))

            //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
            //tap.cancelsTouchesInView = false

            view.addGestureRecognizer(tap)
        getDrinks()

    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        print("entrando")
        var perform = false
        if validateFields() {
            print("paso")
            let newDrink = DrinkModel(directions: directionsTextField.text!, ingredients: ingredientsTextField.text!, name: nameTextField.text!, img: imgName)
            
            var newArray = drinks
            newArray.append(newDrink)

            writeJSON(items: newArray)
            perform = true
        } else {
            print("text vacio")
        }
        return perform
    }
    
    private func validateFields() -> Bool
    {
        if( directionsTextField.text == ""
        || ingredientsTextField.text == ""
            || nameTextField.text == "" ||
            imgName == "") {
            errorLabel.text = "Debes llenar todos los campos"
            return false
        }
        
        return true
        
    }
    

    
    private func getDrinks()
    {
        if let libraryURL = FileManager.default.urls(for:.documentDirectory, in: .userDomainMask).first {
            let path = libraryURL.appendingPathComponent("drinks.json")
            if ( FileManager.default.fileExists(atPath: path.path) ) {
                let path = path.path
            } else {
                guard let path = Bundle.main.url(forResource: "drinks", withExtension: "json") else {
                    return
                }
            }
            do {
                let data = try Data(contentsOf: path)
                drinks = try JSONDecoder().decode([DrinkModel].self, from: data)
            } catch {
                print(error)
            }
        } else {
            return
        }

    }
    
    
    func writeJSON(items: [DrinkModel]) {
        do {
            let fileURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                    .appendingPathComponent("drinks.json")

            let encoder = JSONEncoder()
            try encoder.encode(items).write(to: fileURL)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @IBAction func cameraButton(_ sender: UIButton) {
        imgPickCon = UIImagePickerController()
        imgPickCon?.delegate = self
        // si se permite la edición (recorte) de las imagenes
        imgPickCon?.allowsEditing = true
        //
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            switch AVCaptureDevice.authorizationStatus(for:.video) {
            case .authorized:self.launchIMGPC(.camera)
            case .notDetermined:AVCaptureDevice.requestAccess (for: .video) { permiso in
                                    if permiso {
                                        self.launchIMGPC(.camera)
                                    }
                                    else {
                                        self.launchIMGPC(.photoLibrary)
                                    }
                                }
            default:
                permisos()
                return
            }
        }
        else {
            self.launchIMGPC(.photoLibrary)
        }
    }
    
    func permisos () {
        let ac = UIAlertController(title: "", message:"Se requiere permiso para usar la cámara. Puede configurarlo desde settings ahora", preferredStyle: .alert)
        let action = UIAlertAction(title: "SI", style: .default) {
            alertaction in
            if let laURL = URL(string:UIApplication.openSettingsURLString) {
                UIApplication.shared.open(laURL)
            }
        }
        let action2 = UIAlertAction(title: "NO", style: .destructive)
        ac.addAction(action)
        ac.addAction(action2)
        self.present(ac, animated: true)
    }
    
    func launchIMGPC (_ type:UIImagePickerController.SourceType) {
        DispatchQueue.main.async {
            self.imgPickCon?.sourceType = type
            self.present(self.imgPickCon!, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // si NO se permite la edición (recorte) de las imagenes se usaria la llave .originalImage
        if let img = info[.editedImage] as? UIImage {
            imageDrink.image = img
            if picker.sourceType == .camera {
                //Si mi app quiere o necesita guardar las imágenes en la librería
                //UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil)
                do {
                    if let libraryURL = FileManager.default.urls(for:.documentDirectory, in: .userDomainMask).first {
                        self.imgName = "\(drinks.count + 1).jpg"
                        try img.jpegData(compressionQuality: 1)!.write(to:libraryURL.appendingPathComponent(self.imgName))
                    }
                } catch {
                    print("no se pudo guardar")
                }
            }
        }
        picker.dismiss(animated: true)
    }
    
    

}
