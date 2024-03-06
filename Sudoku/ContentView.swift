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
    @State var dificult = 0.1

    /*
     la estructura del array es tal que [[], [], [], [],...]
     primero se pintan las vert vstack y segundo dentro las hori hstack
     queda tal que matriz[row][column]
     
     */
    
    var body: some View {
        VStack {
            
            Text ("New game")
                .onTapGesture{
                    resetParams(matriz: &matriz, board: &board, selectedRow: &selectedRow, selectedColumn: &selectedColumn, selectedFlag: &selectedFlag, mistakes: &mistakes)
                    newGame(matriz: &matriz, board: &board, dificult: dificult)
                }
                .font(.system(size: 30, weight: .semibold))
            
            HStack {
                Divider().fixedSize().padding()
                Text ("errors: \(mistakes)")
                Divider().fixedSize().padding()
                Text("dificult: \(dificult, specifier: "%.1f")")
                Stepper("", value: $dificult, in: 0.1...0.9, step: 0.1)
            }
            
            
            Spacer()
            
            boardView(board: $board, selectedColumn: $selectedColumn, selectedRow: $selectedRow, selectedFlag: $selectedFlag)
            
            Spacer()

            HStack {
                ForEach (1..<10) { number in
                    Text ("\(number)")
                        .frame(width: 35, height: 50)
                        .border(Color.black)
                        .font(.system(size: 18, weight: .semibold))
                        .onTapGesture {
                            validateInput(matriz: &matriz, board: &board, selectedColumn: selectedColumn, selectedRow: selectedRow, selectedFlag: selectedFlag, input: number.self, mistakes: &mistakes)
                        }
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
