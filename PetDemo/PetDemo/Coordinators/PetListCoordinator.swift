import UIKit

class PetListCoordinator: Coordinator {
    
    //MARK: - IVars
    
    var parentCoordinator: Coordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    private var locationProvider: LocationProviding
    private var apiServiceProvider: PetAPIServiceProviding
    
    init(
        locationProvider: LocationProviding,
        apiServiceProvider: PetAPIServiceProviding,
        navigationController: UINavigationController
    ) {
        self.locationProvider = locationProvider
        self.apiServiceProvider = apiServiceProvider
        self.navigationController = navigationController
    }
    
    //MARK: - Coordinator
    
    func start() {
        let petListViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PetListViewController") as! PetListViewController
        
        let viewModel = PetListViewModel(
            coordinator: self,
            apiServiceProvider: apiServiceProvider,
            locationProvider: locationProvider
        )
        petListViewController.viewModel = viewModel
        
        self.navigationController.viewControllers = [petListViewController]
    }
    
    //MARK: - Public
    
    func showDetailFor(pet: Pet) {
        let petDetailViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PetDetailViewController") as! PetDetailViewController
        
        let viewModel = PetDetailViewModel(
            apiServiceProvider: apiServiceProvider,
            locationProvider: locationProvider,
            pet: pet
        )
        
        petDetailViewController.viewModel = viewModel
        
        self.navigationController.pushViewController(petDetailViewController, animated: true)
    }
    
    
    
}
