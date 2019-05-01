import UIKit

enum Topics: String, CaseIterable {
    case backgroundAndConcurrency = "Background work & concurrency (using Schedulers)"
    case accumulateTapEvents = "Accumulate calls (using buffer)"
    case simpleAndIncreasingPooling = "Simple and Advanced polling (using interval and repeatWhen)"
    case debounceTextField = "Instant/Auto searching text listeners (using debounce)"
    case githubRepos = "GitHub repos"

    var viewController: UIViewController {
        switch self {
        case .backgroundAndConcurrency: return BackgroundAndConcurrencyVC()
        case .accumulateTapEvents: return AccumulateCallsVC()
        case .simpleAndIncreasingPooling: return SimpleAndIncreasingPoolingVC()
        case .debounceTextField: return DebounceTextFieldVC()
        case .githubRepos: return GitHubReposVC()
        }
    }
}
