
import SwiftUI

struct ListViewCell: View {
    let rocketLaunche:LaunchDataModel
    @ObservedObject var viewModel:ViewModel
    var body: some View {
        HStack{
            VStack {
                Spacer(minLength: 5)
                AsyncImage(url: URL(string: rocketLaunche.links.patch.small ?? "")) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image.resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 40)
                    case .failure:
                        Image(systemName: "photo")
                    @unknown default:
                        EmptyView()
                    }
                }
                Spacer(minLength: 20)
            }
            VStack(alignment: .leading, spacing:2){
                Text("Mission")
                Text("Date/time")
                Text("Rocket:")
                Text("Days \(viewModel.returnStringForPastAndFutrueDates(date: rocketLaunche.date_local))")
            }
            VStack(alignment: .leading, spacing:2){
                Text(rocketLaunche.name)
                Text(viewModel.returnFormatedLocalDate(date: rocketLaunche.date_local))
                Text(viewModel.rocketNamesDictionary[rocketLaunche.rocket] ?? "")
                Text(viewModel.returnDifferenceInDates(lhs: rocketLaunche.date_local))
            }
            Spacer()
            VStack {
                Image(systemName:viewModel.returnImageNameForSuccessStatus(launchStatus: rocketLaunche.success ?? nil))
            }
        }
    }
}
