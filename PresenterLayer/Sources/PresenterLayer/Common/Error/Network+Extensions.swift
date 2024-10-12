import Foundation
import EntityLayer

extension NetworkError {

    var title: String {
        switch self {
        case .notFound:
            return "City not found!"
        case .networkFailure:
            return "You seem to be offline!"
        default:
            return "Something went wrong!"
        }
    }

    var message: String {
        switch self {
        case .notFound:
            return "Please adjust keyword or postcode."
        case .networkFailure:
            return "Please connect to the Internet and start punting."
        default:
            return "Please try again later."
        }
    }

    var iconName: String {
        switch self {
        case .notFound:
            return "cloud"
        case .networkFailure:
            return "wifi.exclamationmark"
        default:
            return "exclamationmark.icloud"
        }
    }
}
