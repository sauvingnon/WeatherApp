//
//  Extension+String.swift
//  WeatherApp
//
//  Created by Гриша Шкробов on 26.09.2022.
//

import UIKit
extension String{
    var encodeUrl : String
    {
        return self.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
    }
    var decodeUrl : String
    {
        return self.removingPercentEncoding!
    }
}
