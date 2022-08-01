
import Foundation
@testable import raphTechnicalTest

struct MockCompanyBioService:CompanyInformationNetworkProtocol{
    
    var result:Result<CompanyInfoModel, APIError>
    
    func fetchCompanyInformation(completed: @escaping (Result<CompanyInfoModel, APIError>) -> Void) {
        completed(result)
    }

}
