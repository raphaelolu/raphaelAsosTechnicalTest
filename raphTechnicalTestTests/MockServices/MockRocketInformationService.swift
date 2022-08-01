
import Foundation
@testable import raphTechnicalTest

struct MockRocketInformationService:RocketInformationProtocol{
    
    var result:Result<[RocketModel], APIError>
    
    func fetchRocketInformation(completed: @escaping (Result<[RocketModel], APIError>) -> Void) {
        completed(result)
    }
}
