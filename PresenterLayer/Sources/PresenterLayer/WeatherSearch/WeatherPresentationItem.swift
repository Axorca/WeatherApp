import Foundation
import InteractorLayer

struct WeatherPresentationItem: Identifiable, Equatable {

    // MARK: - Properties

    private let weather: CityWeather

    // MARK: - Initializer

    init(_ weather: CityWeather) {
        self.weather = weather
    }

    var id: String { weather.id }

    var cityName: String { weather.cityName }
    var summary: String { weather.description ?? "" }

    var iconURL: URL? { weather.iconURL }

    var averageTemperature: String { "\(Int(weather.temperature))°" }
    var minTemperature: String { "\(Self.numberFormatter.string(for: weather.minTemperature) ?? "0")" }
    var maxTemperature: String { "\(Self.numberFormatter.string(for: weather.maxTemperature) ?? "0")" }
    var feelsLike: String { "Feels like \(Int(weather.feelsLikeTemperature))°" }

    var humidity: String { "\(weather.humidity.round())%" }
    var windSpeed: String { "\(Self.numberFormatter.string(for: weather.windSpeed) ?? "0") m/s" }

    // MARK: - Private

    private static var numberFormatter: NumberFormatter {
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 1
        return numberFormatter
    }
}

// MARK: - Private helpers

private extension Double {
    func round() -> String {
        return String(format: "%.0f", self)
    }
}
