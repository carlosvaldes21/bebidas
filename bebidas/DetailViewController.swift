//
//  DetailViewController.swift
//  bebidas
//
//  Created by Carlos Valdes on 28/02/23.
//

import UIKit

class DetailViewController: UIViewController {

    
    
    @IBOutlet weak var imageDrink: UIImageView!
    @IBOutlet weak var labelIngredients: UILabel!
    @IBOutlet weak var labelDirections: UILabel!
    var drink: DrinkModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelIngredients.numberOfLines = 0
    

        labelIngredients.text = drink?.ingredients
        labelDirections.numberOfLines = 0
        labelDirections.text = drink?.directions
        loadImages()

        // Do any additional setup after loading the view.
    }
    
    func saveImage(image: Data, name: String)
    {
        do {
            if let libraryURL = FileManager.default.urls(for:.documentDirectory, in: .userDomainMask).first {
                try image.write(to:libraryURL.appendingPathComponent(name))
            }
        } catch {
            print("no se pudo guardar")
        }
    }
    
    func fileExist(name:String) -> String
    {
        
        if let libraryURL = FileManager.default.urls(for:.documentDirectory, in: .userDomainMask).first {
            let path = libraryURL.appendingPathComponent(drink!.img)
            if ( FileManager.default.fileExists(atPath: path.path) ) {
                return path.path
            } else {
                return ""
            }
        }
        
        return ""
    }
    
    private func loadImages() {
       
        let image = "http://janzelaznog.com/DDAM/iOS/drinksimages/\(drink!.img)"
        
        let filePath = self.fileExist(name: drink!.img)
        if ( filePath != "" ) {
                DispatchQueue.main.async {
                    self.imageDrink.image = UIImage(contentsOfFile: filePath)
                }
        } else {
            let catPictureURL = URL(string: image)!

            let session = URLSession(configuration: .default)

            let downloadPicTask = session.dataTask(with: catPictureURL) { (data, response, error) in
                if let e = error {
                    print("Error downloading cat picture: \(e)")
                } else {
                    // No errors found.
                    if let res = response as? HTTPURLResponse {
                        print("Downloaded cat picture with response code \(res.statusCode)")
                        if let imageData = data {
                            self.saveImage(image: imageData, name:self.drink!.img)
                            // Finally convert that Data into an image and do what you wish with it.
                            DispatchQueue.main.async {
                                self.imageDrink.image = UIImage(data: imageData)
                            }
                            // Do something with your image.
                        } else {
                            print("Couldn't get image: Image is nil")
                        }
                    } else {
                        print("Couldn't get response code for some reason")
                    }
                }
            }

            downloadPicTask.resume()
        }
        
        
    }
}
