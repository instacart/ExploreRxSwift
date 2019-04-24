import UIKit

enum Topics: String, CaseIterable {
    case backgroundAndConcurrency = "Background work & concurrency (using Schedulers)"
    case simpleAndIncreasingPooling = "Simple and Advanced polling (using interval and repeatWhen)"

    var viewController: UIViewController {
        switch self {
        case .backgroundAndConcurrency: return BackgroundAndConcurrencyVC()
        case .simpleAndIncreasingPooling: return SimpleAndIncreasingPooling()
        }
    }
}
