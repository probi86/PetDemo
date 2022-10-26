import UIKit

class PetListCoordinator: Coordinator {
    
    //MARK: - IVars
    
    var parentCoordinator: Coordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    private var locationProvider: LocationProviding
    private var apiServiceProvider: PetAPIServiceProviding
    private var dataPersistingProvider: PetDataPersistingProviding
    
    init(
        locationProvider: LocationProviding,
        apiServiceProvider: PetAPIServiceProviding,
        dataPersistingProvider: PetDataPersistingProviding,
        navigationController: UINavigationController
    ) {
        self.locationProvider = locationProvider
        self.apiServiceProvider = apiServiceProvider
        self.dataPersistingProvider = dataPersistingProvider
        self.navigationController = navigationController
    }
    
    //MARK: - Coordinator
    
    func start() {
        let petListViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PetListViewController") as! PetListViewController
        
        let viewModel = PetListViewModel(
            coordinator: self,
            apiServiceProvider: apiServiceProvider,
            dataPersistingProvider: dataPersistingProvider,
            locationProvider: locationProvider
        )
        petListViewController.viewModel = viewModel
        
        self.navigationController.viewControllers = [petListViewController]
    }
    
    //MARK: - Public
    
    func showDetailFors(pet: Pet) {
        let petDetailViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PetDetailViewController") as! PetDetailViewController
        
        let viewModel = PetDetailViewModel(
            apiServiceProvider: apiServiceProvider,
            locationProvider: locationProvider,
            dataPersistingProvider: dataPersistingProvider,
            pet: pet
        )
        
        petDetailViewController.viewModel = viewModel
        
        self.navigationController.pushViewController(petDetailViewController, animated: true)
    }
    
}
