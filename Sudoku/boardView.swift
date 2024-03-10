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
                                anyCellSelected(selectedFlag: &selectedFlag, selectedColumn: &selectedColumn, selectedRow: &selectedRow, newSelectedColumn: column.self, newSelectedRow: row.self)
                            }
                            .background(changeSelectedCellsColor(row: row.self, column: column.self, selectedFlag: selectedFlag, selectedRow: selectedRow, selectedColumn: selectedColumn, defaultCellColor: defaultCellColor))
                            
                    }
                }
            }
        }           
    }
}
