//
//  RegistrationViewController.swift
//  RegList
//
//  Created by Тадевос Курдоглян on 13.08.2025.
//

import UIKit

final class RegistrationViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var sureNameTextField: UITextField!
    @IBOutlet private weak var birthDateTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var confirmPasswordTextField: UITextField!
    @IBOutlet private weak var registerButton: UIButton!
    
    // MARK: - Properties
    private let viewModel = RegistrationViewModel()
    private let datePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = .date
        dp.preferredDatePickerStyle = .wheels
        dp.maximumDate = Date()
        return dp
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDatePicker()
        registerButton.isEnabled = false
        registerButton.alpha = 0.5
        setupTargets()
        setupKeyboardDismiss()
    }
    
    // MARK: - Actions
    @IBAction private func registerTapped(_ sender: UIButton) {
        guard validateOrAlert() else { return }
        
        let name = (nameTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        UserDefaults.standard.set(name, forKey: "userName")
        UserDefaults.standard.set(true, forKey: "isRegistered")
        
        performSegue(withIdentifier: "toMain", sender: self)
    }
    
    // MARK: - Validation
    private func allFieldsFilled() -> Bool {
        !(nameTextField.text ?? "").isEmpty &&
        !(sureNameTextField.text ?? "").isEmpty &&
        !(birthDateTextField.text ?? "").isEmpty &&
        !(passwordTextField.text ?? "").isEmpty &&
        !(confirmPasswordTextField.text ?? "").isEmpty
    }
    
    private func validateOrAlert() -> Bool {
        if (nameTextField.text ?? "").count < 2 {
            showError("Имя должно содержать минимум 2 символа")
            return false
        }
        if (sureNameTextField.text ?? "").count < 2 {
            showError("Фамилия должна содержать минимум 2 символа")
            return false
        }
        if (passwordTextField.text ?? "").count < 8 {
            showError("Пароль должен содержать минимум 8 символов")
            return false
        }
        if passwordTextField.text != confirmPasswordTextField.text {
            showError("Пароли не совпадают")
            return false
        }
        if birthDateTextField.text?.isEmpty ?? true {
            showError("Укажите дату рождения")
            return false
        }
        return true
    }
    
    private func showError(_ message: String) {
        let ac = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    // MARK: - Helpers
    private func setupTargets() {
        [nameTextField, sureNameTextField, birthDateTextField,
         passwordTextField, confirmPasswordTextField].forEach {
            $0?.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        }
    }
    
    @objc private func textFieldChanged() {
        let filled = allFieldsFilled()
        registerButton.isEnabled = filled
        registerButton.alpha = filled ? 1 : 0.5
    }
    
    private func setupKeyboardDismiss() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - DatePicker
    @objc private func dateChanged() {
        let df = DateFormatter()
        df.dateStyle = .medium
        birthDateTextField.text = df.string(from: datePicker.date)
        textFieldChanged()
    }
    
    @objc private func donePressed() {
        dateChanged()
        view.endEditing(true)
    }
    
    private func setupDatePicker() {
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        birthDateTextField.inputView = datePicker
        
        let tb = UIToolbar()
        tb.sizeToFit()
        let done = UIBarButtonItem(title: "Готово", style: .plain, target: self, action: #selector(donePressed))
        tb.setItems([UIBarButtonItem(systemItem: .flexibleSpace), done], animated: false)
        birthDateTextField.inputAccessoryView = tb
    }
}
