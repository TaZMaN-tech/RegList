//
//  RegistrationViewModel.swift
//  RegList
//
//  Created by Тадевос Курдоглян on 14.08.2025.
//

import Foundation

final class RegistrationViewModel {
    var name: String = ""
    var surname: String = ""
    var birthDate: Date?
    var password: String = ""
    var confirmPassword: String = ""

    var onValidationChange: ((Bool) -> Void)?

    func validate() {
        let isValid = !name.isEmpty &&
                      name.count >= 2 &&
                      surname.count >= 2 &&
                      password.count >= 8 &&
                      password == confirmPassword &&
                      birthDate != nil
        onValidationChange?(isValid)
    }

    func registerUser() {
        UserDefaults.standard.set(name, forKey: "userName")
        UserDefaults.standard.set(true, forKey: "isRegistered")
    }
}
