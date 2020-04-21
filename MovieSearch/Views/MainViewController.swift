//
//  ViewController.swift
//  MovieSearch
//
//  Created by Adam Rowe on 4/17/20.
//  Copyright © 2020 Adam Rowe. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    let queryService = QueryService()

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

    lazy var footerView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8

        let footerImageView = UIImageView(image: UIImage(named: "tmdb"))
        footerImageView.contentMode = .scaleAspectFit
        footerImageView.translatesAutoresizingMaskIntoConstraints = false

        footerImageView.heightAnchor.constraint(equalToConstant: 36.0).isActive = true
        footerImageView.widthAnchor.constraint(equalToConstant: 36.0).isActive = true

        stackView.addArrangedSubview(footerImageView)

        footerImageView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 8).isActive = true

        let label = UILabel()
        label.numberOfLines = 0
        label.text = "This product uses the TMDb API but is not endorsed or certified by TMDb."
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.systemFont(ofSize: 10, weight: UIFont.Weight.thin)
        label.textAlignment = .justified

        stackView.addArrangedSubview(label)

        stackView.widthAnchor.constraint(equalToConstant: moviesTableView.bounds.width - 16).isActive = true

        label.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true

        return stackView
    }()

    lazy var spinnerView: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.backgroundColor = .systemBackground

        view.addSubview(spinner)

        spinner.centerXAnchor.constraint(equalTo: movieSearchImage.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: movieSearchImage.centerYAnchor).isActive = true

        return spinner
    }()

    @IBOutlet var moviesTableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var movieSearchImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                 action: #selector(dismissKeyboard) )
        view.addGestureRecognizer(tap)

        searchBar.delegate = self
        moviesTableView.dataSource = self
        moviesTableView.delegate = self
    }

    private func convertResponseToMovies(_ data: Data) -> [Movie] {
        if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
            return decodedResponse.results.filter{ $0.posterPath != nil }
        } else { return [] }
    }

    private func showSearchResults(_ isHidden: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.movieSearchImage.isHiddenWithAnimation(isHidden)
            self.moviesTableView.isHiddenWithAnimation(!isHidden)
        }
    }

    @objc func dismissKeyboard(_ sender: AnyObject) {
        if let tapAction = sender as? UITapGestureRecognizer {
            if tapAction.view != searchBar {
                view.endEditing(true)
            }
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

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60.0
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return footerView
    }
}

extension MainViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()

        guard let searchText = searchBar.text, !searchText.isEmpty else {
            return
        }

        spinnerView.startAnimating()
        movieSearchImage.isHidden = true

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
