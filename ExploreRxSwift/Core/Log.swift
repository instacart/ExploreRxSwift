import Foundation

struct Log {
    static func threadEvent(_ items: Any...) {
        print(Date(), "--  \(Thread.current)\n", items, "\n")
    }
}

