import SwiftUI
import UIKit

enum VersionType: String {
    case beta = "Beta"
    case release = "Release"
}

enum Architecture: String {
    case arm64
    case arm64e
}

struct ContentView: View {
    @State private var selectedVersionType = VersionType.release
    @State private var selectedArchitecture = Architecture.arm64
    @State private var iOSVersion = ""
    @State private var isSupported = false
    @State private var supportedRange: String? = nil
    @State private var officialWebsites: [(String, String)]? = nil
    @State private var installationGuides: [(String, String)]? = nil
    
    let trollStoreSupportData: [TrollStoreSupportData] = [
        TrollStoreSupportData(fromVersion: "14.0 beta 1", toVersion: "14.0 beta 2", platforms: "arm64 (A8) - arm64 (A9-A11)", supported: [:]),
        TrollStoreSupportData(fromVersion: "14.0 beta 2", toVersion: "14.8.1", platforms: "arm64 (A8) - arm64 (A9-A11)", supported: ["TrollInstallerX": "https://github.com/alfiecg24/TrollInstallerX/tree/1.0.2", "TrollHelperOTA": "https://ios.cfw.guide/installing-trollstore-trollhelperota"]),
        TrollStoreSupportData(fromVersion: "15.0", toVersion: "15.0", platforms: "arm64 (A8) - arm64e (A12-A17/M1-M2)", supported: ["TrollInstallerX": "https://github.com/alfiecg24/TrollInstallerX/tree/1.0.2", "TrollHelperOTA": "https://ios.cfw.guide/installing-trollstore-trollhelperota"]),
        TrollStoreSupportData(fromVersion: "15.0 beta 1", toVersion: "15.5 beta 4", platforms: "arm64 (A8) - arm64e (A12-A17/M1-M2)", supported: ["TrollHelperOTA": "https://ios.cfw.guide/installing-trollstore-trollhelperota"]),
        TrollStoreSupportData(fromVersion: "15.5", toVersion: "15.5", platforms: "arm64 (A8) - arm64e (A12-A17/M1-M2)", supported: ["TrollHelperOTA": "https://ios.cfw.guide/installing-trollstore-trollhelperota", "TrollInstallerX": "https://github.com/alfiecg24/TrollInstallerX/tree/1.0.2", "TrollInstallerMDC": "https://dhinakg.github.io/apps.html"]),
        TrollStoreSupportData(fromVersion: "16.0 beta 1", toVersion: "16.0 beta 3", platforms: "arm64 (A8) - arm64e (A12-A17/M1-M2)", supported: [:]),
        TrollStoreSupportData(fromVersion: "16.0 beta 4", toVersion: "16.6.1", platforms: "arm64 (A8) - arm64e (A12-A17/M1-M2)", supported: ["TrollInstallerX": "https://github.com/alfiecg24/TrollInstallerX/tree/1.0.2", "TrollHelperOTA": "https://ios.cfw.guide/installing-trollstore-trollhelperota"]),
        TrollStoreSupportData(fromVersion: "16.7 RC", toVersion: "16.7 RC", platforms: "arm64 (A8) - arm64e (A12-A17/M1-M2)", supported: ["TrollHelper": "https://ios.cfw.guide/installing-trollstore-trollhelper", "No Install Method": ""]),
        TrollStoreSupportData(fromVersion: "16.7", toVersion: "16.7.7", platforms: "arm64 (A8) - arm64e (A12-A17/M1-M2)", supported: ["Unsupported": ""]),
        TrollStoreSupportData(fromVersion: "17.0 beta 1", toVersion: "17.0 beta 4", platforms: "arm64 (A8) - arm64e (A12-A17/M1-M2)", supported: ["TrollInstallerX": "https://github.com/alfiecg24/TrollInstallerX/tree/1.0.2", "No Install Method": ""]),
        TrollStoreSupportData(fromVersion: "17.0 beta 5", toVersion: "17.0", platforms: "arm64 (A8) - arm64e (A12-A17/M1-M2)", supported: ["TrollHelper": "https://ios.cfw.guide/installing-trollstore-trollhelper", "No Install Method": ""]),
        TrollStoreSupportData(fromVersion: "17.0.1 and later", toVersion: "17.0.1 and later", platforms: "arm64 (A8) - arm64e (A12-A17/M1-M2)", supported: ["Unsupported": ""])
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Version and Architecture")) {
                        Text("Version Type: \(selectedVersionType.rawValue)")
                        Text("Architecture: \(selectedArchitecture.rawValue)")
                    }
                    
                    Section(header: Text("iOS Version")) {
                        Text(iOSVersion)
                            .font(.headline)
                    }
                    
