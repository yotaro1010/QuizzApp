//
//  GameViewController.swift
//  QuizeApp
//
//  Created by Yotaro Ito on 2021/04/15.
//

import UIKit

class GameViewController: UIViewController {

    var gameModels = [Question]()
    var currentQuestion: Question?
    
    @IBOutlet var label: UILabel!
    @IBOutlet var tableView: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        setUpQuestions()
        configureUI(queation: gameModels.first!)
    }
    
//    ここにconfigureUI(queation: gameModels.first!)を入れてしまうと、tabelView.reloadDataされた度に、毎回呼び出されてしまうために次のクイズが表示されなかった。
//    だからずっと正解を押してもUIが切り替わらず最初のクイズばっかりだった。
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        configureUI(queation: gameModels.first!)
    }
    
    private func configureUI(queation: Question){
        label.text = queation.text
        currentQuestion = queation
        tableView.reloadData()
    }
    
    private func checkTheAnswer(answer: Answer, question: Question) -> Bool {
     return question.answers.contains(where: {$0.text == answer.text}) && answer.correct
    }
    
    private func setUpQuestions(){
        gameModels.append(Question(text: "What is capital of Japan", answers: [
            Answer(text: "Kyoto", correct: false),
            Answer(text: "Tokyo", correct: true),
            Answer(text: "Osaka", correct: false),
            Answer(text: "Nagoya", correct: false)
        ]))
        gameModels.append(Question(text: "What is capital of Usa", answers: [
            Answer(text: "Washington D.C", correct: true),
            Answer(text: "NewYork", correct: false),
            Answer(text: "Sanfrancisco", correct: false),
            Answer(text: "Seattle", correct: false)
        ]))
        gameModels.append(Question(text: "What is capital of England", answers: [
            Answer(text: "Cambriage", correct: false),
            Answer(text: "Liverpool", correct: false),
            Answer(text: "London", correct: true),
            Answer(text: "Manchestar", correct: false)
        ]))
        gameModels.append(Question(text: "What is capital of Germany", answers: [
            Answer(text: "Munich", correct: false),
            Answer(text: "Berlin", correct: true),
            Answer(text: "Hanover", correct: false),
            Answer(text: "Paris", correct: false)
        ]))
    }
}

extension GameViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentQuestion?.answers.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = currentQuestion?.answers[indexPath.row].text
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let presentedQuestion = currentQuestion else {return}
        
        let presentedAnswer = presentedQuestion.answers[indexPath.row]
        if checkTheAnswer(answer: presentedAnswer, question: presentedQuestion) {
//            correct then show next question
            if let index = gameModels.firstIndex(where: {$0.text == presentedQuestion.text}) {
                
//                [0,1,2] 0から数え始めるため　−１をして次の問題に移る
                if index < (gameModels.count - 1) {
                    let nextQuestion = gameModels[index+1]
                    print("\(nextQuestion.text)")
                    currentQuestion = nil
                    configureUI(queation: nextQuestion)
                }
                else {
                    let alert = UIAlertController(title: "Done!", message: "Congulateration!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                    present(alert, animated: true)
                }
            }
        } else {
//            wrong
            let alert = UIAlertController(title: "Wrong", message: "You faild Stupid", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert, animated: true)
        }
    }
    
}

struct  Question {
    let text: String
    let answers: [Answer]
}

struct Answer {
    let text: String
    let correct: Bool
}
