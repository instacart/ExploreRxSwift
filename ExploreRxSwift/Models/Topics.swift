import UIKit

enum Topics: String, CaseIterable {
    case backgroundAndConcurrency = "Background work & concurrency"
    case accumulateTapEvents = "Accumulate calls"
    case simplePooling = "Simple pooling"
    case debounceTextField = "Instant/auto text listeners"
    case formValidation = "Form validation"
    case githubRepos = "GitHub repos"

    var subtitle: String? {
        switch self {
        case .backgroundAndConcurrency: return "using schedulers"
        case .accumulateTapEvents: return "using buffer"
        case .simplePooling: return "using interval"
        case .debounceTextField: return "using debounce"
        case .formValidation: return "using combineLatest"
        case .githubRepos: return nil
        }
    }
    var viewController: UIViewController {
        switch self {
        case .backgroundAndConcurrency: return BackgroundAndConcurrencyVC()
        case .accumulateTapEvents: return AccumulateCallsVC()
        case .simplePooling: return SimplePoolingVC()
        case .debounceTextField: return DebounceTextFieldVC()
        case .formValidation: return FormValidationVC()
        case .githubRepos: return GitHubReposVC()
        }
    }
}
