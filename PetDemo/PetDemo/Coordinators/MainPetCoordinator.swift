import UIKit

class MainPetCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    
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
    
    func start() {
        let animalListViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PetListViewController") as! PetListViewController
        
        let viewModel = PetListViewModel(
            apiServiceProvider: apiServiceProvider,
            locationProvider: locationProvider
        )
        animalListViewController.viewModel = viewModel
        
        self.navigationController.viewControllers = [animalListViewController]
    }
    
    
}
