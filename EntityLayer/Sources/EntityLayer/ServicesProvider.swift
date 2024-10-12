import Foundation

public class ServicesProvider {

    public let network: NetworkServiceType

    init(network: NetworkServiceType) {
        self.network = network
    }

    public static func defaultProvider() -> ServicesProvider {
        let sessionConfig = URLSessionConfiguration.ephemeral
        sessionConfig.timeoutIntervalForRequest = 5
        sessionConfig.waitsForConnectivity = true
        sessionConfig.allowsConstrainedNetworkAccess = true
        sessionConfig.allowsExpensiveNetworkAccess = true

        let network = NetworkService(with: sessionConfig)

        return ServicesProvider(network: network)
    }

}
