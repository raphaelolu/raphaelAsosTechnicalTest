
import Foundation

struct CompanyInfoModel: Codable{
    let headquarters: Headquarters
    let links: Links
    let name, founder: String
    let founded, employees, vehicles, launch_sites: Int
    let test_sites: Int
    let ceo, cto, coo, cto_propulsion: String
    let valuation: Int
    let summary, id: String
}


struct Headquarters:Codable {
    let address, city, state: String
}


struct Links:Codable {
    let website, flickr, twitter, elon_twitter: String
}


