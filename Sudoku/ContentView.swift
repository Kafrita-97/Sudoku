//
//  ContentView.swift
//  Sudoku
//
//  Created by Juanma on 5/3/24.
//

import SwiftUI

struct ContentView: View {
    
    @State var solvedBoard = [[Int?]] (repeating: [Int?] (repeating: 0, count: 9),count: 9)
    @State var board = [[Int?]] (repeating: [Int?] (repeating: 0, count: 9), count: 9)
    @State var selectedColumn = 0
    @State var selectedRow = 0
    @State var selectedFlag = false
    @State var mistakes = 0
    @State var dificult = 0.5
    @State var gameLosted = false
    @State var gameSolved = false
    @State var defaultCellColor = Color.white
    @State var timer: Timer?
    @State var startTime: Date?
    @State var currentGameTime: Int?
    
    var body: some View {
        
        VStack {
            
            HStack {
                
                Text ("Nuevo juego")
                    .onTapGesture{
                        newGame()
                    }
                .font(.system(size: 30, weight: .semibold))
                
                Spacer()
                
                Text("Dificultad: \(dificult, specifier: "%.1f")")
            }
            
            HStack {
                
                Text("Tiempo: \(formatedCurrentTime())")
                
                Divider().fixedSize()
                
                Text ("Fallos: \(mistakes) / 3")
                
                Stepper("", value: $dificult, in: 0.1...0.9, step: 0.1)
            }
            
            Spacer()
            
            boardView(board: $board, selectedColumn: $selectedColumn, selectedRow: $selectedRow, selectedFlag: $selectedFlag, defaultCellColor: $defaultCellColor)
            
            Spacer()
            
            HStack {
                
                ForEach (1..<10) { number in
                    
                    Text ("\(number)")
                        .frame(width: 35, height: 55)
                        .border(Color.black)
                        .font(.system(size: 30, weight: .semibold))
                        .onTapGesture {
                            validateInput(input: number.self)
                        }
                        .alert(isPresented: $gameLosted, content: {
                            Alert(title: Text("Has perdido"))
                            
                        })
                        .alert(isPresented: $gameSolved, content: {
                            Alert(title: Text("Has ganado"))
                        })
                }
            }
            
            Spacer()
            
        }
        .padding()
        .preferredColorScheme(.light)
    }
    
    private func resetParams() -> Void {
        
        solvedBoard = [[Int?]] (repeating: [Int?] (repeating: 0, count: 9),count: 9)
        board = [[Int?]] (repeating: [Int?] (repeating: 0, count: 9), count: 9)
        selectedColumn = 0
        selectedRow = 0
        selectedFlag = false
        mistakes = 0
        gameLosted = false
        gameSolved = false
        defaultCellColor = .white
    }
    
    func newGame() -> Void {
        
        stopTimer()
        
        resetParams()
        
        createSolvedBoard()
        
        hideCells()
        
        startTimer()
    }
    
    private func createSolvedBoard() -> Bool{
        
        let numRamdomOrder = Array(1...9).shuffled()
        
        for row in 0..<9 {
            
            for column in 0..<9 {
                
                if solvedBoard[row][column] == 0 {
                    
                    for randomNum in numRamdomOrder {
                        
                        if validateNum(row: row, column: column, num: randomNum ) {
                            
                            solvedBoard[row][column] = randomNum
                            
                            if createSolvedBoard() {
                                
                                return true
                                
                            } else {
                                
                                solvedBoard[row][column] = 0
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
            
            if solvedBoard[i][column] == num || solvedBoard[row][i] == num {
                return false
            }
        }
        
        for i in 0..<3 {
            
            for j in 0..<3 {
                
                if solvedBoard[i + startRow][j + startCol] == num {
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
            
            if board[randomRow][randomColumn] == 0 {
                
                continue
                
            } else {
                
                board[randomRow][randomColumn] = 0
                cellsHidden += 1
            }
        }
    }
    
    func validateInput(input: Int) -> Void {
        
        if selectedFlag && mistakes < 3 {
            
            if solvedBoard [selectedRow][selectedColumn] == input {
                
                board [selectedRow][selectedColumn] = input
                
            } else {
                
                mistakes += 1
                
                if mistakes == 3 {
                    
                    gameLosted = true
                    
                    stopTimer()
                }
            }
        }
        
        isSolved()
    }
    
    private func isSolved() -> Void {
        
        if solvedBoard == board {
            
            gameSolved = true
            
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

