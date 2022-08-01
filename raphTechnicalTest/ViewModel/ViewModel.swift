
import Foundation

class ViewModel:ObservableObject{
    
    @Published var bioString = ""
    @Published var LanchData = [LaunchDataModel]()
    private let companyBioService:CompanyInformationNetworkProtocol
    private let launchService:LaunchInformationNetworkProtocol
    private let rocketService:RocketInformationProtocol
    var errorMessage:String?
    @Published  var companyBioInformationModel:CompanyInfoModel?
    @Published  var uniqueDatesOfLanches = [Int]()
    @Published  var isLoading:Bool = true
    @Published  var isInformationFiltered = false
    @Published  var rocketData = [RocketModel]()
    @Published  var rocketNamesDictionary = [String:String]()
    @Published  var dateFiler = ""
    @Published  var successFilter:Bool?
    @Published  var ascendingOrderFlag:Bool?
    @Published  var descendingorderFlag:Bool?
    
    init(companyBioService:CompanyInformationNetworkProtocol = NetworkService(),launchService:LaunchInformationNetworkProtocol = NetworkService(),rocketService:RocketInformationProtocol = NetworkService()){
        self.companyBioService = companyBioService
        self.launchService = launchService
        self.rocketService = rocketService
        fetchCompanyData()
        fetchLaunchData()
        fetchRocketData()
    }
    
    func returnImageNameForSuccessStatus(launchStatus:Bool?)-> String{
        switch launchStatus {
        case true:
            return "checkmark"
        case false:
            return "xmark"
        default:
            return ""
        }
    }
    
    func fetchCompanyData() {
        companyBioService.fetchCompanyInformation { result  in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case.success(let information):
                    self.bioString = "\(information.name) was founded by \(information.ceo). It has now \(information.employees) employees, \(information.launch_sites) launch sites, and it is valued at $\(information.valuation)"
                case.failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func returnStringForPastAndFutrueDates(date:String)-> String{
        let dateFormatter = Helper.createDateFormatter()
        let dateComponent = dateFormatter.date(from:date)!
        let currentDateTime = Date()
        if (dateComponent < currentDateTime){
            return "since"
        } else {
            return "from"
        }
    }
    
    func returnFilteredLaunchObjects()-> [LaunchDataModel] {
        if isInformationFiltered == false{
            return LanchData
        }
        else if successFilter == true {
            return LanchData.filter{ return (convertDateForComparism(date: $0.date_local)  == dateFiler) && $0.success == true
            }  }
        else if successFilter != true {
            return LanchData.filter{ return (convertDateForComparism(date: $0.date_local)  == dateFiler)
            }
        }else if
            ascendingOrderFlag == true && successFilter == true{
            return LanchData.filter {return($0.success == true)
            }
        }
        else if
            descendingorderFlag == true && successFilter == true{
            return LanchData.filter {return($0.success == true)
            }
        }
        else{ return LanchData}
    }
    
    func sortLaunchDataInDescendingOrder(){
        self.LanchData  = self.LanchData.sorted {
            $0.date_local.compare($1.date_local) == .orderedDescending
        }
        self.descendingorderFlag = true
        self.ascendingOrderFlag = false
    }
    
    func fetchLaunchData(){
        launchService.fetchLaunchInformation { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case.success(let launchInformation):
                    self.LanchData = launchInformation
                    self.getUniqueDates()
                case.failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func convertDateForComparism(date:String)-> String{
        var dateYearComponent  = ""
        let dateFormatter = Helper.createDateFormatter()
        let dateOfLaunch = dateFormatter.date(from:date)!
        let year = Calendar.current.dateComponents([.year], from: dateOfLaunch)
        if let dateInYears = year.year {
            dateYearComponent = String(dateInYears)
        }
        return dateYearComponent
    }
    
    func fetchRocketData(){
        var dictionary = [String:String]()
        rocketService.fetchRocketInformation() { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case.success(let rocketData):
                    self.rocketData = rocketData
                    for rocket in rocketData {
                        dictionary.updateValue(rocket.name, forKey:rocket.id )
                    }
                    self.rocketNamesDictionary = dictionary
                case.failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func sortLaunchDataInAscendingOrder(){
        self.LanchData  = self.LanchData.sorted {
            $0.date_local.compare($1.date_local) == .orderedAscending
        }
        self.ascendingOrderFlag = true
        self.descendingorderFlag = false
    }
    
    func returnDifferenceInDates(lhs:String) -> String {
        let date = Date()
        let dateFormatter = Helper.createDateFormatter()
        let dateOfLaunch = dateFormatter.date(from:lhs)!
        let differenceInDays = Calendar.current.dateComponents([.day], from: date, to: dateOfLaunch)
        var differenceInDaysValue = ""
        if let differenceInDays = differenceInDays.day {
            differenceInDaysValue = "\(differenceInDays)"
        }
        return "\(differenceInDaysValue)"
    }
    
    func returnFormatedLocalDate(date:String)-> String{
        var dateYearComponent = ""
        var dateMonthComponent = ""
        var dateDayComponent = ""
        var dateHourComponent = ""
        var dateMinuteComponent = ""
        
        let dateFormatter = Helper.createDateFormatter()
        let date = dateFormatter.date(from:date)!
        let dateInYears = Calendar.current.dateComponents([.year], from: date)
        let monthOfLanch = Calendar.current.dateComponents([.month], from: date)
        let dayofLaunch = Calendar.current.dateComponents([.day], from: date)
        let hourOfLaunch = Calendar.current.dateComponents([.hour], from: date)
        let minuteOfLaunch = Calendar.current.dateComponents([.minute], from: date)
        
        if let dateInYears = dateInYears.year,let monthOfLaunch = monthOfLanch.month,let dayofLaunch = dayofLaunch.day, let hourOfLaunch = hourOfLaunch.hour ,let minuteOfLaunch = minuteOfLaunch.minute {
            dateYearComponent = String(dateInYears)
            dateMonthComponent = String(monthOfLaunch)
            dateDayComponent = String(dayofLaunch)
            dateHourComponent = String(hourOfLaunch)
            dateMinuteComponent = String(minuteOfLaunch)
        }
        
        return "\(dateYearComponent):\(dateMonthComponent):\(dateDayComponent) at \(dateHourComponent):\(dateMinuteComponent)"
    }
    
    func getUniqueDates(){
        var uniqueDates = [Int]()
        for launch in self.LanchData {
            let dateFormatter = Helper.createDateFormatter()
            let dateOfLaunch = dateFormatter.date(from:launch.date_local)!
            let dateComponent = Calendar.current.dateComponents([.year], from: dateOfLaunch)
            if let yearDate = dateComponent.year {
                if !uniqueDates.contains(yearDate) {
                    uniqueDates.append(yearDate)
                }
            }
            self.uniqueDatesOfLanches = uniqueDates
        }
    }
}