                    if isSupported {
                        Section(header: Text("Support Information")) {
                            Text("iOS Version: \(iOSVersion)")
                            Text("TrollStore Support: Supported")
                                .foregroundColor(.green)
                            if let range = supportedRange {
                                Text(range)
                            }
                            
                            if let officialWebsites = officialWebsites {
                                Section(header: Text("Official Websites")) {
                                    ForEach(officialWebsites, id: \.0) { (name, link) in
                                        Button("\(name) Official Website") {
                                            guard let url = URL(string: link) else { return }
                                            UIApplication.shared.open(url)
                                        }
                                    }
                                }
                            }
                            
                            if let installationGuides = installationGuides {
                                Section(header: Text("Installation Guides")) {
                                    ForEach(installationGuides, id: \.0) { (name, link) in
                                        Button("\(name) Installation Guide") {
                                            guard let url = URL(string: link) else { return }
                                            UIApplication.shared.open(url)
                                        }
                                    }
                                }
                            }
                        }
                    } else {
                        Section(header: Text("Support Information")) {
                            Text("iOS Version: \(iOSVersion)")
                            Text("TrollStore Support: Not Supported")
                                .foregroundColor(.red)
                        }
                    }
                }
                .navigationTitle("TrollStore Checker")
                .onAppear {
                    fetchDeviceInfo()
                    checkSupport()
                }
            }
        }
    }
    
    func fetchDeviceInfo() {
        let systemVersion = UIDevice.current.systemVersion
        let architecture = getDeviceArchitecture()
        
        iOSVersion = systemVersion
        if architecture == "arm64e" {
            selectedArchitecture = .arm64e
        } else {
            selectedArchitecture = .arm64
        }
    }
    
    func getDeviceArchitecture() -> String {
        var size: size_t = 0
        sysctlbyname("hw.machine", nil, &size, nil, 0)
        var machine = [CChar](repeating: 0, count: Int(size))
        sysctlbyname("hw.machine", &machine, &size, nil, 0)
        let model = String(cString: machine)
        
        if model.starts(with: "iPhone10,3") || model.starts(with: "iPhone10,6") || model.starts(with: "iPhone11") || model.starts(with: "iPhone12") || model.starts(with: "iPhone13") || model.starts(with: "iPhone14") || model.starts(with: "iPhone15") {
            return "arm64e"
        }
        return "arm64"
    }
    
    func checkSupport() {
        let result = trollStoreSupportInfo(for: iOSVersion)
        isSupported = result.supported
        supportedRange = result.supportedRange
        officialWebsites = result.officialWebsites
        installationGuides = result.installationGuides
    }
    
    func trollStoreSupportInfo(for iOSVersion: String) -> (supported: Bool, supportedRange: String?, officialWebsites: [(String, String)]?, installationGuides: [(String, String)]?) {
        let version = selectedVersionType == .beta ? "\(iOSVersion) beta" : iOSVersion
        let architecture = selectedArchitecture.rawValue
        
        for data in trollStoreSupportData {
            if isVersionInRange(version, fromVersion: data.fromVersion, toVersion: data.toVersion) {
                if data.platforms.contains(architecture) {
                    if !data.supported.isEmpty {
                        var officialWebsites: [(String, String)] = []
                        var installationGuides: [(String, String)] = []
                        
                        for (key, value) in data.supported {
                            if key == "TrollInstallerX" {
                                officialWebsites.append((key, "https://github.com/alfiecg24/TrollInstallerX/tree/1.0.2"))
                                installationGuides.append((key, "https://ios.cfw.guide/installing-trollstore-trollinstallerx"))
                            } else if key == "TrollInstallerMDC" {
                                officialWebsites.append((key, "https://dhinakg.github.io/apps.html"))
                                installationGuides.append((key, "https://ios.cfw.guide/installing-trollstore-trollinstallermdc/"))
                            } else {
                                officialWebsites.append((key, value))
                                installationGuides.append((key, value))
                            }
                        }
                        
                        return (true, "Supported from \(data.fromVersion) to \(data.toVersion)", officialWebsites, installationGuides)
                    } else {
                        return (!data.supported.isEmpty, "Supported from \(data.fromVersion) to \(data.toVersion)", nil, nil)
                    }
                }
            }
        }
        return (false, nil, nil, nil)
    }
    
    func isVersionInRange(_ version: String, fromVersion: String, toVersion: String) -> Bool {
        let versionComponents = version.split(separator: " ").first?.split(separator: ".").map { Int($0) ?? 0 } ?? []
        let fromComponents = fromVersion.split(separator: " ").first?.split(separator: ".").map { Int($0) ?? 0 } ?? []
        let toComponents = toVersion.split(separator: " ").first?.split(separator: ".").map { Int($0) ?? 0 } ?? []
        
        return compareVersion(versionComponents, to: fromComponents) != .orderedAscending && compareVersion(versionComponents, to: toComponents) != .orderedDescending
    }
    
    func compareVersion(_ version1: [Int], to version2: [Int]) -> ComparisonResult {
        for (v1, v2) in zip(version1, version2) {
            if v1 < v2 {
                return .orderedAscending
            } else if v1 > v2 {
                return .orderedDescending
            }
        }
        return .orderedSame
    }
}

struct TrollStoreSupportData {
    let fromVersion: String
    let toVersion: String
    let platforms: String
    let supported: [String: String]

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
