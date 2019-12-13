//
//  NotesViewController.swift
//  TestApp
//
//

import UIKit

class NotesViewController: UITableViewController {
    
    // MARK: - Variables
    var notes = [Note]()
    var filteredNotes = [Note]()
    var store: NoteStore!
    
    fileprivate let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone(abbreviation: "EDT")
        return formatter
    }()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
        return searchController.isActive && (!isSearchBarEmpty)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Note"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        let noteStoredArray = Pref.note
        
        store.getNotes { (noteResult) in
            
            switch noteResult {
            case let .success(notes):
                self.notes = notes
                if let count = noteStoredArray?.count, count > 0 {
                    for note in noteStoredArray! {
                        self.notes.append(note)
                    }
                }
                self.tableView.reloadData()
                
            case .failure:
                print("Error in loading data.")
            }
        }
    }
    
    fileprivate func filterContentForSearchText(_ searchText: String) {
        filteredNotes = notes.filter { (note: Note) -> Bool in
            note.noteDescription.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension NotesViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredNotes.count
        }
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "UITableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        let note: Note!
        if isFiltering {
            note = filteredNotes[indexPath.row]
        } else {
            note = self.notes[indexPath.row]
        }
        
        cell.textLabel?.text = note.noteDescription
        cell.detailTextLabel?.text = dateFormatter.string(from: note.dateCreated)
        
        return cell
    }
}


extension NotesViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterContentForSearchText(searchBar.text!)
    }
}

extension NotesViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
}
