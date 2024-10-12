import Foundation
import Combine
import SharedUtils

final public class NetworkService: NetworkServiceType {

    private let session: URLSession

    public init(with configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }

    @discardableResult
    public func load<T>(_ resource: Resource<T>) -> AnyPublisher<T, NetworkError> {

        guard let request = resource.request else {
            return .fail(NetworkError.unknown)
        }

        return URLSession.shared.dataTaskPublisher(for: request)
            .mapError { error in
                return self.mapConnectivityError(error)
            }
            .tryMap { data, response  in
                guard let response = response as? HTTPURLResponse else {
                    throw NetworkError.noDataFound
                }
                guard 200..<300 ~= response.statusCode else {
                    throw self.mapHTTPStatusError(statusCode: response.statusCode)
                }
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .map {
                return $0
            }
            .catch { error -> AnyPublisher<T, NetworkError> in
                guard let networkError = error as? NetworkError else {
                    return .fail(NetworkError.jsonDecodingError(error: error))
                }
                return .fail(networkError)
            }
            .eraseToAnyPublisher()
    }

}

// MARK: - Custom Error Mapping Helpers

private extension NetworkService {

    func mapHTTPStatusError(statusCode: Int) -> NetworkError {
        switch statusCode {
        case 401:
            return .unAuthorized
        case 403:
            return .forbidden
        case 404:
            return .notFound
        case 429:
            return .apiRateLimited
        case 503:
            return .serviceUnavailable
        case 500 ... 599:
            return .server
        default:
            return .unknown
        }
    }

    func mapConnectivityError(_ error: Error) -> NetworkError {
        let errorCode = (error as NSError).code

        if NSURLErrorConnectionFailureCodes.contains(errorCode) {
            return .networkFailure
        } else if errorCode == NSURLErrorTimedOut {
            return .timeout
        } else {
            return .unknown
        }
    }

    var NSURLErrorConnectionFailureCodes: [Int] {
        [
            NSURLErrorBackgroundSessionInUseByAnotherProcess,   /// Code: `-996`
            // NSURLErrorCannotFindHost,                        /// Code: `-1003`
            NSURLErrorCannotConnectToHost,                      /// Code: ` -1004`
            NSURLErrorNetworkConnectionLost,                    /// Code: ` -1005`
            NSURLErrorNotConnectedToInternet,                   /// Code: ` -1009`
            NSURLErrorSecureConnectionFailed                   ///  Code: ` -1200`
        ]
    }
}
