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
    
    var body: some View {
        
        VStack (spacing: -1) {
            
            ForEach(0..<9) { row in
                
                HStack (spacing: -1) {
                    
                    ForEach (0..<9) { column in
                        
                        Text (String(board [row][column] ?? 0))
                            .frame(width: 43, height: 45)
                            .border (Color .black)
                            .font(.system(size: 20, weight: .semibold))
                            .onTapGesture {
                                anyCellSelected(selectedFlag: &selectedFlag, selectedColumn: &selectedColumn, selectedRow: &selectedRow, newSelectedColumn: column.self, newSelectedRow: row.self)
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
        
    }
}
