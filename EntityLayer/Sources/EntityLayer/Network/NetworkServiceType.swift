import Foundation
import Combine

public protocol NetworkServiceType: AnyObject {

    @discardableResult
    func load<T: Decodable>(_ resource: Resource<T>) -> AnyPublisher<T, NetworkError>
}

public enum NetworkError: Error {

    case networkFailure

    case timeout

    // MARK: - Server / Authentication

    case server

    case serviceUnavailable

    case apiRateLimited

    case unAuthorized

    case forbidden

    case notFound

    // MARK: - Misc

    case noDataFound

    case jsonDecodingError(error: Error)

    case unknown

}
