//
//  ViewController.swift
//  Project7
//
//  Created by Prachanda Muni Bajracharya on 2/12/21.
//  Copyright © 2021 Prachanda Muni Bajracharya. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var petitions = [Petition]()
    var filteredPetitions = [Petition]()
    weak var actionToEnable : UIAlertAction?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchTapped))
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelSearch))
        navigationItem.leftBarButtonItems = [searchButton, cancelButton]
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector(creditsTapped))
        
        // This code isn't perfect, in fact far from it. In fact, by downloading data from the internet in viewDidLoad() our app will lock up until all the data has been transferred.
        let urlString: String
        
        if navigationController?.tabBarItem.tag == 0 {
            // let urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            // urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                
                // PrettyPrint json data
//                 do {
//                    if let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
//                           print(jsonResult)
//                       }
//                   } catch let error {
//                       print(error.localizedDescription)
//                   }
                parse(json: data)
                return
            }
        }
        
        showError()
    }
    
    func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    // It creates an instance of JSONDecoder, which is dedicated to converting between JSON and Codable objects.
    // It then calls the decode() method on that decoder, asking it to convert our json data into a Petitions object. This is a throwing call, so we use try? to check whether it worked.
    // If the JSON was converted successfully, assign the results array to our petitions property then reload the table view.
    // The one part you haven’t seen before is Petitions.self, which is Swift’s way of referring to the Petitions type itself rather than an instance of it. That is, we’re not saying “create a new one”, but instead specifying it as a parameter to the decoding so JSONDecoder knows what to convert the JSON too.
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            filteredPetitions = petitions
            tableView.reloadData()
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPetitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = filteredPetitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = filteredPetitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc func creditsTapped() {
        let ac = UIAlertController(title: "We The People API of the Whitehouse", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    @objc func searchTapped() {
        let ac = UIAlertController(title: "Search Petition", message: nil, preferredStyle: .alert)
        ac.addTextField{
            (textField: UITextField) in
            textField.placeholder = "Search..."
            textField.addTarget(self, action: #selector(self.textChanged), for: .editingChanged)
        }
        let submitAction = UIAlertAction(title: "Search", style: .default) {
            [weak self,weak ac] _ in
            let searchText = ac?.textFields?[0].text
            self?.submit(searchText)
        }
       
        ac.addAction(submitAction)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        //  For holding the addActionButton itself as a weak variable
        self.actionToEnable = submitAction
        submitAction.isEnabled = false
        
        present(ac, animated: true)
    }
    
    @objc func textChanged(_ sender: UITextField) {
        self.actionToEnable?.isEnabled = !(sender.text!.isEmpty)
    }
    
    func submit(_ searchText: String?) {
        guard let searchText = searchText else {
            return
        }
        
        title = searchText
        
        // Using filter(isIncluded:)
        filteredPetitions = petitions.filter{
            $0.title.range(of: searchText, options: .caseInsensitive) != nil || $0.body.range(of: searchText, options: .caseInsensitive) != nil
        }
        
        // Using contains()
//        let lowerSearchText = searchText.lowercased()
//        filteredPetitions.removeAll(keepingCapacity: true)
//        for petition in petitions {
//            if petition.title.lowercased().contains(lowerSearchText) {
//                filteredPetitions.append(petition)
//            } else if petition.body.lowercased().contains(lowerSearchText) {
//                filteredPetitions.append(petition)
//            }
//        }
        tableView.reloadData()
    }
    
    @objc func cancelSearch() {
        filteredPetitions = petitions
        title?.removeAll()
        tableView.reloadData()
    }
    
}

