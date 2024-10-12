import XCTest
import Combine
@testable import EntityLayer
@testable import InteractorLayer

final class WeatherUseCaseTests: XCTestCase {

    private var useCase: WeatherUseCaseType!

    private var cancellables: [AnyCancellable] = []

    // MARK: - Lifecycle

    override func tearDown() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        useCase = nil

        super.tearDown()
    }

    // MARK: - Tests

    func testCallingServiceSpy() throws {
        let serviceSpy = NetworkServiceSpy()
        useCase = WeatherUseCase(networkService: serviceSpy)

        useCase.fetchWeather(with: "Sydney")
        .sink { _ in } receiveValue: { _ in
        }.store(in: &cancellables)

        XCTAssertTrue(serviceSpy.loadResourceCalled)

        XCTAssertNotNil(serviceSpy.url)
        XCTAssertEqual(
            serviceSpy.url?.absoluteString,
            "https://api.openweathermap.org/data/2.5/weather"
        )
        XCTAssertNotNil(serviceSpy.parameters)
        XCTAssertEqual(serviceSpy.parameters?.count, 3)

        XCTAssertEqual(serviceSpy.parameters?.first?.0, "q")

        XCTAssertEqual(serviceSpy.parameters?.first?.1.description, "Sydney,au")
    }

    func testFetchingSuccess() {

        var receivedError: NetworkError?
        var receivedResponse: CityWeather?

        let serviceMock = NetworkServiceMock(
            response: TestHelper.sampleWeatherInfo,
            returningError: false)
        useCase = WeatherUseCase(networkService: serviceMock)

        useCase.fetchWeather(with: "Sydney")
            .sink { completion in
                if case .failure(let error) = completion {
                    receivedError = error
                }
            } receiveValue: { response in
                receivedResponse = response
            }
            .store(in: &cancellables)
        XCTAssertEqual(receivedResponse?.id, "2147714")
        XCTAssertEqual(receivedResponse?.cityName, "Sydney")
        XCTAssertEqual(receivedResponse?.title, "Clear")
        XCTAssertEqual(receivedResponse?.description, "clear sky")
        XCTAssertEqual(receivedResponse?.temperature, 16.44)
        XCTAssertEqual(receivedResponse?.feelsLikeTemperature, 15.47)
        XCTAssertEqual(receivedResponse?.minTemperature, 15.22)
        XCTAssertEqual(receivedResponse?.maxTemperature, 17.43)
        XCTAssertEqual(receivedResponse?.humidity, 51.0)
        XCTAssertEqual(receivedResponse?.windSpeed, 5.14)
        XCTAssertEqual(
            receivedResponse?.iconURL?.absoluteString,
            "https://openweathermap.org/img/w/01d.png")

        XCTAssertNil(receivedError)
    }

    func testFetchingFailure() {

        var receivedError: NetworkError?
        var receivedResponse: CityWeather?

        let serviceMock = NetworkServiceMock(
            response: TestHelper.sampleWeatherInfo,
            returningError: true,
            error: .server
        )
        useCase = WeatherUseCase(networkService: serviceMock)

        useCase.fetchWeather(with: "Sydney")
            .sink { completion in
                if case .failure(let error) = completion {
                    receivedError = error
                }
            } receiveValue: { response in
                receivedResponse = response
            }
            .store(in: &cancellables)

        XCTAssertEqual(receivedError, .server)

        XCTAssertNil(receivedResponse)
    }
}
