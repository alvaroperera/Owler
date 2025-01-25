//
//  OwlerToolsHelper.swift
//  Owler
//
//  Created by Álvaro Perera on 25/1/25.
//

import Foundation

class OwlerToolsHelper {
    
    static func dateFullTextString(fechaEnString: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let fecha = dateFormatter.date(from: fechaEnString)
        let outputFormatter = DateFormatter()
        
        outputFormatter.locale = Locale(identifier: "es_ES")
        outputFormatter.dateFormat = "d 'de' MMMM 'de' yyyy"
        
        let fechaFormateada = outputFormatter.string(from: fecha!)
        
        return fechaFormateada
    }
}
