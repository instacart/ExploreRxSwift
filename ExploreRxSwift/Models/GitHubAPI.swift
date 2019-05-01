import Foundation
import RxSwift
import RxCocoa

final class GitHubAPI {
    func repos(forUser username: String) -> Observable<[Repo]> {
        let url = URL(string: "https://api.github.com/users/\(username)/repos?per_page=100")!
        let request = URLRequest(url: url)
        return URLSession.shared.rx.data(request: request)
            .map { data in
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase

                return try decoder.decode([Repo].self, from: data)
            }
    }

    func releases(forRepo repo: String) -> Observable<[Release]> {
        let url = URL(string: "https://api.github.com/repos/\(repo)/releases")!
        let request = URLRequest(url: url)
        return URLSession.shared.rx.data(request: request)
            .map { data in
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase

                return try decoder.decode([Release].self, from: data)
            }
    }
}
