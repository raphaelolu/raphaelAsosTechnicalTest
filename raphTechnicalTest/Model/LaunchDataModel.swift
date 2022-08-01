
import Foundation

struct LaunchDataModel:Codable,Identifiable{
   
    
    let fairings: Fairings?
    let links: LaunchLinks
    let staticFireDateUTC: String?
    let staticFireDateUnix: Int?
    let net: Bool
    let window: Int?
    let rocket: String
    let success: Bool?
    let failures: [Failure]
    let details: String?
    let crew: [Crew]
    let ships, capsules, payloads: [String]
    let launchpad: String?
    let flight_number: Int
    let name, date_utc: String
    let date_unix: Int
    let date_local: String
    let date_precision: String
    let upcoming: Bool
    let cores: [Core]
    let auto_update, tbd: Bool
    let launch_library_id: String?
    let id: String
}

struct Core:Codable {
    let core: String?
    let flight: Int?
    let gridfins, legs, reused, landingAttempt: Bool?
    let landingSuccess: Bool?
    let landingType: LandingType?
    let landpad: String?
}

enum LandingType: Codable {
    case asds
    case ocean
    case rtls
}

struct Crew:Codable {
    let crew, role: String
}

enum DatePrecision:Codable {
    case day
    case hour
    case month
    case quarter
}

struct Failure:Codable {
    let time: Int
    let altitude: Int?
    let reason: String
}

struct Fairings:Codable {
    let reused, recoveryAttempt, recovered: Bool?
    let ships: [String]
}

enum Launchpad :Codable {
    case the5E9E4501F509094Ba4566F84
    case the5E9E4502F509092B78566F87
    case the5E9E4502F509094188566F88
    case the5E9E4502F5090995De566F86
}

struct LaunchLinks :Codable {
    let patch: Patch
    let reddit: Reddit
    let flickr: Flickr
    let presskit: String?
    let webcast: String?
    let youtubeID: String?
    let article: String?
    let wikipedia: String?
}

struct Flickr :Codable {
    let small: [String]?
    let original: [String]
}

struct Patch :Codable {
    let small, large: String?
}

struct Reddit :Codable{
    let campaign: String?
    let launch: String?
    let media, recovery: String?
}

enum Rocket :Codable {
    case the5E9D0D95Eda69955F709D1Eb
    case the5E9D0D95Eda69973A809D1Ec
    case the5E9D0D95Eda69974Db09D1Ed
}




