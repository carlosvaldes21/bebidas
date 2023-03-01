//
//  ViewController.swift
//  bebidas
//
//  Created by Carlos Valdes on 28/02/23.
//

import UIKit

class ViewController: UIViewController {
        
    @IBOutlet weak var drinksTableView: UITableView!
    
    var drinks : [DrinkModel] = []
    
    var selectedDrink : DrinkModel?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drinksTableView.delegate = self
        drinksTableView.dataSource = self
        getDrinks()
    }

    
    @IBAction func unwindFromDetail(segue: UIStoryboardSegue) {
        getDrinks()
        drinksTableView.reloadData()
    }
    
    
    func getDrinks()
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailSegue" {
            let detailVC = segue.destination as! DetailViewController
            detailVC.drink = selectedDrink
        }
        
    }
    
    private func presentDetail(for drink: DrinkModel) {
        selectedDrink = drink
        performSegue(withIdentifier: "showDetailSegue", sender: self)
       
    }
    

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drinks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = drinksTableView.dequeueReusableCell(withIdentifier: "drinkCell", for: indexPath)
        cell.textLabel?.text = drinks[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.presentDetail(for: drinks[indexPath.row])
    }
}

