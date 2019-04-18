import UIKit

enum Topics: String, CaseIterable {
    case backgroundAndConcurrency = "Background work & concurrency (using Schedulers)"
    case accumulateCalls = "Accumulate calls (using buffer)"

    var viewController: UIViewController {
        switch self {
        case .backgroundAndConcurrency: return BackgroundAndConcurrencyVC()
        case .accumulateCalls: return AccumulateCallsVC()
        }
    }
}
