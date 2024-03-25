//
//  ContentView.swift
//  Sudoku
//
//  Created by Juanma on 5/3/24.
//

import SwiftUI

struct ContentView: View {
    
    @State var solvedBoard = [[String?]] (repeating: [String?] (repeating: " ", count: 9),count: 9)
    @State var board = [[String?]] (repeating: [String?] (repeating: " ", count: 9), count: 9)
    
    @State var selectedColumn = 0
    @State var selectedRow = 0
    @State var selectedFlag = false
   
    @State var mistakes = 0
    @State var dificult = 0.5
   
    @State var gameAlertState: alertStatus?
    @State var gameIsRunning = false
    
    @State var timer: Timer?
    @State var startTime: Date?
    @State var currentGameTime: Int?
    
    enum alertStatus: Identifiable {
        
        case lost
        case win
        
        var id: Int {
           
            switch self {
           
            case .lost:
                return 0
           
            case .win:
                return 1
            }
        }
    }

    var body: some View {
        
        VStack {
            
            HStack {
                
                
                VStack() {
                    
                    Text("Tiempo: \(formatedCurrentTime())")
                        .padding([.leading, .bottom], 6.0)
                        .frame(width: 130.0, alignment: .leading)
                    
                    Divider()
                        .padding(.leading, 6.0)
                        .frame(width: 130.0)
                    
                    Text ("Fallos: \(mistakes) / 3")
                        .padding([.top, .leading], 6.0)
                        .frame(width: /*@START_MENU_TOKEN@*/130.0/*@END_MENU_TOKEN@*/, alignment: .leading)
                }
                .frame(width: 150, height: 80, alignment: .leading)
                
                VStack {
                    
                    Button("Nuevo juego") {
                        newGame()
                    }
                    .padding(.trailing, 6.0)
                    .font(.system(size: 33, weight: .semibold))
                    .foregroundColor(.black)
                    .buttonStyle(.bordered)
                    
                    Stepper("Dificultad: \(dificult, specifier: "%.1f")", value: $dificult, in: 0.1...0.9, step: 0.1)
                        .padding(.trailing, 6.0)
                        .frame(width: 215)
                }
                .frame(width: 250, height: 80, alignment: .trailing)
            }
            
            Spacer()
            
            boardView(board: $board, selectedColumn: $selectedColumn, selectedRow: $selectedRow, selectedFlag: $selectedFlag, gameIsRunning: $gameIsRunning)
            
            Spacer()
            
            HStack {
                
                ForEach (1..<10) { number in
                    
                    Text ("\(number)")
                        .frame(width: 37, height: 55)
                        .border(Color.black)
                        .font(.system(size: 30, weight: .semibold))
                        .onTapGesture {
                            validateInput(input: number.self)
                        }
                        .alert(item: $gameAlertState) { state in
                            switch state {
                            case .lost:
                                return Alert(title: Text("Has perdido"))
                            case .win:
                                return Alert(title: Text("Has ganado"))
                            }
                        }
                }
            }
            
            Spacer()
        }
        .padding()
        .preferredColorScheme(.light)
    }
    
    func newGame() -> Void {
        
        stopTimer()
        
        resetParams()
        
        createSolvedBoard()
        
        hideCells()
        
        startTimer()
        
        gameIsRunning = true
    }

    private func resetParams() -> Void {
        
        solvedBoard = [[String?]] (repeating: [String?] (repeating: " ", count: 9),count: 9)
        board = [[String?]] (repeating: [String?] (repeating: " ", count: 9), count: 9)
        selectedColumn = 0
        selectedRow = 0
        selectedFlag = false
        mistakes = 0
        gameIsRunning = false
    }
    
    private func createSolvedBoard() -> Bool{
        
        let numRamdomOrder = Array(1...9).shuffled()
        
        for row in 0..<9 {
            
            for column in 0..<9 {
                
                if solvedBoard[row][column] == " " {
                    
                    for randomNum in numRamdomOrder {
                        
                        if validateNum(row: row, column: column, num: randomNum ) {
                            
                            solvedBoard[row][column] = String(randomNum)
                            
                            if createSolvedBoard() {
                                
                                return true
                                
                            } else {
                                
                                solvedBoard[row][column] = " "
                            }
                        }
                    }
                    return false
                }
            }
        }
        return true
    }
    
    private func validateNum(row: Int, column: Int, num: Int) -> Bool{
        
        let startRow = row - row % 3
        let startCol = column - column % 3
        
        for i in 0..<9 {
            
            if solvedBoard[i][column] == String(num) || solvedBoard[row][i] == String(num) {
                return false
            }
        }
        
        for i in 0..<3 {
            
            for j in 0..<3 {
                
                if solvedBoard[i + startRow][j + startCol] == String(num) {
                    return false
                }
            }
        }
        return true
    }
    
    private func hideCells() -> Void {
        
        let totalCells = 81.0
        var cellsHidden = 0.0
        board = solvedBoard
        
        while cellsHidden < (totalCells * dificult - 1) {
            
            let randomRow = Int.random(in: 0...8)
            let randomColumn = Int.random(in: 0...8)
            
            if board[randomRow][randomColumn] == " " {
                
                continue
                
            } else {
                
                board[randomRow][randomColumn] = " "
                cellsHidden += 1
            }
        }
    }
    
    func validateInput(input: Int) -> Void {
        
        if selectedFlag && mistakes < 3 && gameIsRunning{
            
            if solvedBoard [selectedRow][selectedColumn] == String(input) {
                
                board [selectedRow][selectedColumn] = String(input)

                isSolved()
                
            } else {
                
                mistakes += 1
                
                if mistakes == 3 {
                    
                    gameIsRunning = false
                    gameAlertState = .lost
                    
                    stopTimer()
                }
            }
        }
    }
    
    private func isSolved() -> Void {
        
        if solvedBoard == board {
            
            gameAlertState = .win
            gameIsRunning = false
            
            stopTimer()
        }
    }
    
    private func startTimer() {
        
        startTime = Date()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            
            currentGameTime = Int(Date().timeIntervalSince(startTime!))
        }
    }
    
    private func stopTimer() {
        
        timer?.invalidate()
        timer = nil
    }
    
    func formatedCurrentTime() -> String {
        
        let totalSeconds = currentGameTime ?? 0
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        
        let formattedTime = String(format: "%02d:%02d", minutes, seconds)
        
        return formattedTime
    }
}

#Preview {
    ContentView()
}
