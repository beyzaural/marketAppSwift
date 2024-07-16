//
//  RegisterViewController.swift
//  productUI
//
//  Created by Sena Beyza Ural on 26.06.2024.
//

import UIKit

class RegisterViewController: UIViewController {
    let registerLabel = UILabel()
    let nameTextField = UITextField()
    let surnameTextField = UITextField()
    let emailTextField = UITextField()
    let passwordTextField = UITextField()
    let registerButton = UIButton()
    let accountLabel = UILabel()
    let errorLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        setupRegisterLabel()
        setupNameField()
        setupSurnameField()
        setupEmailField()
        setupPasswordField()
        setupRegisterButton()
        setupAccountLabel()
        setupErrorLabel()
        layout()
        tapAccount()
        
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
    }
    
    private func setupRegisterLabel () {
        registerLabel.text = "Register"
        registerLabel.font = UIFont.boldSystemFont(ofSize: 24)
        registerLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(registerLabel)
    }
    
    private func setupErrorLabel() {
           errorLabel.textColor = .red
           errorLabel.numberOfLines = 0
           errorLabel.textAlignment = .center
           errorLabel.translatesAutoresizingMaskIntoConstraints = false
           self.view.addSubview(errorLabel)
       }
       
    
    private func setupNameField() {
        nameTextField.placeholder = "Name"
        nameTextField.borderStyle = .roundedRect
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(nameTextField)
    }
    
    private func setupSurnameField () {
        surnameTextField.placeholder = "Surname"
        surnameTextField.borderStyle = .roundedRect
        surnameTextField.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(surnameTextField)
    }
    
    private func setupEmailField(){
        emailTextField.placeholder = "Email"
        emailTextField.borderStyle = .roundedRect
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(emailTextField)
    }
    
    private func setupPasswordField(){
        passwordTextField.placeholder = "Password"
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.isSecureTextEntry = true
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(passwordTextField)
    }
    
    private func setupRegisterButton(){
        registerButton.backgroundColor = .systemCyan
        registerButton.setTitle("Register", for: .normal)
        registerButton.layer.cornerRadius = 18 // Half of the button height to make it fully rounded
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
    
        self.view.addSubview(registerButton)
    }
    
    private func setupAccountLabel() {
        accountLabel.text = "Already have an account? Login"
        accountLabel.font = UIFont.systemFont(ofSize: 16)
        accountLabel.textColor = .systemBlue
        accountLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(accountLabel)
    }
    
    private func tapAccount(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(accountLabelTapped))
        accountLabel.isUserInteractionEnabled = true
        accountLabel.addGestureRecognizer(tapGesture)
    }
    
    @objc func accountLabelTapped() {
        let loginViewController = ViewController()
        self.navigationController?.pushViewController(loginViewController, animated: true)
    }
    
    

    
    @objc func registerButtonTapped() {
        guard let name = nameTextField.text,
              let surname = surnameTextField.text,
              let email = emailTextField.text,
              let password = passwordTextField.text
        else {
            return
        }
        
        let url = URL(string: "http://localhost:3000/user")!
       
        
        //callAPI
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: Any] = [
            "name": name,
            "surname": surname,
            "email": email,
            "password": password
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "No data")")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Response Status Code: \(httpResponse.statusCode)")
                let responseString = String(data: data, encoding: .utf8)
                print("Response Body: \(responseString ?? "")")
                
                if httpResponse.statusCode == 200 {
                    let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    if let message = jsonResponse?["message"] as? String, message == "User already exist!" {
                        DispatchQueue.main.async {
                            self.showError("User already exists. Please login.")
                        }
                    } else {
                        DispatchQueue.main.async {
                            let homePageViewController = HomePageViewController()
                            self.navigationController?.pushViewController(homePageViewController, animated: true)
                        }
                        DispatchQueue.main.async {
                            let alert = UIAlertController(title: "Success", message: "Registration successful", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                       
                    }
                } else {
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Error", message: "Registration failed", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
        task.resume()
        
    
    }
    
    private func showError(_ message: String) {
            errorLabel.text = message
        }
        
    private func layout() {
        NSLayoutConstraint.activate([
            // Register label constraints
            registerLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            registerLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 40),
            
            // Name text field constraints
            nameTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            nameTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            nameTextField.topAnchor.constraint(equalTo: registerLabel.bottomAnchor, constant: 20),
            nameTextField.heightAnchor.constraint(equalToConstant: 40),
            
            // Surname text field constraints
            surnameTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            surnameTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            surnameTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20),
            surnameTextField.heightAnchor.constraint(equalToConstant: 40),
            
            // Email text field constraints
            emailTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            emailTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            emailTextField.topAnchor.constraint(equalTo: surnameTextField.bottomAnchor, constant: 20),
            emailTextField.heightAnchor.constraint(equalToConstant: 40),
            
            // Password text field constraints
            passwordTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            passwordTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            passwordTextField.heightAnchor.constraint(equalToConstant: 40),
            
            // Register button constraints
            registerButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            registerButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            registerButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            registerButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Account label constraints
            accountLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            accountLabel.topAnchor.constraint(equalTo: registerButton.bottomAnchor, constant: 20),
            
            errorLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            errorLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            errorLabel.topAnchor.constraint(equalTo: accountLabel.bottomAnchor, constant: 20)
        ])
    }
}
