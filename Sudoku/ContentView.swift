//
//  ContentView.swift
//  Sudoku
//
//  Created by Juanma on 5/3/24.
//

import SwiftUI

struct ContentView: View {
    
    @State var matriz = [[Int?]] (repeating: [Int?] (repeating: 0, count: 9),count: 9)
    @State var board = [[Int?]] (repeating: [Int?] (repeating: 0, count: 9), count: 9)
    @State var selectedColumn = 0
    @State var selectedRow = 0
    @State var selectedFlag = false
    @State var mistakes = 0
    @State var dificult = 0.5
    @State var defaultCellColor = Color.white
    @State var maxMistakes = false
    
    var body: some View {
        VStack {
            
            Text ("New game")
                .onTapGesture{
                    resetParams(matriz: &matriz, board: &board, selectedRow: &selectedRow, selectedColumn: &selectedColumn, selectedFlag: &selectedFlag, mistakes: &mistakes, defaultCellColor: &defaultCellColor)
                    newGame(matriz: &matriz, board: &board, dificult: dificult)
                }
                .font(.system(size: 30, weight: .semibold))
            
            HStack {
                
                Text ("errors: \(mistakes) / 3")
                
                Divider().fixedSize().padding()
                
                Text("dificult: \(dificult, specifier: "%.1f")")
                
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
                            validateInput(matriz: &matriz, board: &board, selectedColumn: selectedColumn, selectedRow: selectedRow, selectedFlag: selectedFlag, input: number.self, mistakes: &mistakes, maxMistakes: &maxMistakes)
                        }
                        .alert(isPresented: $maxMistakes, content: {
                            Alert(title: Text("Has perdido"))
                        })
                }
            }
            
            Spacer()
            
        }
        .padding()
        .preferredColorScheme(.light)
    }
}

#Preview {
    ContentView()
}

