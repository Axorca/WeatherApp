import SwiftUI
import SwiftData
import PresenterLayer

@main
struct WeatherApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .accentColor(.white)
        }
        .modelContainer(for: SearchLocation.self)
    }
}
