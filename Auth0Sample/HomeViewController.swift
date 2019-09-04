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
import AuthenticationServices

@available(iOS 12.0, *)
class HomeViewController: UIViewController {
    
    private var authSession: ASWebAuthenticationSession?
    private var sfSafariSession: SFAuthenticationSession?
    private var safariVC: SFSafariViewController?

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
    
    
    fileprivate static let NoBundleIdentifier = "com.auth0.this-is-no-bundle"
    
    var redirectURL: URL? {
        let bundleIdentifier = Bundle.main.bundleIdentifier
        var components = URLComponents(url: URL(string: "http://spa-app.identityplayground.com") ?? URL(string: "http://spa-app.identityplayground.com")!, resolvingAgainstBaseURL: true)
        components?.scheme = bundleIdentifier ?? "auth0.samples.Auth0Sample" + "://"
        return components?.url?
            .appendingPathComponent("ios")
            .appendingPathComponent(bundleIdentifier ?? "auth0.samples.Auth0Sample")
            .appendingPathComponent("callback")
    }
    
    @IBAction func showASWebSession(_ sender: UIButton) {
        // self.showSuccessAlert()
        
        //if let url = URL(string: "https://spa-app.identityplayground.com") {
        //let string = "https://pravinady-sso-apps.auth0.com/authorize?response_type=code&code_challenge_method=S256&state=zMdcWnFno2jsBd0-KV45eTJePTAUpzJOPCyYJz87ViE&client_id=RcMbvKQo8dKhOCEkN1PNxrF9hFAx0blZ&redirect_uri=auth0.samples.Auth0Sample://pravinady-sso-apps.auth0.com/ios/auth0.samples.Auth0Sample/callback&scope=openid%20profile&code_challenge=EuZFZmxJYZ7lxCqJ1eYcOSErqngPao_ECK6kFzR87iY&auth0Client=eyJuYW1lIjoiQXV0aDAuc3dpZnQiLCJ2ZXJzaW9uIjoiMS4xMy4wIiwic3dpZnQtdmVyc2lvbiI6IjMuMCJ9"
        let string = "http://spa-app.identityplayground.com"
        guard let url = URL(string: string) else { return }
        self.authSession = ASWebAuthenticationSession(url: url, callbackURLScheme: redirectURL?.absoluteString, completionHandler:
        {
            url, error in
            print(url?.absoluteString as Any)
            print(error.debugDescription)
        })
        
        self.authSession?.start()
    }
   
    
    @IBAction func showSFSafariSession(_ sender: UIButton) {
        // self.showSuccessAlert()
        
        //if let url = URL(string: "https://spa-app.identityplayground.com") {
        //let string = "https://pravinady-sso-apps.auth0.com/authorize?response_type=code&code_challenge_method=S256&state=zMdcWnFno2jsBd0-KV45eTJePTAUpzJOPCyYJz87ViE&client_id=RcMbvKQo8dKhOCEkN1PNxrF9hFAx0blZ&redirect_uri=auth0.samples.Auth0Sample://pravinady-sso-apps.auth0.com/ios/auth0.samples.Auth0Sample/callback&scope=openid%20profile&code_challenge=EuZFZmxJYZ7lxCqJ1eYcOSErqngPao_ECK6kFzR87iY&auth0Client=eyJuYW1lIjoiQXV0aDAuc3dpZnQiLCJ2ZXJzaW9uIjoiMS4xMy4wIiwic3dpZnQtdmVyc2lvbiI6IjMuMCJ9"
        let string = "http://spa-app.identityplayground.com"
        guard let url = URL(string: string) else { return }
        self.sfSafariSession = SFAuthenticationSession(url: url, callbackURLScheme: redirectURL?.absoluteString, completionHandler:  {
            url, error in
            print(url?.absoluteString as Any)
            print(error.debugDescription)
        })
        self.sfSafariSession?.start()
    }
    
    @IBAction func showSafariView(_ sender: UIButton) {
        // self.showSuccessAlert()
        
        //if let url = URL(string: "https://spa-app.identityplayground.com") {
        //let string = "https://pravinady-sso-apps.auth0.com/authorize?response_type=code&code_challenge_method=S256&state=zMdcWnFno2jsBd0-KV45eTJePTAUpzJOPCyYJz87ViE&client_id=RcMbvKQo8dKhOCEkN1PNxrF9hFAx0blZ&redirect_uri=auth0.samples.Auth0Sample://pravinady-sso-apps.auth0.com/ios/auth0.samples.Auth0Sample/callback&scope=openid%20profile&code_challenge=EuZFZmxJYZ7lxCqJ1eYcOSErqngPao_ECK6kFzR87iY&auth0Client=eyJuYW1lIjoiQXV0aDAuc3dpZnQiLCJ2ZXJzaW9uIjoiMS4xMy4wIiwic3dpZnQtdmVyc2lvbiI6IjMuMCJ9"
        let string = "http://spa-app.identityplayground.com"
        guard let url = URL(string: string) else { return }
        self.safariVC = SFSafariViewController(url: url)
        present(self.safariVC!, animated: true, completion: nil)
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
