//
//  ContentView.swift
//  MultiplicationBlast
//
//  Created by Dave Spina on 12/5/20.
//

import SwiftUI

struct Question {
    var x: Int
    var y: Int
    
    var answer: Int {
        return x * y
    }
}

struct ContentView: View {
    let goodAnswerResponses: [String] = ["Great job!", "That's correct", "Nailed it!"]
    let badAnswerResponses: [String] = ["That's not correct.", "Sorry, try another question.", "Nope"]
    
    @State private var userName = ""
    @State private var difficultyLevel = "Medium"
    
    @State private var currentScore: Int = 0
    @State private var currentAnswer: Int = -1;
    @State private var currentQuestion: Question = Question(x: 1, y: 1);
    
    @State private var showInit: Bool = true
    @State private var showMain: Bool = false
    @State private var showScorePage: Bool = false
    
    @State private var initColors = [Color.blue, Color.purple, Color.blue]
    @State private var gameplayColors = [Color.blue, Color.purple, Color.blue]
    @State private var currentGameplayColors = [Color.blue, Color.purple, Color.blue]
    @State private var incorrectAnwerColors = [Color.red, Color.orange]
    
    var body: some View {
        Group {
            if showInit {
                ZStack {
                    LinearGradient(gradient: Gradient(colors: initColors), startPoint: .top, endPoint: .bottom)
                    VStack {
                        TextField("Name", text: $userName)
                            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                            .background(Color.white)
                            .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                            .clipShape(RoundedRectangle(cornerRadius: 1))
                            
                    }
                }
            } else if showMain {
                ZStack {
                    VStack {
                        Text("On main")
                    }
                }
            } else if showScorePage {
                ZStack {
                    VStack {
                        Text("On on score")
                        
                    }
                }
            } else {
                VStack {
                    Text("On default")
                }
            }
            
        }.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
    }
    
    func checkAnswer() -> Bool {
        return currentQuestion.answer == currentAnswer
    }
    
    func buildQuestions(difficulty: String, numbeOfQuestions: Int) -> [Question] {
        var questions = [Question(x: 1, y: 1)]
        return questions
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
