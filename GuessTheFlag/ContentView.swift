//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by paucrow on 11/07/2022.
//

import SwiftUI

struct FlagImage: View {
    var text: String

        var body: some View {
            Image(text)
                .renderingMode(.original)
                .clipShape(Capsule())
                .shadow(radius: 5)
        }
}

struct ContentView: View {
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var incorrectFlag = 0
    @State private var tapsLeft = 8
    @State private var gameOver = false
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)

    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)

            ], center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()
            VStack {
                Spacer()
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }

                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            FlagImage(text: countries[number])
//                            Image(countries[number])
//                                .renderingMode(.original)
//                                .clipShape(Capsule())
//                                .shadow(radius: 5)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))

                Spacer()
                Spacer()

                Text("Score: \(score)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                Text("Taps left: \(tapsLeft)")
                    .foregroundColor(.white)
                    .font(.subheadline.bold())
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            scoreTitle == "Correct" ?
            Text("Your score is \(score)") :
            Text("Wrong! That’s the flag of \(countries[incorrectFlag])")
        }
        .alert("Game Over", isPresented: $gameOver) {
            Button("New Game", action: newGame)
        } message: {
            Text("You final score was \(score)")
        }
    }

    func flagTapped(_ number: Int) {

        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
        } else {
            scoreTitle = "Wrong"
            incorrectFlag = number
        }
        showingScore = true
        
        tapsLeft -= 1
        if tapsLeft <= 0 {
            gameOver = true
        }
    }

    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }

    func newGame() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        score = 0
        tapsLeft = 8
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.portrait)
    }
}
