//
//  ViewController.swift
//  Project7
//
//  Created by Prachanda Muni Bajracharya on 2/12/21.
//  Copyright © 2021 Prachanda Muni Bajracharya. All rights reserved.
//

import UIKit

#warning("Use DispatchQues method instead of performselector() because xcode gives warning about tableview and navigation controller can only be use in main thread. Or you can use both methods where necessary")
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
        
//        let urlString: String
//
//        if navigationController?.tabBarItem.tag == 0 {
//            // let urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
//            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
//        } else {
//            // urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
//            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
//        }
//
//        // There are four background queues that you can use, each of which has their own QoS level set:
//        // User Interactive: this is the highest priority background thread, and should be used when you want a background thread to do work that is important to keep your user interface working. This priority will ask the system to dedicate nearly all available CPU time to you to get the job done as quickly as possible.
//        // User Initiated: this should be used to execute tasks requested by the user that they are now waiting for in order to continue using your app. It's not as important as user interactive work – i.e., if the user taps on buttons to do other stuff, that should be executed first – but it is important because you're keeping the user waiting.
//        // The Utility queue: this should be used for long-running tasks that the user is aware of, but not necessarily desperate for now. If the user has requested something and can happily leave it running while they do something else with your app, you should use Utility.
//        // The Background queue: this is for long-running tasks that the user isn't actively aware of, or at least doesn't care about its progress or when it completes.
//        // There’s also one more option, which is the default queue. This is prioritized between user-initiated and utility, and is a good general-purpose choice while you’re learning.
//
//        DispatchQueue.global(qos: .userInitiated).async {
//            [weak self] in
//            if let url = URL(string: urlString) {
//                if let data = try? Data(contentsOf: url) {
//                    self?.parse(json: data)
//                    return
//                }
//            }
//
//            self?.showError()
//        }
        
        
        // There’s another way of using GCD, and it’s worth covering because it’s a great deal easier in some specific circumstances. It’s called performSelector(), and it has two interesting variants: performSelector(inBackground:) and performSelector(onMainThread:).
        performSelector(inBackground: #selector(fetchJSON), with: nil)
    }
    
    @objc func fetchJSON() {
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
                parse(json: data)
                return
            }
        }
        
        performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
        
    }
    
//    func showError() {
//        // it's never OK to do user interface work on the background thread.
//        // So calling async() again to execute the code in the main thread.
//        DispatchQueue.main.async { [weak self] in
//            let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
//            ac.addAction(UIAlertAction(title: "OK", style: .default))
//            self?.present(ac, animated: true)
//        }
//    }
    
    @objc func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }

    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            filteredPetitions = petitions
            
//            // it's never OK to do user interface work on the background thread.
//            // So calling async() again to execute the code in the main thread.
//            DispatchQueue.main.async { [weak self] in
//                self?.tableView.reloadData()
//            }
            
            // Using performSelector()
            tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
        } else {
            performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
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

