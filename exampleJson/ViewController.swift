//
//  ViewController.swift
//  exampleJson
//
//  Created by Eren FAIKOGLU on 12.07.2020.
//  Copyright © 2020 Eren FAIKOGLU. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var errorVal : Bool = false
    @IBOutlet weak var label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        label.text = "Please wait..."
        
        var timer = Timer()
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(autoRefresh), userInfo: nil, repeats: true)
    }
    
    func errorThrow(message:String) {
        //error?.localizedDescription user friendly hata dondurur
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
        let okbutton = UIAlertAction.init(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okbutton)
        //self present, animation true, comp nil
        self.present(alert, animated: true, completion: nil)
    }

    //button ile ---------------------------------------------------------------------------------------------------------
    @IBAction func button(_ sender: Any) {
        
        let url = URL(string: "https://api.coindesk.com/v1/bpi/currentprice.json")
        let session = URLSession.shared
        
        //with url completionhandler
        let task = session.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                DispatchQueue.main.async {   self.errorThrow(message: error!.localizedDescription) }
            } else {
                if data != nil {
                    
                    do {
                    //jsonserialization
                        let jsonresponse = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String, Any>
                        //async
                         DispatchQueue.main.async {
                            //index icine gir
                        let bpi = jsonresponse["bpi"] as! Dictionary<String, Any>
                            //tekrar index icine gir
                        let usd = bpi["USD"] as! Dictionary<String, Any>
                            //gelen data onemli, ceviremezse hicbir sey olmaz
                        if let usdRate = usd["rate"] as? String {
                            self.label.text = "1 BTC = \(usdRate)$"
                             print(usdRate)
                        }
                       }
                        
                    }
                        
                    catch {print("Err!")}
                }
            }
        }
        //olmazsa task calismaz∫
        task.resume()
        
    }
    
    
    //timer ile otomatik ---------------------------------------------------------------------------------------------------------
    @objc func autoRefresh() {
        
        let url = URL(string: "https://api.coindesk.com/v1/bpi/currentprice.json")
              let session = URLSession.shared
              
              //with url completionhandler
              let task = session.dataTask(with: url!) { (data, response, error) in
                  if error != nil {
                      DispatchQueue.main.async {   self.errorThrow(message: error!.localizedDescription) }
                  } else {
                      if data != nil {
                          
                          do {
                          //jsonserialization
                              let jsonresponse = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String, Any>
                              //async
                               DispatchQueue.main.async {
                                  //index icine gir
                              let bpi = jsonresponse["bpi"] as! Dictionary<String, Any>
                                  //tekrar index icine gir
                              let usd = bpi["USD"] as! Dictionary<String, Any>
                                  //gelen data onemli, ceviremezse hicbir sey olmaz
                              if let usdRate = usd["rate"] as? String {
                                  self.label.text = "1 BTC = \(usdRate)$"
                                   print(usdRate)
                              }
                             }
                              
                          }
                              
                          catch {print("Err!")}
                      }
                  }
              }
              //olmazsa task calismaz
              task.resume()
        
    }
    

    
}

