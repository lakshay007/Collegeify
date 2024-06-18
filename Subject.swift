//
//  Subject.swift
//  Collegeify
//
//  Created by lakshay chauhan on 18/06/24.
//

import Foundation
struct Subject: Identifiable, Codable {
    var id = UUID()
    var name: String
    var day: String
    var time: String
}
