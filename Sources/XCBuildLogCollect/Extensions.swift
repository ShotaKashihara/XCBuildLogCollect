import Foundation

extension String {
    var isBlank: Bool {
        return allSatisfy(\.isWhitespace)
    }
}

extension Optional where Wrapped == String {
    var isBlank: Bool {
        return self?.isBlank ?? true
    }
}
