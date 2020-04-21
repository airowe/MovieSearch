//
//  ViewController.swift
//  MovieSearch
//
//  Created by Adam Rowe on 4/17/20.
//  Copyright © 2020 Adam Rowe. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    var searchResults: [Movie] = [] {
        didSet {
            DispatchQueue.main.async {
                self.spinnerView.stopAnimating()
                self.showSearchResults(self.searchResults.count > 0)
                self.moviesTableView.reloadData()
                self.moviesTableView.setContentOffset(.zero, animated: false)
            }
        }
    }

    lazy var spinnerView:UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.translatesAutoresizingMaskIntoConstraints = false

        spinner.backgroundColor = .systemBackground

        view.addSubview(spinner)

        spinner.centerXAnchor.constraint(equalTo: tmdbImage.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: tmdbImage.centerYAnchor).isActive = true

        return spinner
    }()

    let queryService = QueryService()

    @IBOutlet var moviesTableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tmdbImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        moviesTableView.dataSource = self
    }

    private func convertResponseToMovies(_ data: Data) -> [Movie] {
        if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
            return decodedResponse.results.filter{ $0.posterPath != nil }
        } else { return [] }
    }

    private func showSearchResults(_ isHidden: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.tmdbImage.isHiddenWithAnimation(isHidden)
            self.moviesTableView.isHiddenWithAnimation(!isHidden)
        }
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MovieCell = tableView.dequeueReusableCell(withIdentifier: MovieCell.identifier,
                                                            for: indexPath) as! MovieCell

        let movie = searchResults[indexPath.row]
        cell.configure(with: movie)

        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
}

extension MainViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()

        guard let searchText = searchBar.text, !searchText.isEmpty else {
            return
        }

        spinnerView.startAnimating()
        tmdbImage.isHidden = true

        queryService.request(.search(matching: searchText)) { result in
            switch result {
                case .failure(let error):
                    print("Search error: \(error.localizedDescription)")
                    self.searchResults.removeAll()
                case .success(let response):
                    self.searchResults = self.convertResponseToMovies(response)
            }
        }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.moviesTableView.setContentOffset(.zero,
                                                      animated: false)
                self.showSearchResults(false)
            }
        }
    }
}
