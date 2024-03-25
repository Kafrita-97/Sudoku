//
//  boardView.swift
//  Sudoku
//
//  Created by Juanma on 6/3/24.
//

import SwiftUI

struct boardView: View {
    
    @Binding var board: [[String?]]
    
    @Binding var selectedColumn: Int
    @Binding var selectedRow: Int
    @Binding var selectedFlag: Bool
    
    @Binding var gameIsRunning: Bool
    
    let customColorLight = Color(red: 190/255, green: 190/255, blue: 190/255)
    let customColorDark = Color(red: 130/255, green: 130/255, blue: 130/255)
    
    var body: some View {
        
        VStack (spacing: -1) {
            
            ForEach(0..<9) { row in
                
                HStack (spacing: -1) {
                    
                    ForEach (0..<9) { column in
                        
                        Text (board [row][column] ?? " ")
                            .font(.system(size: 25, weight: .semibold))
                            .frame(width: 45, height: 50)
                            .border (Color .black)
                            .background(changeSelectedCellsColor(row: row.self, column: column.self))
                            .onTapGesture {
                                anyCellSelected(newSelectedRow: row.self, newSelectedColumn: column.self)
                            }
                    }
                }
            }
        }
    }
    
    func anyCellSelected(newSelectedRow: Int, newSelectedColumn: Int) -> Void {
        
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
    
    func changeSelectedCellsColor(row: Int, column: Int) -> Color {
        
        if selectedFlag && gameIsRunning {
            
            if row == selectedRow && column == selectedColumn {
                
                return customColorDark
                
            } else if row == selectedRow || column == selectedColumn {
                
                return customColorLight
            
            } else if defineSelectedBlock(row: row, column: column) {
                
                return customColorLight
                
            } else {
                
                return .white
            }
        }
        return .white
    }
    
    private func defineSelectedBlock(row: Int, column: Int) -> Bool {
        
        let blockStartRow = selectedRow / 3 * 3
        let blockStartColumn = selectedColumn / 3 * 3
        
        return row >= blockStartRow && row < blockStartRow + 3 && column >= blockStartColumn && column < blockStartColumn + 3
    }

}
