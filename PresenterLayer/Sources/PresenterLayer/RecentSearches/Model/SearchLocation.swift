import Foundation
import SwiftUI
import SwiftData

@Model
final public class SearchLocation {

    @Attribute(.unique)
    public var id: String
    public var name: String
    public var timeStamp: Date

    init(id: String, name: String, timeStamp: Date) {
        self.id = id
        self.name = name
        self.timeStamp = timeStamp
    }
}
