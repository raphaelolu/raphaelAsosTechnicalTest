
import Foundation

class NetworkService:CompanyInformationNetworkProtocol,LaunchInformationNetworkProtocol,RocketInformationProtocol

{
    func fetchCompanyInformation(completed: @escaping (Result<CompanyInfoModel, APIError>) -> Void) {
        
        guard let url = URL(string: "https://api.spacexdata.com/v4/company") else{
            let error = APIError.badUrl
            completed(.failure(error))
            return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error as? URLError {
                completed(.failure(APIError.URL(error)))
                return
            } else if let response = response as? HTTPURLResponse,!(200...299).contains(response.statusCode){
                completed(.failure(.badResponse(statusCode: response.statusCode)))
            } else if let data = data {
                
                do {
                    let data  = try JSONDecoder().decode(CompanyInfoModel.self, from: data)
                    completed(.success(data))
                }
                catch {
                    completed(.failure(.parsing((error as? DecodingError))))
                }
                
            }
            
        }
        task.resume()
    }
    
    func fetchLaunchInformation(completed: @escaping (Result<[LaunchDataModel], APIError>) -> Void) {
        
        guard let url = URL(string:  "https://api.spacexdata.com/v5/launches") else{
            let error = APIError.badUrl
            completed(.failure(error))
            return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error as? URLError {
                completed(.failure(APIError.URL(error)))
                return
            } else if let response = response as? HTTPURLResponse,!(200...299).contains(response.statusCode){
                completed(.failure(.badResponse(statusCode: response.statusCode)))
            } else if let data = data {
                
                do {
                    let data  = try JSONDecoder().decode([LaunchDataModel].self, from: data)
                    completed(.success(data))
                }
                catch {
                    completed(.failure(.parsing((error as? DecodingError))))
                }
                
            }
            
        }
        task.resume()
        
    }
    
    func fetchRocketInformation(completed: @escaping (Result<[RocketModel], APIError>) -> Void) {
        
        guard let url = URL(string:  "https://api.spacexdata.com/v4/rockets"  ) else{
            let error = APIError.badUrl
            completed(.failure(error))
            return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error as? URLError {
                completed(.failure(APIError.URL(error)))
                return
            } else if let response = response as? HTTPURLResponse,!(200...299).contains(response.statusCode){
                completed(.failure(.badResponse(statusCode: response.statusCode)))
            } else if let data = data {
                
                do {
                    let data  = try JSONDecoder().decode([RocketModel].self, from: data)
                    completed(.success(data))
                }
                catch {
                    completed(.failure(.parsing((error as? DecodingError))))
                }
                
            }
            
        }
        task.resume()
    }
}
