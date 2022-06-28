import UIKit

class LoginTableViewController: UITableViewController {

    var delegate: DidAuthenticationCompleted?
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.inputViewController?.dismissKeyboard()
       
    }
    
    @IBAction func btnLoginClicked(_ sender: UIButton) {
        validationCode()
    }
    
    
    @IBAction func btnClickedSignup(_ sender: UIButton) {
        if let signupVC = storyboard?.instantiateViewController(withIdentifier: "SignupTableViewController") as? SignupTableViewController{
    
        navigationController?.pushViewController(signupVC, animated: true)
        }
    }
}
extension LoginTableViewController {

//        override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//            return UIScreen.main.bounds.height
//        }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let tableViewHeight = self.tableView.frame.height
        let contentHeight = self.tableView.contentSize.height

        let centeringInset = (tableViewHeight - contentHeight)/2
        let topInset = max(centeringInset,0.0)

        self.tableView.contentInset = UIEdgeInsets(top: topInset, left: 0.0, bottom: 0.0, right: 0.0)
    }
}

extension LoginTableViewController {
    fileprivate func validationCode() {
        if let email = txtEmail.text, let password = txtPassword.text {
            if !email.validateEmailId() {
                openAlert(title: "Alert", message: "Email Address Not valid", actionTitles: ["Okay"], actionStyle: [.default], actions: [{_ in
                               print("OK Clicked") }], vc: self)
            } else if !password.validatePassword() {
                openAlert(title: "Alert", message: "Please enter valid Password", actionTitles: ["Okay"],actionStyle: [.default], actions: [{_ in
                print("OK Clicked")}], vc: self)
            } else {
                AuthService.shared.loginUser(email: txtEmail.text!, password: txtPassword.text!) { result, error in
                    if error != nil{
                        print("Error\(String(describing: error?.localizedDescription))")
                        self.openAlert(title: "Alert", message: "Email or Password are Incorrect", actionTitles: ["Okay"], actionStyle: [.default], actions: [{ _ in
                            print("Okay Clicked")}], vc: self)
                        return
                    } else {
                        self.delegate?.authenticationCompleted()
                        self.dismiss(animated: true)
                            
                    }
                }

            }
            
        } else {
            openAlert(title: "Alert", message: "Please Add details", actionTitles: ["Okay"], actionStyle: [.default], actions: [{ _ in
                print("Okay Clicked")
            }], vc: self)
        }
    }
}

