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
        removeAllFiles(fileExtension: "json")
        let result = getDrinks()
        
        if ( result["result"] as! String == "ok" ) {
            drinks = result["data"] as! [DrinkModel]
        }
    }

    
    @IBAction func unwindFromDetail(segue: UIStoryboardSegue) {
        
        let result = getDrinks()
        
        if ( result["result"] as! String == "ok" ) {
            drinks = result["data"] as! [DrinkModel]
        }
        
        drinksTableView.reloadData()
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

