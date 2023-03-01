//
//  Helpers.swift
//  bebidas
//
//  Created by Carlos Valdes on 01/03/23.
//

import Foundation
import UIKit


let RESULT: [String:Any] = [
    "result" : "ok",
    "data" : [],
    "error" : ""
];

/**
 * Function to get drinks
 * @return [String:Any]
 */
func getDrinks() -> [String:Any]
{
    var result = RESULT
    var drinks: [DrinkModel] = []
    if let libraryURL = FileManager.default.urls(for:.documentDirectory, in: .userDomainMask).first {
        var path = libraryURL.appendingPathComponent("drinks.json")
        

        if ( !FileManager.default.fileExists(atPath: path.path) ) {
            path = Bundle.main.url(forResource: "drinks", withExtension: "json")!
        }
        
        do {
            let data = try Data(contentsOf: path)
            drinks = try JSONDecoder().decode([DrinkModel].self, from: data)
            result["data"] = drinks
        } catch {
            result["result"] = "error"
            result["error"] = error
        }
    } else {
        result["result"] = "error"
        result["error"] = "No se encuentra document directory"
    }
    
    return result
}


/**
 *Function to wirte JSON in .documentDirectory with name drinks.json
 *@param items: [DrinkModel]
 */
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

func hasInternet() -> Bool
{
    let ad = UIApplication.shared.delegate as! AppDelegate
    if ad.internetStatus {
        return true
    } else {
        return false
    }
}

func removeAllFiles(fileExtension:String)
{
    let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

    do {
        let fileURLs = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
        for fileURL in fileURLs where fileURL.pathExtension == fileExtension {
            try FileManager.default.removeItem(at: fileURL)
        }
    } catch  { print(error) }
}





