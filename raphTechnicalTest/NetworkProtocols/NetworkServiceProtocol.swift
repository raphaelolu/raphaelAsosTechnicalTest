
import Foundation

protocol CompanyInformationNetworkProtocol{
    func fetchCompanyInformation(completed:@escaping(Result<CompanyInfoModel,APIError>)-> Void)
}

protocol LaunchInformationNetworkProtocol{
    func fetchLaunchInformation(completed:@escaping(Result<[LaunchDataModel],APIError>)-> Void)
}

protocol RocketInformationProtocol{
    func fetchRocketInformation(completed: @escaping(Result<[RocketModel], APIError>) -> Void)
}



