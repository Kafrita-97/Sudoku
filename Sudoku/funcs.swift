//
//  ContentView.swift
//  Sudoku
//
//  Created by Juanma on 5/3/24.
//

import Foundation

func fillButton(matriz: inout [[Int?]]) -> Bool{

//    print(numRamdomOrder)
    for row in 0..<9 {
        for column in 0..<9 {
            if matriz[row][column] == 0 {
                var numRamdomOrder: [Int?] = []
                while numRamdomOrder.count < 9 {
                    let n = Int.random(in: 1...9)
                    if !numRamdomOrder.contains(n) {
                        numRamdomOrder.append(n)
                    }
                }
                for jj in numRamdomOrder {
                    if validateNum(matriz: &matriz, row: row, column: column, num: jj ?? 0) {
                        matriz[row][column] = jj
                        //                        print("row/col: \(row),\(column) --- \(num)")
                        if fillButton(matriz: &matriz) {
                            return true
                        } else {
                            matriz[row][column] = 0
                        }
                        
                    }
                }
                return false
            }
        }
    }
    return true
}

func clearButton(matriz: inout [[Int?]]) -> Void {
    for row in 0..<9 {
        for column in 0..<9 {
            matriz[row][column] = 0
        }
    }
}

func validateNum(matriz: inout [[Int?]], row: Int, column: Int, num: Int) -> Bool{
    
    for i in 0..<9 {
        
        if matriz[i][column] == num || matriz[row][i] == num {
            return false
        }
    }
    
    let startRow = row - row % 3
    let startCol = column - column % 3
    for i in 0..<3 {
        for j in 0..<3 {
            if matriz[i + startRow][j + startCol] == num {
                return false
            }
        }
    }
    
    return true
}
