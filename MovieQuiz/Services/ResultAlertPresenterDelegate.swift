import UIKit

protocol ResultAlertPresenterDelegate: AnyObject {
    func present(alert: UIAlertController)
    
    func startNewQuiz()
}
