import Foundation

struct Log {
    static func threadEvent(_ items: Any...) {
        print("Called on \(Thread.current)", items)
    }
}

