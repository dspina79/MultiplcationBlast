//
//  ContentView.swift
//  MultiplicationBlast
//
//  Created by Dave Spina on 12/5/20.
//

import SwiftUI


struct QuestionView: View {
    var question: Question
    var body: some View {
        HStack {
            BigSystemImage(systemImageName: "\(question.x).square")
            BigSystemImage(systemImageName: "multiply")
            BigSystemImage(systemImageName: "\(question.y).square")
            BigSystemImage(systemImageName: "equal")
        }
    }
}

struct BigSystemImage: View {
    var systemImageName: String
    
    var body: some View {
        Image(systemName: systemImageName)
            .font(.system(size: 60))
    }
}

struct GameButton : ViewModifier {
    var width: CGFloat
    func body(content: Content) -> some View {
        content
            .frame(width: self.width, height: 50, alignment: .center)
                .background(RadialGradient(gradient: Gradient(colors: [Color.blue, Color.gray]), center: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, startRadius: 2, endRadius: width))
                .foregroundColor(.white)
                .clipShape(Capsule())
    }
}

extension View {
    func gameButton(_ width: CGFloat) -> some View {
        self.modifier(GameButton(width: width))
    }
}

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
    let difficultyLevels = ["Easy", "Medium", "Hard"]
    @State private var userName = ""
    @State private var difficultyLevel = "Medium"
    
    @State private var currentScore: Int = 0
    @State private var currentAnswer: Int = -1;
    @State private var currentQuestionIndex = 0
    @State private var questionList: [Question] = [Question]()

    @State private var showInit: Bool = true
    @State private var showMain: Bool = false
    @State private var showScorePage: Bool = false
    
    @State private var initColors = [Color]()
    @State private var gameplayColors = [Color.blue, Color.blue, Color.white]
    @State private var incorrectAnwerColors = [Color.red, Color.orange]
    @State private var currentGameplayColors = [Color]()
    
    var currentQuestion: Question {
        if let q = try? questionList[currentQuestionIndex] {
            return q
        } else {
        return Question(x: 1, y: 0)
        }
    }
    
    var body: some View {
        VStack {
            ZStack {
                LinearGradient(gradient: Gradient(colors: initColors), startPoint: .top, endPoint: .bottom)
                VStack {
                    Text("Multiplication Blast")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Spacer()
                }
            if showInit {
                ZStack {
                    VStack(spacing: 20) {
                        Section(header: Text("Enter your name")) {
                            TextField("Name", text: $userName)
                                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                                .background(Color.white)
                                .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                                .clipShape(RoundedRectangle(cornerRadius: 1))
                            Section(header: Text("Select the level of difficulty")) {
                                Picker("Select Difficulty", selection: $difficultyLevel) {
                                    ForEach(difficultyLevels, id: \.self) { lvl in
                                        Text("\(lvl)")
                                    }
                                }
                            }
                            
                            Button("Start") {
                                withAnimation {
                                    beginGame()
                                }
                            }
                            .gameButton(100)
                            .animation(.easeOut(duration: 2))
                        }
                            
                    }.frame(width: 300, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                }.onAppear {
                    initialize()
                }
            } else if showMain {
                    VStack {
                        Text("Hello, \(self.userName)")
                            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        Text("Difficulty Level: \(self.difficultyLevel)")
                            .font(.subheadline)
                        
                        QuestionView(question: self.currentQuestion)
                        HStack {
                            Button("Next") {
                                nextQuestion()
                            }.gameButton(90)
                            Button("New Game"){
                                self.showInit = true
                            }
                            .gameButton(150)
                        }
                    }
                
            } else if showScorePage {
                    VStack {
                        Text("On on score")
                        
                    }
                
            } else {
                VStack {
                    Text("On default")
                }
            }
        }
        }.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
    }
    
    func checkAnswer() -> Bool {
        return currentQuestion.answer == currentAnswer
    }
    
    func initialize() {
        self.currentGameplayColors = self.gameplayColors
        self.initColors = self.gameplayColors
    }
    
    func beginGame() {
        self.showInit = false
        self.showMain = true
        
        self.currentGameplayColors = self.gameplayColors
        // TODO: Figure out whether we need the number of questions
        buildQuestions(difficulty: self.difficultyLevel, numbeOfQuestions: 10)
    }
    
    func nextQuestion() {
        self.currentQuestionIndex += 1
    }
    
    func buildQuestions(difficulty: String, numbeOfQuestions: Int) {
        var questions = [Question]()
        var range = 0...1
        switch difficulty.lowercased() {
        case "easy" :
            range = 1...5
        case "medium":
            range = 1...10
        case "hard":
            range = 1...12
        default:
            range = 1...10
        }
        
        for x in range {
            for y in range {
                let q = Question(x: x, y: y)
                questions.append(q)
            }
        }
        self.questionList = questions.shuffled()
        self.currentQuestionIndex = 0
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
