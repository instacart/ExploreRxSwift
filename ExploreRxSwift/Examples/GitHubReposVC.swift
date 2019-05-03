import UIKit
import RxSwift
import Foundation
import RxCocoa

final class GitHubReposVC: TopicVC, UITableViewDelegate, UITableViewDataSource {
    private let disposeBag = DisposeBag()
    private lazy var tableView = UITableView()
    private let api = GitHubAPI()
    private var repos: [RepoWithRelease]?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        [
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ].forEach { $0.isActive = true }

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(Cell.self, forCellReuseIdentifier: "Cell")

        startObserving()
    }

    private func startObserving() {
        let api = self.api
        api.repos(forUser: "ReactiveX")
            .map { repos -> [Repo] in
                repos.sorted(by: { $0.stargazersCount > $1.stargazersCount })
            }
            .filter { $0.count > 5 }
            .flatMap { [weak self] repos -> Driver<[(Repo, Release?)]> in
                guard let self = self else { return .just([]) }
                let observables = repos.map { self.releases(forRepo: $0) }
                return Driver.combineLatest(observables)
            }
            .subscribe(onNext: { [weak self] repos in
                self?.repos = repos.map { RepoWithRelease(repo: $0.0, release: $0.1) }
                self?.tableView.reloadData()
            }, onError: { error in
                print(error)
            })
            .disposed(by: disposeBag)
    }

    private func releases(forRepo repo: Repo) -> Driver<(Repo, Release?)> {
        return api.releases(forRepo: repo.fullName)
            .map { (repo, $0.first) }
            .startWith((repo, nil))
            .asDriver(onErrorJustReturn: (repo, nil))
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repos?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let model = repos![indexPath.row]

        cell.textLabel?.text = model.repo.name + " - " + (model.release?.tagName ?? "")
        cell.detailTextLabel?.text = String(model.repo.stargazersCount)

        return cell
    }
}

private class Cell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private struct RepoWithRelease {
    let repo: Repo
    let release: Release?
}
