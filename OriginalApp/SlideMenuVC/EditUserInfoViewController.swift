
import UIKit
import NCMB
import NYXImagesKit

class EditUserInfoViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var editImageButton: UIButton!
    @IBOutlet var userNametextField: UITextField!
    @IBOutlet var mailAdressTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        userNametextField.delegate = self
        mailAdressTextField.delegate = self
        
        userImageView.layer.cornerRadius = userImageView.bounds.width / 2
    
        // user がある時だけ
        if let user = NCMBUser.current(){
            
            let userName = user.userName!
            let mailAdress = user.mailAddress!
            userNametextField.text = userName
            mailAdressTextField.text = mailAdress
            // 画像の読み込み
            let imageFile = NCMBFile.file(withName: user.objectId, data: nil) as! NCMBFile
            imageFile.getDataInBackground { (data, error) in
                if error != nil {
                    print(error)
                } else {
                    if let image = UIImage(data: data!){
                        self.userImageView.image = image
                    }
                }
            }
        } else {
            NCMBUser.logOutInBackground { (error) in
                if error != nil {
                    print("error")
                } else {
                    let storyboard = UIStoryboard(name: "SignIn", bundle: Bundle.main)
                    let viewController = storyboard.instantiateViewController(withIdentifier: "SignIn")
                    UIApplication.shared.keyWindow?.rootViewController = viewController
                    
                    let ud = UserDefaults.standard
                    ud.set(false, forKey: "isLogin")
                    ud.synchronize()
                }
            }
        }
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    // 取得した画像をimageViewの中に代入
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        // imageをリサイズする
        let resizedImage = selectedImage.scale(byFactor: 0.4)
        picker.dismiss(animated: true, completion: nil)
        let data = UIImagePNGRepresentation(resizedImage!)
        if let user = NCMBUser.current() {
            let file = NCMBFile.file(withName: user.objectId, data: data) as! NCMBFile
            file.saveInBackground({ (error) in
                if error != nil {
                    print(error)
                } else {
                    self.userImageView.image = selectedImage
                }
            }) { (progress) in
                print(progress)
            }
        } else {
            NCMBUser.logOutInBackground { (error) in
                if error != nil {
                    print("error")
                } else {
                    let storyboard = UIStoryboard(name: "SignIn", bundle: Bundle.main)
                    let viewController = storyboard.instantiateViewController(withIdentifier: "SignIn")
                    UIApplication.shared.keyWindow?.rootViewController = viewController
                    
                    let ud = UserDefaults.standard
                    ud.set(false, forKey: "isLogin")
                    ud.synchronize()
                }
            }
        }
        
    }
    @IBAction func back(){
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func selectImage(){
        let actionController = UIAlertController(title: "画像の選択", message: "選択してください", preferredStyle: .actionSheet)
        let albumAction = UIAlertAction(title:  "フォトライブラリ", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                // アルバム起動
                let picker = UIImagePickerController()
                picker.sourceType = .photoLibrary
                picker.delegate = self
                self.present(picker, animated: true, completion: nil)
            } else {
                print("この機種ではライブラリにアクセスできません")
            }
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
            actionController.dismiss(animated: true, completion: nil)
        }
        actionController.addAction(albumAction)
        actionController.addAction(cancelAction)
        self.present(actionController, animated: true, completion: nil)
    }
    @IBAction func save(){
        let user = NCMBUser.current()
        user?.setObject(userNametextField.text, forKey: "userName")
        user?.setObject(mailAdressTextField.text, forKey: "mailAddress")
        user?.saveInBackground({ (error) in
            if error != nil{
                print(error)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        })
    }
    
}
