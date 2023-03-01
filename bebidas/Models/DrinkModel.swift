// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let drinkModel = try? JSONDecoder().decode(DrinkModel.self, from: jsonData)

import Foundation

struct DrinkModel: Codable {
    let directions, ingredients, name, img: String
}
