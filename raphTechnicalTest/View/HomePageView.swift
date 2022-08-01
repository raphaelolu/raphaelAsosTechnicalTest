
import SwiftUI

struct HomePageView: View {
    @ObservedObject var viewModel = ViewModel()
    @State var showingFilterConfirmationDialog = false
    @State var showingArticleDetailConfirmationDialog = false
    var rocketLaunchesList:[LaunchDataModel] {
        viewModel.returnFilteredLaunchObjects()
    }
    
    var body: some View {
        if(viewModel.isLoading){
            LoadingView()
        } else if viewModel.errorMessage
                    != nil{
            ErrorView(model:viewModel)
        } else{
            NavigationView{
                VStack{
                    Divider()
                    HStack {
                        Text("COMPANY").frame( height:15, alignment: .leading)
                        Spacer()
                    }
                    Divider()
                    Text(viewModel.bioString)
                    Divider()
                    HStack {
                        Text("LAUNCHES")
                            .frame( height:15, alignment: .leading)
                            .navigationTitle("SpaceX")
                            .navigationBarTitleDisplayMode(.inline)
                            .navigationBarItems(trailing:
                                                    Button(action:
                                                            {showingFilterConfirmationDialog = true})
                                                {
                                HStack(alignment: .center, spacing: 5.0) {
                                    Image(systemName: "square.and.pencil")
                                }
                            }.confirmationDialog("View", isPresented: $showingFilterConfirmationDialog) {
                                Button("All"){
                                    viewModel.isInformationFiltered = false
                                }
                                Button("Descending") {
                                    viewModel.sortLaunchDataInDescendingOrder()
                                }
                                Button("Ascending") {
                                    viewModel.sortLaunchDataInAscendingOrder()
                                }
                                Button("Successful launches") {
                                    viewModel.successFilter = true
                                    viewModel.isInformationFiltered = true
                                }
                                Button("Successful & Unsucessful") {
                                    viewModel.successFilter = false
                                    viewModel.isInformationFiltered = true
                                }
                                ForEach(viewModel.uniqueDatesOfLanches, id: \.self) { date in
                                    Button(String(date)) {
                                        viewModel.dateFiler = (String(date))
                                        viewModel.isInformationFiltered = true
                                    }
                                }
                                Button("Cancel", role: .cancel) { }
                            } message: {
                                Text("View")
                            })
                        Spacer()
                    }
                    Divider()
                    
                    List() {
                        ForEach(rocketLaunchesList) {
                            launch in
                            ListViewCell(rocketLaunche: launch, viewModel: viewModel)
                                .listRowSeparator(.hidden)
                                .onTapGesture {
                                    showingArticleDetailConfirmationDialog.toggle()
                                }
                                .confirmationDialog("Open brower", isPresented: $showingArticleDetailConfirmationDialog) {
                                    if(launch.links.wikipedia != nil) {
                                        Link("Wickipedia", destination: URL(string: launch.links.wikipedia!)!)
                                    }
                                    if(launch.links.webcast != nil) {
                                        Link("Youtube", destination: URL(string: launch.links.webcast!)!)
                                    }
                                    if(launch.links.article != nil)
                                    {
                                        Link("Article", destination: URL(string: launch.links.article!)!)
                                    }
                                    Button("Cancel", role: .cancel) { }
                                } message: {
                                    Text("Go to")
                                }
                            
                        }
                    }.listStyle(PlainListStyle())
                }.onAppear(){
                }
            }
        }
    }
}
