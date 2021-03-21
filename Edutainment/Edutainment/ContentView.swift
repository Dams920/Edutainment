//
//  ContentView.swift
//  Edutainment
//
//  Created by Damien Chailloleau on 16/03/2021.
//

import SwiftUI

struct ContentView: View {
    @State private var tableChoice = 1.0
    @State private var tableArray: [Int] = []
    @State private var nominatorSelected = 0
    
    @State private var inSettings = false
    @State private var inGame = false
    @State private var showAlert = false
    
    @State private var denominatorSelected = 0
    let commonDenominator = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    
    @State private var questionAnswer = ""
    @State private var score = 0
    
    @State private var questionCounter = 1
    @State private var questionNumber = 0
    var questionsChoice = [0, 5, 10, 20, 40]
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("Edutainment")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                    .aspectRatio(contentMode: .fill)
                VStack {
                    Group {
                        if !inGame {
                            // MARK: - Multiply Table
                            Section(header: TextView(texts: "Choose your multiplication Table", colors: .white, sizes: 25)
                            ) {
                                ZStack {
                                    RectangleStyleView(width: 400, height: 60, colorOne: .blue, colorTwo: .white, radius: 10)
                                    VStack {
                                        Stepper(value: $tableChoice, in: 1...12) {
                                            Text("Multiplication Table of \(tableChoice, specifier: "%g")")
                                        }
                                        .padding()
                                    }
                                }
                            }
                            HStack {
                                if tableArray.count == 0 {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.red)
                                    TextView(texts: "No tables have been choosed", colors: .red, sizes: 24)
                                } else if tableArray.count == 1 {
                                    TextView(texts: "\(tableArray.count) table have been choosed", colors: .white, sizes: 24)
                                } else if tableArray.count < 3 {
                                    TextView(texts: "\(tableArray.count) tables have been choosed", colors: .white, sizes: 24)
                                } else {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                    TextView(texts: "\(tableArray.count) tables have been choosed", colors: .green, sizes: 24)
                                }
                            }
                            // MARK: - Add & Reset
                            HStack {
                                Button(action: {
                                    tableArray.append(Int(Double(tableChoice)))
                                }) {
                                    ZStack {
                                        RectangleStyleView(width: 150, height: 50, colorOne: .blue, colorTwo: .yellow, radius: 10)
                                        VStack {
                                            Text("Add")
                                                .foregroundColor(.white)
                                                .font(.title)
                                        }
                                    }
                                }
                                Button(action: {
                                    tableArray.removeAll()
                                }) {
                                    ZStack {
                                        RectangleStyleView(width: 150, height: 50, colorOne: .blue, colorTwo: .red, radius: 10)
                                        VStack {
                                            Text("Reset")
                                                .foregroundColor(.white)
                                                .font(.title)
                                        }
                                    }
                                }
                            }
                            Spacer()
                            
                            // MARK: - N° Questions
                            Section(header: TextView(texts: "How many questions do you want ?", colors: .white, sizes: 25)
                            ) {
                                ZStack {
                                    RectangleStyleView(width: 400, height: 60, colorOne: .blue, colorTwo: .white, radius: 10)
                                    VStack {
                                        Picker("", selection: $questionNumber) {
                                            ForEach(0 ..< questionsChoice.count) {
                                                Text("\(self.questionsChoice[$0])")
                                            }
                                        }
                                        .pickerStyle(SegmentedPickerStyle())
                                        .padding()
                                    }
                                }
                            }
                            Spacer()
                            HStack {
                                if questionsChoice[questionNumber] == questionsChoice[0] {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.red)
                                    TextView(texts: "No questions generated", colors: .red, sizes: 24)
                                } else {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                    TextView(texts: "\(questionsChoice[questionNumber]) questions generated", colors: .green, sizes: 24)
                                }
                            }
                            // MARK: - Play
                            Section {
                                Button(action: {
                                    self.startGame()
                                }) {
                                    ZStack {
                                        RectangleStyleView(width: 150, height: 50, colorOne: .blue, colorTwo: .green, radius: 10)
                                        VStack {
                                            Text("Play")
                                                .foregroundColor(.white)
                                                .font(.title)
                                        }
                                    }
                                }
                                .disabled(canIPlay())
                                Spacer()
                            }
                        }
                    }
                    // MARK: - IG Layout
                    if inGame {
                        let nominator = tableArray.shuffled()[nominatorSelected]
                        let denominator = commonDenominator.shuffled()[denominatorSelected]
                        let result = nominator * denominator
                        VStack {
                            Text("Question N° \(questionCounter)")
                                .foregroundColor(.white)
                                .font(.headline)
                            Form {
                                Text("What is : \(nominator) x \(denominator)")
                                HStack {
                                    TextField("Put your answer", text: $questionAnswer)
                                        .keyboardType(.numberPad)
                                }
                                Button(action: {
                                    if questionCounter < questionsChoice[questionNumber] {
                                        questionCounter += 1
                                    } else {
                                        showAlert = true
                                    }
                                    checkProduct(result: result)
                                }) {
                                    Text("Submit")
                                        .font(.title2)
                                        .foregroundColor(.blue)
                                        .frame(alignment: .center)
                                }
                            }
                        }
                        Button(action: {
                            self.endGame()
                        }) {
                            ZStack {
                                RectangleStyleView(width: 150, height: 50, colorOne: .blue, colorTwo: .purple, radius: 10)
                                VStack {
                                    Text("Restart")
                                        .foregroundColor(.white)
                                        .font(.title)
                                }
                            }
                        }
                    }
                    
                 // MARK: - App Title
                }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Result"), message: Text("Your Score : \(score) / \(questionsChoice[questionNumber])"), dismissButton: .default(Text("Continue")) {
                        self.endGame()
                    })
                }
                .navigationTitle("Edutainment")
                .padding()
            }
        }
    }
    
// MARK: - Functions
    func canIPlay() -> Bool {
        if questionsChoice[questionNumber] != questionsChoice[0] && tableArray.count > 2 {
            return inSettings == true
        } else {
            return inSettings == false
        }
    }
    
    func checkProduct(result: Int) {
        if result == Int(questionAnswer) {
            score += 1
        } else {
            score += 0
        }
    }
    
    func startGame() {
        inGame = true
    }
    
    func endGame() {
        tableArray.removeAll()
        inGame = false
    }
    
}

// MARK: - ContentPreview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
