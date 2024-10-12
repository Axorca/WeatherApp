import Foundation

/**
 Please refer to comprehensive documentation available at:
 https://openweathermap.org/api
*/

struct ApiConstants {

    /// Note:  change to other OpenWeatherMap API key if needed
    static let apiKey = ""

    static let baseUrl = URL(string: "https://api.openweathermap.org/data/2.5/weather")!
}
