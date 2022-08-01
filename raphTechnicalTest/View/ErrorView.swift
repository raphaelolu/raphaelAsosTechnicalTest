
import SwiftUI

struct ErrorView: View {
    @ObservedObject var model:ViewModel
    
    var body: some View {
        Text(model.errorMessage ?? "")
    }
}
