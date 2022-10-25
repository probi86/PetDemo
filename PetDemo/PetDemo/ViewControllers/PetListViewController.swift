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

        viewModel?.$isReloading
            .sink(receiveValue: { [weak self] reloading in

                guard let petCount = self?.viewModel?.pets.count else {
                    return
                }

                if !reloading {
                    self?.refreshControl.endRefreshing()
                }

                let hideTableView = reloading && petCount == 0
                self?.tableView.isHidden = hideTableView
                if hideTableView {
                    self?.activityIndicatorView.startAnimating()
                } else {
                    self?.activityIndicatorView.stopAnimating()
                }
                self?.loadingPetsLabel.isHidden = !hideTableView
            })
            .store(in: &cancellables)
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
