import SwiftUI
import UIKit

struct TrollStoreSupportData {
    let fromVersion: String
    let toVersion: String
    let platforms: String
    let supported: [String: String]
}

class ContentViewModel: ObservableObject {
    @Published var iOSVersion: String = ""
    @Published var deviceArchitecture: String = ""
    @Published var isSupported: Bool = false
    @Published var supportedRange: String? = nil
    @Published var officialWebsites: [(String, String)]? = nil
    @Published var installationGuides: [(String, String)]? = nil
    
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
    
    init() {
        fetchDeviceInfo()
        checkSupport()
    }
    
    func fetchDeviceInfo() {
        iOSVersion = UIDevice.current.systemVersion
        deviceArchitecture = getDeviceArchitecture()
        checkSupport()
    }
    
    func checkSupport() {
        let result = trollStoreSupportInfo(for: iOSVersion)
        isSupported = result.supported
        supportedRange = result.supportedRange
        officialWebsites = result.officialWebsites
        installationGuides = result.installationGuides
    }
    
    func trollStoreSupportInfo(for iOSVersion: String) -> (supported: Bool, supportedRange: String?, officialWebsites: [(String, String)]?, installationGuides: [(String, String)]?) {
        let architecture = getDeviceArchitecture()
        
        for data in trollStoreSupportData {
            if isVersionInRange(iOSVersion, fromVersion: data.fromVersion, toVersion: data.toVersion) && data.platforms.contains(architecture) {
                if !data.supported.isEmpty {
                    let (officialWebsites, installationGuides) = getSupportLinks(data: data)
                    return (true, "Supported from \(data.fromVersion) to \(data.toVersion)", officialWebsites, installationGuides)
                }
                return (!data.supported.isEmpty, "Supported from \(data.fromVersion) to \(data.toVersion)", nil, nil)
            }
        }
        return (false, nil, nil, nil)
    }
    
    func getSupportLinks(data: TrollStoreSupportData) -> ([(String, String)], [(String, String)]) {
        var officialWebsites: [(String, String)] = []
        var installationGuides: [(String, String)] = []
        
        for (key, value) in data.supported {
            let officialLink = key == "TrollInstallerX" ? "https://github.com/alfiecg24/TrollInstallerX/tree/1.0.2" : value
            let guideLink = key == "TrollInstallerX" ? "https://ios.cfw.guide/installing-trollstore-trollinstallerx" : value
            officialWebsites.append((key, officialLink))
            installationGuides.append((key, guideLink))
        }
        return
 (officialWebsites, installationGuides)
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
    
    private func getDeviceArchitecture() -> String {
        var size: size_t = 0
        sysctlbyname("hw.machine", nil, &size, nil, 0)
        var machine = [CChar](repeating: 0, count: Int(size))
        sysctlbyname("hw.machine", &machine, &size, nil, 0)
        let model = String(cString: machine)
        
        let arm64eModels = ["iPhone10,3", "iPhone10,6", "iPhone11", "iPhone12", "iPhone13", "iPhone14", "iPhone15"]
        return arm64eModels.contains { model.starts(with: $0) } ? "arm64e" : "arm64"
    }
}
