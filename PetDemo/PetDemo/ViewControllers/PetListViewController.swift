//
//  AnimalListViewController.swift
//  PetDemo
//
//  Created by Peter Robert on 24.10.2022.
//

import UIKit
import Combine

class PetListViewController: UIViewController {
    
    //MARK: - IVars
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var loadingPetsLabel: UILabel!
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var retryButton: UIButton!
    
    let refreshControl = UIRefreshControl()
    
    var viewModel: PetListViewModel?
    var cancellables = [AnyCancellable]()
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Pets"
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(tableViewRefreshed), for: UIControl.Event.valueChanged)
        
        tableView.register(UINib(nibName: "PetTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "PetTableViewCell")
        
        setupBindings()
        
        viewModel?.reloadPets()
    }
    
    //MARK: - Actions
    
    @objc func tableViewRefreshed() {
        viewModel?.reloadPets()
    }
    
    @IBAction func retryTapped(_ sender: Any) {
        viewModel?.reloadPets()
    }
    
    //MARK: - Private
    
    private func setupBindings() {    
        
        viewModel?.$pets
            .receive(on: OperationQueue.main)
            .sink(receiveValue: { [weak self] pets in
                self?.tableView.reloadData()
            })
            .store(in: &cancellables)
        
        viewModel?.$morePagesAvailable
            .sink(receiveValue: { [weak self] available in
                if available {
                    let activityIndicatorView = UIActivityIndicatorView()
                    activityIndicatorView.frame.size.height = 50.0
                    activityIndicatorView.startAnimating()
                    self?.tableView.tableFooterView = activityIndicatorView
                } else {
                    self?.tableView.tableFooterView = nil
                }
            })
            .store(in: &cancellables)

        viewModel?.$isReloading
            .sink(receiveValue: { [weak self] reloading in

                guard let petCount = self?.viewModel?.pets.count else {
                    return
                }
                
                let isTableViewEmpty = petCount == 0
                
                if reloading {
                    self?.errorLabel.isHidden = true
                    self?.retryButton.isHidden = true
                    
                    if isTableViewEmpty && self?.refreshControl.isRefreshing == false {
                        self?.activityIndicatorView.startAnimating()
                        self?.loadingPetsLabel.isHidden = false
                    }
                    
                } else {
                    self?.refreshControl.endRefreshing()
                    self?.activityIndicatorView.stopAnimating()
                    self?.loadingPetsLabel.isHidden = true
                    
                    if let error = self?.viewModel?.loadingError, isTableViewEmpty {
                        self?.errorLabel.isHidden = false
                        self?.errorLabel.text = error.localizedDescription
                        self?.retryButton.isHidden = false
                    }
                }
            })
            .store(in: &cancellables)
    }

}

extension PetListViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentSize.height > scrollView.frame.size.height && scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.frame.size.height {
            viewModel?.loadNextPage()
        }
    }
}

extension PetListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.pets.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PetTableViewCell") as! PetTableViewCell
        cell.pet = viewModel?.pets[indexPath.row]
        return cell
    }
    
    
}
