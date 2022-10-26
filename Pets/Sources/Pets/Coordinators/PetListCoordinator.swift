import UIKit
import Core
import Kingfisher

public class PetListCoordinator: Coordinator {
    
    //MARK: - IVars
    
    public var parentCoordinator: Coordinator?
    public var childCoordinators = [Coordinator]()
    public var navigationController: UINavigationController
    
    private var locationProvider: LocationProviding
    private var apiServiceProvider: PetAPIServiceProviding
    private var dataPersistingProvider: PetDataPersistingProviding
    
    public init(
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
    
    public func start() {
        KingfisherManager.shared.cache.clearCache() //TODO: Remove this
        
        let petListViewController = UIStoryboard(name: "Main", bundle: Bundle.module).instantiateViewController(withIdentifier: "PetListViewController") as! PetListViewController
        
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
    
    public func showDetailFors(pet: Pet) {
        let petDetailViewController = UIStoryboard(name: "Main", bundle: Bundle.module).instantiateViewController(withIdentifier: "PetDetailViewController") as! PetDetailViewController
        
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
