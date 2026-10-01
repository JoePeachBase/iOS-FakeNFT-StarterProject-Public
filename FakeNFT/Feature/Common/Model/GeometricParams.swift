//
//  GeometricParams.swift
//  FakeNFT
//
//  Created by Мамытов Руслан on 27.09.2026.
//

import Foundation

struct GeometricParams {
    let columnCount: Int
    let leftInset: CGFloat
    let rightInset: CGFloat
    let cellSpacing: CGFloat
    let paddingWidth: CGFloat
    
    init(
        columnCount: Int,
        leftInset: CGFloat,
        rightInset: CGFloat,
        cellSpacing: CGFloat
    ) {
        self.columnCount = columnCount
        self.leftInset = leftInset
        self.rightInset = rightInset
        self.cellSpacing = cellSpacing
        self.paddingWidth = leftInset + rightInset + CGFloat(columnCount - 1) * cellSpacing
    }
}
