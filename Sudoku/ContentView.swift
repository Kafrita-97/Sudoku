//
//  ContentView.swift
//  Sudoku
//
//  Created by Juanma on 5/3/24.
//

import SwiftUI

struct ContentView: View {
    
    @State var matriz = [[Int?]] (repeating: [Int?] (repeating: 0, count: 9),count: 9)
    @State var selectedColumn = 0
    @State var selectedRow = 0
    @State var selectedFlag = false
    
    /*
     la estructura del array es tal que [[], [], [], [],...]
     primero se pintan las vert vstack y segundo dentro las hori hstack
     queda tal que matriz[row][column]
     
     */
    
    var body: some View {
        VStack {
            
            HStack {
                Text("dificult")
                Divider().fixedSize().padding()
                Text ("errors")
                Divider().fixedSize().padding()
                Text ("score")
                Divider().fixedSize().padding()
                Text ("time")
            }
            
            Spacer()
            
            VStack (spacing: -1) {
                ForEach(0..<9) { row in
                    HStack (spacing: -1) {
                        ForEach (0..<9) { column in
                            Text (String(matriz [row][column] ?? 0))
                                .frame(width: 43, height: 45)
                                .border (Color .black)
                                .font(.system(size: 20, weight: .semibold))
                                .onTapGesture {
                                    if selectedFlag && selectedColumn == column.self && selectedRow == row.self {
                                        selectedColumn = 0
                                        selectedRow = 0
                                        selectedFlag = false
                                    } else {
                                        selectedColumn = column.self
                                        selectedRow = row.self
                                        selectedFlag = true
                                    }
                                }
                        }
                    }
                }
            }
            
            if selectedFlag {
                Text ("selected: \(selectedRow), \(selectedColumn)")
            } else {
                Text("selected: nothing")
            }
            
            Spacer()
            
            HStack {
                Text ("Fill")
                    .onTapGesture {
                        fillButton(matriz: &matriz)
                    }
                Divider().fixedSize().padding()
                Text ("Clear")
                    .onTapGesture{
                        clearButton(matriz: &matriz)
                    }
                Divider().fixedSize().padding()
                Text ("tool 3")
                Divider().fixedSize().padding()
                Text ("tool 4")
            }
            .font(.system(size: 18, weight: .semibold))
            .padding()
            
            HStack {
                ForEach (1..<10) { number in
                    Text ("\(number)")
                        .frame(width: 35, height: 50)
                        .border(Color.black)
                        .font(.system(size: 18, weight: .semibold))
                        .onTapGesture {
                            if selectedFlag {
                                matriz [selectedRow][selectedColumn] = number.self
                                
                            }
                        }
                }
            }
            
            Spacer()
            
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
