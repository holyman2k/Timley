//
//  ConversionExtension.swift
//  Timely
//
//  Created by Charlie Wu on 27/06/2014.
//  Copyright (c) 2014 Charlie Wu. All rights reserved.
//

import Foundation

extension Double {
    var f:CGFloat {
        return CGFloat(self)
    }
    @conversion func __convert(i: Int=0) -> Double {
        return Double(i)
    }
    @conversion func __convert(i: CGFloat=0) -> Double {
        return Double(i)
    }
}

extension CGFloat {
    var d:Double {
        return Double(self)
    }
}

extension Int {
    var d:Double {
        return Double(self)
    }
}
