import Foundation

final class MovieLoader: MovieLoading {
    private let networkClient = NetworkClient()
    
    private var mostPopularMoviesUrl: URL {
        guard let url = URL(string: "https://tv-api.com/en/API/Top250Movies/k_zcuw1ytf") else {
            preconditionFailure("Unable to construct mostPopularMoviesUrl")
        }
        return url
    }

    func loadMovie(handler: @escaping (Result<MostPopularMovies, any Error>) -> Void) {
        networkClient.fetch(url: mostPopularMoviesUrl) { result in
            do {
                let data = try result.get()
                let mostPopularMovies = try JSONDecoder().decode(MostPopularMovies.self, from: data)
                handler(.success(mostPopularMovies))
            } catch {
                handler(.failure(error))
            }
        }
    }
}

protocol MovieLoading {
    func loadMovie(handler: @escaping (Result<MostPopularMovies, Error>) -> Void)
}
