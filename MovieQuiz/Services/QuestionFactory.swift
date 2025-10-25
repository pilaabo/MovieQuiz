import Foundation

final class QuestionFactory: QuestionFactoryProtocol {
//    private let questions: [QuizQuestion] = [
//        QuizQuestion(
//            imageName: "The Godfather",
//            text: "Рейтинг этого фильма больше чем 6?",
//            correctAnswer: true
//        ),
//        QuizQuestion(
//            imageName: "The Dark Knight",
//            text: "Рейтинг этого фильма больше чем 6?",
//            correctAnswer: true
//        ),
//        QuizQuestion(
//            imageName: "Kill Bill",
//            text: "Рейтинг этого фильма больше чем 6?",
//            correctAnswer: true
//        ),
//        QuizQuestion(
//            imageName: "The Avengers",
//            text: "Рейтинг этого фильма больше чем 6?",
//            correctAnswer: true
//        ),
//        QuizQuestion(
//            imageName: "Deadpool",
//            text: "Рейтинг этого фильма больше чем 6?",
//            correctAnswer: true
//        ),
//        QuizQuestion(
//            imageName: "The Green Knight",
//            text: "Рейтинг этого фильма больше чем 6?",
//            correctAnswer: true
//        ),
//        QuizQuestion(
//            imageName: "Old",
//            text: "Рейтинг этого фильма больше чем 6?",
//            correctAnswer: false
//        ),
//        QuizQuestion(
//            imageName: "The Ice Age Adventures of Buck Wild",
//            text: "Рейтинг этого фильма больше чем 6?",
//            correctAnswer: false
//        ),
//        QuizQuestion(
//            imageName: "Tesla",
//            text: "Рейтинг этого фильма больше чем 6?",
//            correctAnswer: false
//        ),
//        QuizQuestion(
//            imageName: "Vivarium",
//            text: "Рейтинг этого фильма больше чем 6?",
//            correctAnswer: false
//        )
//    ]
    
    private let moviesLoader: MovieLoading
    private weak var delegate: QuestionFactoryDelegate?
    
    private var movies: [MostPopularMovie] = []
    
    init(moviesLoader: MovieLoading, delegate: QuestionFactoryDelegate? = nil) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
    
    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            let index = (0..<self.movies.count).randomElement() ?? 0
            
            guard let movie = self.movies[safe: index] else { return }
            
            var imageData = Data()
            
            do {
                imageData = try Data(contentsOf: movie.resizedImageURL)
            } catch {
                DispatchQueue.main.async {
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
            
            let rating = Float(movie.rating) ?? 0
            
            let text = "Рейтинг этого фильма больше чем 8.3?"
            let correctAnswer = rating > 8.3
            
            let question = QuizQuestion(imageData: imageData,
                                        text: text,
                                        correctAnswer: correctAnswer)
            
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                
                delegate?.didReceiveNextQuestion(question: question)
            }
        }
    }
    
    func loadData() {
        self.moviesLoader.loadMovie { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
                switch result {
                case .success(let mostPopularMovies):
                    self.movies = mostPopularMovies.items
                    self.delegate?.didLoadDataFromServer()
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }
}
