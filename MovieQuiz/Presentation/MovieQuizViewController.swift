import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    // MARK: - Outlets
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var textLabel: UILabel!
    @IBOutlet weak private var counterLabel: UILabel!
    @IBOutlet weak private var noButton: UIButton!
    @IBOutlet weak private var yesButton: UIButton!
    
    // MARK: - Private properties
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    
    private var currentQuestionIndex = 0
    private var currentAnswers = 0
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let questonFactory = QuestionFactory()
        questonFactory.delegate = self
        self.questionFactory = questonFactory
        
        questonFactory.requestNextQuestion()
    }
    
    // MARK: - QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    // MARK: - Private methods
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
    }
        
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        
        // Включаем кнопки после появления вопроса. Данный код будет необходим для всех вопросов после первого, так во время проверки ответа кнопки отключаются (см. строки 123-125)
        noButton.isEnabled = true
        yesButton.isEnabled = true
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        let alert = UIAlertController(
            title: result.title,
            message: result.text,
            preferredStyle: .alert
        )
        let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
            guard let self else { return }
            
            self.currentQuestionIndex = 0
            self.currentAnswers = 0
            questionFactory?.requestNextQuestion()
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        imageView.layer.cornerRadius = 20
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self else { return }
            
            self.showNextQuestionOrResults()
        }
    }
    
    private func checkAnswer(_ userAnswer: Bool) {
        // Перед самой проверкой ответа выключаем кнопки, чтобы избежать неверное увеличение счетчика правильных ответов
        noButton.isEnabled = false
        yesButton.isEnabled = false
        
        guard let currentQuestion else {
            return
        }
        let correctAnswer = currentQuestion.correctAnswer
        let isCorrect = correctAnswer == userAnswer
        if isCorrect {
            currentAnswers += 1
        }
        showAnswerResult(isCorrect: isCorrect)
    }
    
    private func showNextQuestionOrResults() {
        imageView.layer.borderWidth = 0
        imageView.layer.borderColor = UIColor.clear.cgColor
        
        if currentQuestionIndex == questionsAmount - 1 {
            let resultViewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: "Ваш результат: \(currentAnswers)/\(questionsAmount)",
                buttonText: "Сыграть ещё раз"
            )
            show(quiz: resultViewModel)
        } else {
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
        }
    }
    
    // MARK: - Actions
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        checkAnswer(false)
        
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        checkAnswer(true)
    }
}
