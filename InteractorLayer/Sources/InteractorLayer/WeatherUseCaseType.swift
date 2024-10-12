import Foundation
import Combine
import EntityLayer

public protocol WeatherUseCaseType {
    func fetchWeather(with query: String) -> AnyPublisher<CityWeather, NetworkError>

}
