//
//  InfoController.swift
//  BeaconCarLocation
//
//  Created by Mek on 03/03/18.
//  Copyright © 2018 Mek. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class LoginRegisterController: UIViewController
{
    static let shared = LoginRegisterController()

    override func viewWillDisappear(_ animated: Bool)
    {
        debugPrint("hello")
        DataManager.shared.array[0] = Firebase.uidUser()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = UIColor(r: 69, g: 99, b: 162)
        view.addSubview(inputContainerView)
        view.addSubview(loginRegisterButton)
        view.addSubview(profileImageView)
        view.addSubview(segmentControl)
        view.addSubview(labelLogin)
        
        constrainsInputContainerView()
        constrainsLogingRegisterButton()
        constrainsImageView()
        constrainsSegmentControl()
        constrainsLabelLogin()
        tastiera()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:NSNotification.Name.UIKeyboardWillChangeFrame, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil);
    
    }
    var usersReferences: DatabaseReference!
    
    var greyView: UIView = {
        var greyView = UIView()
        greyView.backgroundColor = .black
        greyView.alpha = 0
        return greyView
    }()
    
    lazy var activity: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView()
        activity.center = view.center
        activity.color = UIColor.white
        activity.hidesWhenStopped = true
        return activity
    }()
    
    let labelLogin: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("DDA", comment: "")
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.center
        label.alpha = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    
    let inputContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
        
    let loginRegisterButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 109, g: 139, b: 202)
        button.setTitle(NSLocalizedString("REG", comment: ""), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleLoginRegisterButton), for: .touchUpInside)
        return button
    }()
    
    let segmentControl: UISegmentedControl = {
        var sc = UISegmentedControl()
        let item = ["Login", NSLocalizedString("REG", comment: "")]
        sc = UISegmentedControl(items: item)
        sc.tintColor = UIColor.white
        sc.selectedSegmentIndex = 1
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.addTarget(self, action: #selector(handleLoginRegister), for: .valueChanged)
        return sc
    }()

    
    lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = NSLocalizedString("NOME", comment: "")
        textField.translatesAutoresizingMaskIntoConstraints = false
       return textField
    }()
    
    lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = NSLocalizedString("EMAIL", comment: "")
        textField.keyboardType = UIKeyboardType.emailAddress
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = NSLocalizedString("PASS", comment: "")
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let nameSeparatoreView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let emailSeparatoreView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "tesla")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    func tastiera() {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissKeyboard))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        self.nameTextField.inputAccessoryView = keyboardToolbar
        self.emailTextField.inputAccessoryView = keyboardToolbar
        self.passwordTextField.inputAccessoryView = keyboardToolbar
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
    
    func constrainsSegmentControl()
    {
        segmentControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        segmentControl.bottomAnchor.constraint(equalTo: inputContainerView.topAnchor, constant: -20).isActive = true
        segmentControl.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        segmentControl.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    var inputContainerViewHeightAnchor: NSLayoutConstraint?
    var inputNameTextFieldHeightAnchor: NSLayoutConstraint?
    var inputEmailTextFieldHeighAnchor: NSLayoutConstraint?
    var inputPasswordTextFieldHeighAnchor: NSLayoutConstraint?
    
    func constrainsInputContainerView()
    {
        //Constrains: x, y, width, height
        inputContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputContainerView.centerYAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: -20)
        inputContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputContainerViewHeightAnchor = inputContainerView.heightAnchor.constraint(equalToConstant: 150)
        inputContainerViewHeightAnchor?.isActive = true
        
        
        inputContainerView.addSubview(nameTextField)
        nameTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        nameTextField.topAnchor.constraint(equalTo: inputContainerView.topAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        inputNameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
        inputNameTextFieldHeightAnchor?.isActive = true
        
        inputContainerView.addSubview(nameSeparatoreView)
        nameSeparatoreView.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
        nameSeparatoreView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        nameSeparatoreView.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        nameSeparatoreView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        inputContainerView.addSubview(emailTextField)
        emailTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        inputEmailTextFieldHeighAnchor = emailTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
        inputEmailTextFieldHeighAnchor?.isActive = true
        
        inputContainerView.addSubview(emailSeparatoreView)
        emailSeparatoreView.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
        emailSeparatoreView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSeparatoreView.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        emailSeparatoreView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        inputContainerView.addSubview(passwordTextField)
        passwordTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        inputPasswordTextFieldHeighAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
        inputPasswordTextFieldHeighAnchor?.isActive = true
  
    }
    
    func constrainsLogingRegisterButton()
    {
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterButton.topAnchor.constraint(equalTo: inputContainerView.bottomAnchor, constant: 20).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        

    }
    
    //Da aggiustare 
    func constrainsImageView()
    {
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: segmentControl.topAnchor, constant: -20).isActive = true
        profileImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    
    }
    
    @objc func handleLoginRegister()
    {
        let title = segmentControl.titleForSegment(at: segmentControl.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, for: .normal)
        
        // cambio constrains containerView
        
        inputContainerViewHeightAnchor?.constant = segmentControl.selectedSegmentIndex == 0 ? 100 : 150
        inputNameTextFieldHeightAnchor?.isActive = false
        inputNameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: segmentControl.selectedSegmentIndex == 0 ? 0 : 1/3)
        inputNameTextFieldHeightAnchor?.isActive = true
        
        inputEmailTextFieldHeighAnchor?.isActive = false
        inputEmailTextFieldHeighAnchor = emailTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: segmentControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        inputEmailTextFieldHeighAnchor?.isActive = true
        
        inputPasswordTextFieldHeighAnchor?.isActive = false
        inputPasswordTextFieldHeighAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: segmentControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        inputPasswordTextFieldHeighAnchor?.isActive = true
        
    }
    
    func constrainsLabelLogin()
    {
        labelLogin.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        labelLogin.widthAnchor.constraint(equalTo: loginRegisterButton.widthAnchor).isActive = true
        labelLogin.heightAnchor.constraint(equalToConstant: 20).isActive = true
        labelLogin.topAnchor.constraint(equalTo: loginRegisterButton.bottomAnchor, constant: 30).isActive = true
    }


    
    @objc func handleLoginRegisterButton()
    {
        if (segmentControl.selectedSegmentIndex == 0)
        {
            handleLogin()
        }
        else
        {
            handleRegister()
        }
    }
    
    func handleLogin()
    {
        
        guard let email = emailTextField.text, let password = passwordTextField.text
            else
        {
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if (error != nil)
            {
                debugPrint(error!)
                self.labelLogin.alpha = 1
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5)
                {
                    UIView.animate(withDuration: TimeInterval(0.5), animations: { self.labelLogin.alpha = 0})
                }
                return
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func handleRegister()
    {
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text
            else
        {
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password)
        {   (user, error) in
            if (error != nil)
            {
                debugPrint(error!)
                return
            }

            guard let uid = user?.uid else { return }

            let ref = Database.database().reference(fromURL: "https://beacon-car-location-1f96b.firebaseio.com")
            let usersReferences = ref.child("users").child(uid)
            let values = ["Name": name, "Email": email]
            usersReferences.updateChildValues(values, withCompletionBlock: { (error, ref) in
                if (error != nil)
                {
                    debugPrint(error!)
                }

                self.dismiss(animated: true, completion: nil)
            })
        }
    }
    
    
    
    
    @objc func keyboardWillShow(sender: NSNotification)
    {
        self.view.frame.origin.y = -130
        
    }
    @objc func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
}
extension UIColor{
    convenience init(r: CGFloat, g: CGFloat ,b: CGFloat)
    {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }

}
