//
//  funcs.swift
//  Sudoku
//
//  Created by Juanma on 5/3/24.
//

import Foundation

func newGame(matriz: inout [[Int?]], board: inout [[Int?]], dificult: Double) -> Void {
    createSolvedSudoku(matriz: &matriz)
    hideCells(matriz: &matriz, board: &board, dificult: dificult)
}

func createSolvedSudoku(matriz: inout [[Int?]]) -> Bool{
    
    let numRamdomOrder = Array(1...9).shuffled()
    
    for row in 0..<9 {
        for column in 0..<9 {
            
            if matriz[row][column] == 0 {
                
                for randomNum in numRamdomOrder {
                    
                    if validateNum(matriz: &matriz, row: row, column: column, num: randomNum ) {
                        
                        matriz[row][column] = randomNum
                        //                        print("row/col: \(row),\(column) --- \(randomNum)")
                        if createSolvedSudoku(matriz: &matriz) {
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

func hideCells(matriz: inout [[Int?]], board: inout [[Int?]], dificult: Double) -> Void {
    let totalCells = 81.0
    var cellsHidden = 0.0
    board = matriz
    
    while cellsHidden < (totalCells * dificult - 1) {
        
        let randomRow = Int.random(in: 0...8)
        let randomColumn = Int.random(in: 0...8)
        
        if board[randomRow][randomColumn] == 0 {
            continue
        } else {
            board[randomRow][randomColumn] = 0
            cellsHidden += 1
        }
        //        print("\(totalCells*dificult) /// \(cellsHidden)")
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

func validateInput(matriz: inout [[Int?]], board: inout [[Int?]], selectedColumn: Int, selectedRow: Int, selectedFlag: Bool, input: Int, mistakes: inout Int) -> Void {
    
    if selectedFlag {
        if matriz [selectedRow][selectedColumn] == input {
            board [selectedRow][selectedColumn] = input
        } else {
            mistakes += 1
        }
    }
}

func resetParams(matriz: inout [[Int?]], board: inout [[Int?]],  selectedRow: inout Int, selectedColumn: inout Int, selectedFlag: inout Bool, mistakes: inout Int) -> Void {
    
    matriz = [[Int?]] (repeating: [Int?] (repeating: 0, count: 9),count: 9)
    board = [[Int?]] (repeating: [Int?] (repeating: 0, count: 9), count: 9)
    selectedColumn = 0
    selectedRow = 0
    selectedFlag = false
    mistakes = 0
}


func anyCellSelected(selectedFlag: inout Bool, selectedColumn: inout Int, selectedRow: inout Int, newSelectedColumn: Int, newSelectedRow: Int) -> Void {
    if selectedFlag && selectedColumn == newSelectedColumn && selectedRow == newSelectedRow {
        selectedColumn = 0
        selectedRow = 0
        selectedFlag = false
    } else {
        selectedColumn = newSelectedColumn
        selectedRow = newSelectedRow
        selectedFlag = true
    }
}
