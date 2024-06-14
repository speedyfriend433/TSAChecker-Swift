import SwiftUI
import UIKit

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()
    
    var body: some View {
        NavigationView {
            Form {
                userInfoSection
                extraInfoSection
            }
            .navigationTitle("TrollStore Checker")
            .onAppear {
                viewModel.fetchDeviceInfo()
                viewModel.checkSupport()
            }
        }
    }
    
    private var userInfoSection: some View {
        Section(header: Text("User Information")) {
            Text("iOS Version: \(viewModel.iOSVersion)")
            Text("Device Architecture: \(viewModel.deviceArchitecture)")
            Text("TrollStore Support: \(viewModel.isSupported ? "Supported" : "Not Supported")")
                .foregroundColor(viewModel.isSupported ? .green : .red)
        }
    }
    
    private var extraInfoSection: some View {
        if viewModel.isSupported {
            return AnyView(
                Group {
                    if let range = viewModel.supportedRange {
                        Section(header: Text("Supported Range")) {
                            Text(range)
                        }
                    }
                    
                    if let officialWebsites = viewModel.officialWebsites {
                        Section(header: Text("Official Websites")) {
                            ForEach(officialWebsites, id: \.0) { (name, link) in
                                Link("\(name) Official Website", destination: URL(string: link)!)
                            }
                        }
                    }
                    
                    if let installationGuides = viewModel.installationGuides {
                        Section(header: Text("Installation Guides")) {
                            ForEach(installationGuides, id: \.0) { (name, link) in
                                Link("\(name) Installation Guide", destination: URL(string: link)!)
                            }
                        }
                    }
                }
            )
        } else {
            return AnyView(EmptyView())
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
