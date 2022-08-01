
import XCTest
@testable import raphTechnicalTest

class ViewModelTests: XCTestCase {
    
    var mockLaunchNetworkService:MockLaunchInformationService!
    var mockCompanyBioService:MockCompanyBioService!
    var mockRocketInformation:MockRocketInformationService!
    var viewModel: ViewModel!
   
    override func setUpWithError() throws {
        let rcoketDataReponse = Result<[RocketModel], APIError>.success(MockRocketsResponseData.response)
        let launcheDataReponse = Result<[LaunchDataModel], APIError>.success(MockLaunchesResponseData.response)
        let companyInformationsDataResponse = Result<CompanyInfoModel, APIError>.success(MockCompanyBioResponseData.response)
        
        mockLaunchNetworkService = MockLaunchInformationService(result: launcheDataReponse)
        mockCompanyBioService = MockCompanyBioService(result: companyInformationsDataResponse)
        mockRocketInformation = MockRocketInformationService(result: rcoketDataReponse)
        viewModel = .init(companyBioService: mockCompanyBioService, launchService: mockLaunchNetworkService, rocketService: mockRocketInformation)
    }

    override func tearDownWithError() throws {
        viewModel = nil
    }

    func testStringReturnForSuccessStatusIsAccurate() throws {

        let imageName = viewModel.returnImageNameForSuccessStatus(launchStatus: true)
        XCTAssertNotNil(imageName)
        XCTAssertEqual(imageName,"checkmark")
    
    }
    func testStringReturnedForPastAndFutrueDates() throws {
        let testPastDate = "2006-03-25T10:30:00+12:00"
        XCTAssertEqual(viewModel.returnStringForPastAndFutrueDates(date:testPastDate),"since")
        
        let testFutureDate = "2023-03-25T10:30:00+12:00"
        XCTAssertEqual(viewModel.returnStringForPastAndFutrueDates(date:testFutureDate),"from")
        
        }
    
    func testCompanyBioStringIsSetCorrectly() throws {
    
        let exp = expectation(description: "Test after 5 seconds")
        let result = XCTWaiter.wait(for: [exp], timeout: 5.0)
        if result == XCTWaiter.Result.timedOut{
            XCTAssertEqual(viewModel.bioString,"SpaceX was founded by Elon Musk. It has now 9500 employees, 3 launch sites, and it is valued at $74000000000")
        } else {
            XCTFail("Delay interrupted")
        }
    }
    
    func testRocketDataModelIsAccuratelyDecoded() throws {
        let rcoketDataReponse = Result<[RocketModel], APIError>.success(MockRocketsResponseData.response)
        let launcheDataReponse = Result<[LaunchDataModel], APIError>.success(MockLaunchesResponseData.response)
        let companyInformationsDataResponse = Result<CompanyInfoModel, APIError>.success(MockCompanyBioResponseData.response)
        
        mockLaunchNetworkService = MockLaunchInformationService(result: launcheDataReponse)
        mockCompanyBioService = MockCompanyBioService(result: companyInformationsDataResponse)
        mockRocketInformation = MockRocketInformationService(result: rcoketDataReponse)
        
        viewModel = .init(companyBioService: mockCompanyBioService, launchService: mockLaunchNetworkService, rocketService: mockRocketInformation)
        
        viewModel.fetchRocketData()
     
        let exp = expectation(description: "Test after 5 seconds")
        let result = XCTWaiter.wait(for: [exp], timeout: 5.0)
        if result == XCTWaiter.Result.timedOut{
            XCTAssertNil(viewModel.errorMessage)
            XCTAssertEqual(viewModel.rocketData[0].name,"Falcon 1" )
            XCTAssertEqual(viewModel.rocketData[2].name,"Falcon Heavy" )
        } else {
            XCTFail("Delay interrupted")
        }
    }
    func testErrorMessageIsSetCorrectlyWhenErrorOccurs() throws {
        
        let rcoketDataReponse = Result<[RocketModel], APIError>.failure(APIError.badUrl)
        let launcheDataReponse = Result<[LaunchDataModel], APIError>.failure(APIError.badUrl)
        let companyInformationsDataResponse = Result<CompanyInfoModel, APIError>.failure(APIError.badUrl)
       
        mockLaunchNetworkService = MockLaunchInformationService(result:launcheDataReponse )
        mockCompanyBioService = MockCompanyBioService(result:companyInformationsDataResponse)
        mockRocketInformation = MockRocketInformationService(result:rcoketDataReponse)
        
        viewModel = .init(companyBioService: mockCompanyBioService, launchService: mockLaunchNetworkService, rocketService: mockRocketInformation)
        viewModel.fetchRocketData()

        let exp = expectation(description: "Test after 5 seconds")
        let result = XCTWaiter.wait(for: [exp], timeout: 5.0)
        if result == XCTWaiter.Result.timedOut{
        
            XCTAssertNotNil(viewModel.errorMessage)
            XCTAssertEqual(viewModel.errorMessage,"Sorry something went wrong")
        } else {
            XCTFail("Delay interrupted")
        }
    }
    
    func testDatesAreCorrectlyFormatted(){
        viewModel.fetchLaunchData()
        let exp = expectation(description: "Test after 5 seconds")
        let result = XCTWaiter.wait(for: [exp], timeout: 5.0)
        if result == XCTWaiter.Result.timedOut{
        let dateToBeFordatted = viewModel.LanchData[0].date_local
        let formattedDate = viewModel.returnFormatedLocalDate(date: dateToBeFordatted)
        XCTAssertEqual(formattedDate,"2006:3:24 at 22:30")
         
        } else {
            XCTFail("Delay interrupted")
        }
    }
    
    func testUniquedatesListOnlyContainsUniqeEntries(){
        
        let exp = expectation(description: "Test after 5 seconds")
        let result = XCTWaiter.wait(for: [exp], timeout: 5.0)
        if result == XCTWaiter.Result.timedOut{
            viewModel.fetchLaunchData()
            viewModel.getUniqueDates()
            let setOfUniqueDates = NSCountedSet.init(array:viewModel.uniqueDatesOfLanches)
            var duplicates: Int = 0
            for date in setOfUniqueDates {
                if setOfUniqueDates.count(for: date) > 1 {
                    duplicates = duplicates+1
                }
            }
            XCTAssertEqual(duplicates,0)
        } else {
            XCTFail("Delay interrupted")
        }
    }

    func testTheDifferenceInDatesAreCalculatedAcccuretly(){

        let exp = expectation(description: "Test after 5 seconds")
        let result = XCTWaiter.wait(for: [exp], timeout: 5.0)
        if result == XCTWaiter.Result.timedOut{
            viewModel.fetchLaunchData()
            let date = viewModel.LanchData[2].date_local
            let differenceInDaysviewModel = viewModel.returnDifferenceInDates(lhs: date)
            XCTAssertEqual(differenceInDaysviewModel, "-5111")
        } else {
            XCTFail("Delay interrupted")
        }
    }
}
