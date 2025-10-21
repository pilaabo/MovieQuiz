import UIKit

final class ResultAlertPresenter {
    weak var delegate: ResultAlertPresenterDelegate?
    
    func setDelegate(_ delegate: ResultAlertPresenterDelegate) {
        self.delegate = delegate
    }
    
    func show(quiz result: AlertModel) {
        let alert = UIAlertController(
            title: result.title,
            message: result.message,
            preferredStyle: .alert
        )
        let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
            self.delegate?.startNewQuiz()
        }
        alert.addAction(action)
        delegate?.present(alert: alert)
    }
}
