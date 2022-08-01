
import Foundation
@testable import raphTechnicalTest

struct MockLaunchInformationService:LaunchInformationNetworkProtocol
{
    var result:Result<[LaunchDataModel], APIError>
    
    func fetchLaunchInformation(completed: @escaping (Result<[LaunchDataModel], APIError>) -> Void) {
        completed(result)
    }
}
