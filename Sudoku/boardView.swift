//
//  boardView.swift
//  Sudoku
//
//  Created by Juanma on 6/3/24.
//

import SwiftUI

struct boardView: View {
    
    @Binding var board: [[Int?]]
    @Binding var selectedColumn: Int
    @Binding var selectedRow: Int
    @Binding var selectedFlag: Bool
    @Binding var defaultCellColor: Color
    
    var body: some View {
        
        VStack (spacing: -1) {
            
            ForEach(0..<9) { row in
                
                HStack (spacing: -1) {
                    
                    ForEach (0..<9) { column in
                        
                        Text (String(board [row][column] ?? 0))
                            .frame(width: 45, height: 50)
                            .border (Color .black)
                            .font(.system(size: 25, weight: .semibold))
                            .onTapGesture {
                                anyCellSelected(newSelectedRow: row.self, newSelectedColumn: column.self)
                            }
                            .background(changeSelectedCellsColor(row: row.self, column: column.self))
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
        
        if selectedFlag {
            
            if row == selectedRow || column == selectedColumn{
                
                return .gray
                
            } else if defineSelectedBlock(row: row, column: column) {
                
                return .gray
                
            } else {
                
                return defaultCellColor
            }
        }
        
        return defaultCellColor
    }
    
    private func defineSelectedBlock(row: Int, column: Int) -> Bool {
        
        let blockStartRow = selectedRow / 3 * 3
        let blockStartColumn = selectedColumn / 3 * 3
        
        return row >= blockStartRow && row < blockStartRow + 3 && column >= blockStartColumn && column < blockStartColumn + 3
    }
    
}
