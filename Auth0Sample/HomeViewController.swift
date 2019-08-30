// HomeViewController.swift
// Auth0Sample
//
// Copyright (c) 2016 Auth0 (http://auth0.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit
import Auth0
import SafariServices

class HomeViewController: UIViewController {

    // MARK: - IBAction
    @IBAction func showLoginController(_ sender: UIButton) {
        guard let clientInfo = plistValues(bundle: Bundle.main) else { return }
        
        let credentialsManager = CredentialsManager(authentication: Auth0.authentication())
        //.audience("https://" + clientInfo.auth0domain + "/userinfo")
        Auth0
            .webAuth()
            .scope("openid profile")
            .start {
                switch $0 {
                case .failure(let error):
                    print("Error: \(error)")
                case .success(let credentials):
                    //guard let idToken = credentials.idToken else { return }
                    guard let accessToken = credentials.accessToken else { return }
                    
                    //print("idToken is: \(idToken)")
                    print("accessToken is: \(accessToken)")
                    
                    //credentialsManager.store(credentials: credentials)
                    
                    //self.showSuccessAlert(idToken)
                    self.showSuccessAlert(accessToken)
                }
        }
    }
    
    @IBAction func showWebApp(_ sender: UIButton) {
        self.showSuccessAlert()
        
        if let url = URL(string: "https://spa-app.identityplayground.com") {
            if #available(iOS 11.0, *) {
                let config = SFSafariViewController.Configuration()
            } else {
                // Fallback on earlier versions
            }
            //config.entersReaderIfAvailable = true
            
            let vc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
            present(vc, animated: true)
        }
    }

    // MARK: - Private
    fileprivate func showSuccessAlert() {
        let alert = UIAlertController(title: "Web App", message: "Web App popup", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Private
    fileprivate func showSuccessAlert(_ accessToken: String) {
        let alert = UIAlertController(title: "Success", message: "accessToken: \(accessToken)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}

func plistValues(bundle: Bundle) -> (clientId: String, domain: String, auth0domain: String)? {
    guard
        let path = bundle.path(forResource: "Auth0", ofType: "plist"),
        let values = NSDictionary(contentsOfFile: path) as? [String: Any]
        else {
            print("Missing Auth0.plist file with 'ClientId' and 'Domain' entries in main bundle!")
            return nil
    }

    guard
        let clientId = values["ClientId"] as? String,
        let domain = values["Domain"] as? String,
        let auth0domain = values["Auth0Domain"] as? String
        else {
            print("Auth0.plist file at \(path) is missing 'ClientId' and/or 'Domain' entries and/or 'Auth0Domain' entries!")
            print("File currently has the following entries: \(values)")
            return nil
    }
    return (clientId: clientId, domain: domain, auth0domain: auth0domain)
}
