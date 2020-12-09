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

struct CircleNumber: View {
    var value: Int
    var body: some View {
        ZStack {
            Image(systemName: "circle.fill")
                .foregroundColor(.white)
                .scaleEffect(CGSize(width: 4.0, height: 4.0))
            Text("\(value)")
                .fontWeight(.bold)
                .font(.system(size: 30))
                .foregroundColor(.black)
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
    
    @State private var answersCorrect: Int = 0
    @State private var totalQuestionsAnswered: Int = 0
    
    @State private var currentAnswer: Int = -1;
    @State private var currentQuestionIndex = 0
    @State private var questionList: [Question] = [Question]()
    @State private var currentPossibleAnswers: [Int] = [Int]()
    @State private var currentResponse = ""

    @State private var showInit: Bool = true
    @State private var showMain: Bool = false
    @State private var showScorePage: Bool = false
    @State private var showAnswerDisplay: Bool = true
    
    @State private var initColors = [Color]()
    @State private var gameplayColors = [Color.blue, Color.blue, Color.white]
    @State private var incorrectAnswerColors = [Color.red, Color.orange]
    @State private var correctAnswerColors = [Color.yellow, Color.yellow, Color.white]
    @State private var currentGameplayColors = [Color]()
    @State private var explicitAnimationAmount = 0.0
    
    var score: Double {
        if totalQuestionsAnswered == 0 {
            return Double(0)
        } else {
            return (Double(answersCorrect) / Double(totalQuestionsAnswered)) * 100.0
        }
    }
    
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
                LinearGradient(gradient: Gradient(colors: currentGameplayColors), startPoint: .top, endPoint: .bottom)
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
                                .padding(/*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                                .background(Color.white)
                                .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
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
                VStack(alignment: .center, spacing: CGFloat(20)) {
                    Spacer()
                        Text("Hello, \(self.userName)")
                            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        Text("Difficulty Level: \(self.difficultyLevel)")
                            .font(.subheadline)
                        
                        QuestionView(question: self.currentQuestion)
                        
                    if showAnswerDisplay {
                        Spacer()
                        HStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: CGFloat(70)){
                            ForEach (currentPossibleAnswers, id: \.self) { ans in
                                Button(action: {
                                    withAnimation(.easeIn) {
                                        renderCheck(ans: ans)
                                    }
                                }) {
                                    CircleNumber(value: ans)
                                }
                                .rotation3DEffect(
                                    .degrees(ans == self.currentQuestion.answer ? explicitAnimationAmount : 0),
                                        axis: (x: 0.0, y: 1.0, z: 0.0)
                                )
                            }
                            
                        }
                    }
                        Text(self.currentResponse)
                            .font(.title2)
                    
                        Spacer()
                        HStack {
                            Button("Next") {
                                nextQuestion()
                            }
                            .gameButton(90)
                            
                            Button("End Game"){
                                endGame()
                            }
                            .gameButton(150)
                        }
                    }
                
            } else if showScorePage {
                    VStack () {
                        Text("Your game score:")
                            .font(.title)
                        Text("\(self.score, specifier: "%.0f")%")
                            .font(.largeTitle)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .animation(.easeIn)
                        
                        Spacer()
                        Button("New Game"){
                            self.showInit = true
                        }
                        .gameButton(150)
                        
                    }.onAppear {
                        self.currentGameplayColors = self.score > 70.0 ? correctAnswerColors : incorrectAnswerColors
                    }
                
            } else {
                VStack {
                    Text("On default")
                }
            }
        }
        }
    }
    
    func renderCheck(ans: Int) {
        self.totalQuestionsAnswered += 1
        if ans == currentQuestion.answer {
            self.answersCorrect += 1
            self.explicitAnimationAmount += 360.0
            self.currentResponse = self.goodAnswerResponses[Int.random(in: 0..<self.goodAnswerResponses.count)]
            self.currentGameplayColors = correctAnswerColors
        } else {
            self.currentResponse = "\(self.badAnswerResponses[Int.random(in: 0..<self.badAnswerResponses.count)]) the correct answer is \(currentQuestion.answer)."
            self.currentGameplayColors = self.incorrectAnswerColors
        }
        self.showAnswerDisplay = false
    }
    
    func getPossibleAnswers() -> [Int] {
        var possibleValues = [Int]()
        print("In the possible answers")
        possibleValues.append(self.currentQuestion.answer)
        while possibleValues.count < 3 {
            let randomNumber1 = Int.random(in: 0...self.currentQuestion.y)
            let randomNumber2 = Int.random(in: 0...self.currentQuestion.x)
            
            let randomProduct = randomNumber1 * randomNumber2
            
            if !possibleValues.contains(randomProduct) {
                possibleValues.append(randomProduct)
            }
        }
        
        return possibleValues.shuffled()
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
        self.currentPossibleAnswers = getPossibleAnswers()
    }
    
    func endGame() {
        self.showInit = false
        self.showMain = false
        self.showScorePage = true
    }
    
    func nextQuestion() {
        self.currentQuestionIndex += 1
        self.currentPossibleAnswers = getPossibleAnswers()
        self.currentResponse = ""
        self.showAnswerDisplay = true
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
        
        print("Building questions")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
