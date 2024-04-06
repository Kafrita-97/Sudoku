//
//  ContentView.swift
//  Sudoku
//
//  Created by Juanma on 5/3/24.
//

import SwiftUI

struct ContentView: View {
    
    //    let screenWidth = UIScreen.main.bounds.width
    
    //    let columns = [
    //        GridItem(),
    //        GridItem(),
    //        GridItem(),
    //        GridItem(),
    //        GridItem(),
    //        GridItem(),
    //        GridItem(),
    //        GridItem(),
    //        GridItem()
    //    ]
    
    @State var solvedBoard = [[String?]] (repeating: [String?] (repeating: " ", count: 9),count: 9)
    @State var board = [[String?]] (repeating: [String?] (repeating: " ", count: 9), count: 9)
    
    //
    //    @State var uniArraySolvedBoard = [String?] (repeating: " ", count: 81)
    //    @State var uniArrayBoard = [String?] (repeating: " ", count: 81)
    //
    
    @State var selectedColumn = 0
    @State var selectedRow = 0
    @State var selectedFlag = false
    
    @State var mistakes = 0
    @State var dificult: dificultLevel?
    
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
    
    enum dificultLevel {
        
        case facil
        case normal
        case dificil
        
        var id: Double {
            
            switch self {
                
            case .facil:
                return 0.3
                
            case .normal:
                return 0.5
                
            case .dificil:
                return 0.7
            }
        }
    }
    
    var body: some View {
        
        VStack {
            
            HStack {
                
                VStack {
                    
                    Button("Nuevo juego") {
                        newGame()
                    }
                    .font(.system(size: 31, weight: .semibold))
                    .foregroundColor(.black)
                    .buttonStyle(.bordered)
                    
                    Menu("Dificultad: \(dificult ?? .normal)") {
                        
                        Button("Facil") {dificult = .facil}
                        Button("Normal") {dificult = .normal}
                        Button("Dificil") {dificult = .dificil}
                    }
                    .font(.system(size: 25, weight: .light))
                    .foregroundColor(.black)
                    .padding(.top, 8)
                }
                .frame(width: 250, height: 80, alignment: .leading)
                
                VStack() {
                    
                    GroupBox() {
                        
                        Text("Tiempo: \(formatedCurrentTime())")
                            .padding(.bottom, 6.0)
                            .frame(width: 130, alignment: .center)
                        
                        Divider()
                            .frame(width: 130.0)
                        
                        Text ("Fallos: \(mistakes) / 3")
                            .padding(.top, 6.0)
                            .frame(width: 130.0, alignment: .center)
                    }
                    .frame(width: 130, height: 80, alignment: .trailing)
                }
            }
            
            Spacer()
            
            //            ya tengo el grid ok, solo queda reimplementar toda la logica
            //            LazyVGrid(columns: columns, spacing: -1) {
            //
            //                ForEach (0..<81) { i in
            //                    Text("\(uniArrayBoard[i] ?? " ")")
            //                        .onTapGesture {
            //                            print(i.self)
            //                        }
            //                }
            //                .frame(width:screenWidth/9, height: screenWidth/9)
            //                .border(Color.black)
            //
            //            }
            
            boardView(board: $board, selectedColumn: $selectedColumn, selectedRow: $selectedRow, selectedFlag: $selectedFlag, gameIsRunning: $gameIsRunning)
            
            Spacer()
            
            HStack {
                
                ForEach (1..<10) { number in
                    
                    Button("\(number)") {
                        validateInput(input: number.self)
                    }
                    .font(.system(size: 30))
                    .foregroundColor(.black)
                    .frame(width: 37, height:60)
                    .background(Color(red: 233/255, green: 233/255, blue: 235/255))
                    .cornerRadius(7)
                }
            }
            
            Spacer()
        }
        .padding()
        .preferredColorScheme(.light)
        .alert(item: $gameAlertState) { state in
            switch state {
            case .lost:
                return Alert(title: Text("Has perdido"))
            case .win:
                return Alert(title: Text("Has ganado"))
            }
        }
    }
    
    //provisonal para pasar el array 2d a 1d hasta rediseñar la logica
    //    func biArrayToUniArray(biArray: [[String?]], uniArray: inout [String?]) {
    //
    //        var index = 0
    //        for fila in biArray {
    //            for elemento in fila {
    //                uniArray.insert(elemento ?? " ", at: index)
    //                index += 1
    //            }
    //        }
    //        print(uniArray)
    //        print(uniArray.count)
    //    }
    //
    
    func newGame() -> Void {
        
        stopTimer()
        
        resetParams()
        
        createSolvedBoard()
        
        hideCells()
        
        //        biArrayToUniArray(biArray: board, uniArray: &uniArrayBoard)
        
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
        //        uniArraySolvedBoard = [String] ()
        //        uniArrayBoard = [String] ()
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
        
        while cellsHidden < (totalCells * (dificult?.id ?? 0.5) - 1) {
            
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
