import Foundation
import Combine
import EntityLayer
import SharedUtils

public final class WeatherUseCase: WeatherUseCaseType {

    // MARK: - Properties

    private let networkService: NetworkServiceType

    // MARK: - Initializer

    public init(
        networkService: NetworkServiceType = ServicesProvider.defaultProvider().network
    ) {
        self.networkService = networkService
    }

    // MARK: - WeatherUseCaseType

    public func fetchWeather(with query: String) -> AnyPublisher<CityWeather, NetworkError> {

        let modifiedQuery = query + ",au"

        return networkService
            .load(Resource<WeatherInfo>.weather(query: modifiedQuery))
            .map { [unowned self] in
                self.mapCityWeather(from: $0)
            }
            .eraseToAnyPublisher()
    }

}

// MARK: - Private Helpers

private extension WeatherUseCase {

    private func mapCityWeather(from item: WeatherInfo) -> CityWeather {
        CityWeather(id: String(item.cityId),
                    cityName: item.name,
                    temperature: item.mainInfo.temperature,
                    feelsLikeTemperature: item.mainInfo.feelsLikeTemperature,
                    minTemperature: item.mainInfo.minTemperature,
                    maxTemperature: item.mainInfo.maxTemperature,
                    humidity: item.mainInfo.humidity,
                    windSpeed: item.windInfo?.speed,
                    title: item.summaries?.first?.title,
                    description: item.summaries?.first?.description,
                    iconURL: URL(
                        string: "https://openweathermap.org/img/w/" +
                                (item.summaries?.first?.iconCode ?? "") + ".png"
                    )
        )
    }

    private func transformQueryString(_ query: String) -> String {
        let keyword = query.trimmed()

        var shouldAppendAUCountryCode = false

        if keyword.isNumber && keyword.count == 4 {
            shouldAppendAUCountryCode = true
        } else {
            for city in ["melbourne", "brisbane"] {
                if city.contains(keyword.lowercased()) {
                    shouldAppendAUCountryCode = true
                    break
                } else {
                    continue
                }
            }
        }

        if shouldAppendAUCountryCode {
            return keyword + ",au"
        }

        return keyword
    }

}

private extension String {

    var isNumber: Bool {
        let digitsCharacters = CharacterSet(charactersIn: "0123456789")
        return CharacterSet(charactersIn: self).isSubset(of: digitsCharacters)
    }
}
