//
//  ViewController.swift
//  productUI
//
//  Created by Sena Beyza Ural on 26.06.2024.
//

import UIKit

class ViewController: UIViewController {
    let loginButton = UIButton()
    let emailTextField = UITextField()
    let passwordTextField = UITextField()
    let loginLabel = UILabel()
    let registerLabel = UILabel()
    let errorLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        emailField()
        passwordField()
        setupLoginLabel()
        loggedButton()
        setupRegisterLabel()
        setupErrorLabel()
        layout()
        tapRegister()
        
    }
    
    private func setupLoginLabel() {
        loginLabel.text = "Login"
        loginLabel.font = UIFont.boldSystemFont(ofSize: 24)
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(loginLabel)
    }
    
    private func setupErrorLabel() {
        errorLabel.textColor = .red
        errorLabel.numberOfLines = 0
        errorLabel.textAlignment = .center
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(errorLabel)
    }
    
    
    
    private func emailField(){
        emailTextField.placeholder = "Email"
        emailTextField.borderStyle = .roundedRect
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(emailTextField)
    }
    
    private func passwordField(){
        passwordTextField.placeholder = "Password"
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.isSecureTextEntry = true
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(passwordTextField)
    }
    
    private func loggedButton(){
        loginButton.backgroundColor = .systemCyan
        loginButton.setTitle("Login", for: .normal)
        loginButton.layer.cornerRadius = 18 // Half of the button height to make it fully rounded
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        
        self.view.addSubview(loginButton)
        
    }
    
    
    @objc func loginButtonTapped() {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showError("Please enter both email and password.")
            return
        }
        
        
        //api call
        let loginData = ["email": email, "password": password]
        let url = URL(string: "http://localhost:3000/user/login")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: loginData, options: [])
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                self.showError("Unable to connect to the server. Please try again.")
                return
            }
            
            print("Response: \(response)")
            
            if let httpResponse = response as? HTTPURLResponse {
                            switch httpResponse.statusCode {
                            case 201:
                                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                                   let token = json["access_token"] as? String {
                                    print("Json: \(json)")
                                    // Save token if needed
                                    DispatchQueue.main.async {
                                        let homePageViewController = HomePageViewController()
                                        self.navigationController?.pushViewController(homePageViewController, animated: true)
                                    }
                                } else {
                                    DispatchQueue.main.async {
                                        self.showError("Unexpected error!")
                                    }
                                }
                            case 406: // HttpStatus.NOT_ACCEPTABLE
                                DispatchQueue.main.async {
                                    self.showError("Password is wrong!aTry again")
                                }
                            default:
                                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                                   let errorMessage = json["error"] as? String {
                                    DispatchQueue.main.async {
                                        self.showError(errorMessage)
                                    }
                                } else {
                                    DispatchQueue.main.async {
                                        self.showError("Unexpected error!")
                                    }
                                }
                            }
                        } else {
                            DispatchQueue.main.async {
                                self.showError("Unexpected response from the server.")
                            }
                        }
                    }
                    
                    task.resume()
                }

    private func showError(_ message: String) {
        DispatchQueue.main.async {
            self.errorLabel.text = message
        }
    }
    
    private func setupRegisterLabel() {
        registerLabel.text = "Don't have an account? Register"
        registerLabel.font = UIFont.systemFont(ofSize: 16)
        registerLabel.textColor = .systemBlue
        registerLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(registerLabel)
    }
    
    func layout(){
        NSLayoutConstraint.activate([
            
            // Login label constraints
            loginLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            loginLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 40),
            
            
            // Email text field constraints
            emailTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            emailTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            emailTextField.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 20),
            emailTextField.heightAnchor.constraint(equalToConstant: 40),
            
            // Password text field constraints
            passwordTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            passwordTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            passwordTextField.heightAnchor.constraint(equalToConstant: 40),
            
            
            // Login button constraints
            loginButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            loginButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Register label constraints
            registerLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            registerLabel.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 20),
            
            errorLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            errorLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            errorLabel.topAnchor.constraint(equalTo: registerLabel.bottomAnchor, constant: 20)
        ])
        
        
    }
    
    private func tapRegister(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(registerLabelTapped))
        registerLabel.isUserInteractionEnabled = true
        registerLabel.addGestureRecognizer(tapGesture)
    }
    @objc func registerLabelTapped() {
        let registerViewController = RegisterViewController()
        self.navigationController?.pushViewController(registerViewController, animated: true)
    }
    
    
}

