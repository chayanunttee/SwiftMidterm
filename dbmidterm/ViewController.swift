//
//  ViewController.swift
//  dbmidterm
//
//  Created by Admin on 5/3/2562 BE.
//  Copyright © 2562 Admin. All rights reserved.
//

import UIKit
import SQLite3

class ViewController: UIViewController {
    
    var db: OpaquePointer?
    var pointer:OpaquePointer?
    var stmt: OpaquePointer?
    @IBOutlet weak var textFieldRanking: UITextField!
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var selectedDate: UIDatePicker!
    @IBAction func buttonSave(_ sender: UIButton) {
        let currentDate = selectedDate.date
        let myFormatter = DateFormatter()
        myFormatter.dateFormat = "dd/MM/YYYY"
        let thaiLocale = NSLocale(localeIdentifier: "TH_th")
        myFormatter.locale = thaiLocale as Locale
        let currentDateText = myFormatter.string(from: currentDate)
        
        let name = textFieldName.text! as NSString
        let powerrank = textFieldRanking.text! as NSString
        
        
        let insertQuery = "INSERT INTO people (name,powerrank,datess) VALUES (?,?,?)"
        
        if sqlite3_prepare(db,insertQuery,-1,&stmt,nil) != SQLITE_OK{
            print("Error binding query")
        }
        
        if sqlite3_bind_text(stmt,1,powerrank.utf8String,-1,nil) != SQLITE_OK{
            print("Error binding location")
        }
        
        if sqlite3_bind_text(stmt,2,name.utf8String,-1,nil) != SQLITE_OK{
            print("Error binding product")
        }
//        if sqlite3_bind_int(stmt,2,(powerrank! as NSString).intValue) != SQLITE_OK{
//            print("Error binding powerrank")
//        }
        
        if sqlite3_bind_text(stmt,3,currentDateText,-1,nil) != SQLITE_OK{
            print("Error binding date")
        }
        
        if sqlite3_step(stmt) == SQLITE_DONE{
            print("Hero saved successful")
        }
        
        select()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let fileUrl = try!
            FileManager.default.url(for: .documentDirectory, in: .userDomainMask,appropriateFor: nil,create:
                false).appendingPathComponent("productdb.sqlite")
        
        if sqlite3_open(fileUrl.path, &db) != SQLITE_OK{
            print("Error opening database")
            return
        }
        
        let createTableQuery = "CREATE TABLE IF NOT EXISTS people (id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT,powerrank TEXT,datess TEXT)"
        
        if sqlite3_exec(db,createTableQuery,nil,nil,nil) != SQLITE_OK{
            print("Error Createing Table")
            return
        }
        
        print ("Evething is fine")
        
        select()
    }
    func select(){
        let sql = "SELECT * FROM people"
        sqlite3_prepare(db,sql,-1,&pointer,nil)
        textView.text = ""
        var id : Int32
        var name : String
        var powerrank : String
        var datess : String
        
        while(sqlite3_step(pointer) == SQLITE_ROW){
            id = sqlite3_column_int(pointer,0)
            textView.text?.append("id:\(id)\n")
            
            name = String(cString:sqlite3_column_text(pointer,1))
            //showResultLabel.text = name
            textView.text?.append("location:\(name)\n")
            
            powerrank = String(cString:sqlite3_column_text(pointer,2))
            textView.text?.append("product:\(powerrank)\n")
            
            datess = String(cString:sqlite3_column_text(pointer,3))
            textView.text?.append("date:\(datess)\n")
            
        }
    }
    
    @IBAction func buttonDeleteDidTap(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Delete",
                                      message: "ใส่ ID ของแถวที่ต้องการลบ",
                                      preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: { tf in
            tf.placeholder = "ID ของแถวที่ต้องการลบ"
            tf.font = UIFont.systemFont(ofSize: 18)
            tf.keyboardType = .numberPad
        })
        
        let btCancel = UIAlertAction(title: "Cancel",
                                     style: .cancel,
                                     handler: nil)
        
        let btOK = UIAlertAction(title: "OK",
                                 style: .default,
                                 handler: { _ in
                                    guard let id = Int32(alert.textFields!.first!.text!) else {
                                        return
                                    }
                                    let sql = "DELETE FROM people WHERE id = \(id)"
                                    sqlite3_exec(self.db, sql, nil,nil,nil)
                                    self.select()
        })
        
        alert.addAction(btCancel)
        alert.addAction(btOK)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func buttonEditDidTap(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(
            title: "Update",
            message: "ใส่ข้อมูลให้ครบทุกช่อง",
            preferredStyle: .alert
        )
        
        alert.addTextField(configurationHandler: { tf in
            tf.placeholder = "ID ของแถวที่ต้องการแก้ไข"
            tf.font = UIFont.systemFont(ofSize: 18)
            tf.keyboardType = .numberPad
        })
        
        alert.addTextField(configurationHandler: { tf in
            tf.placeholder = "กรอกสถานที่"
            tf.font = UIFont.systemFont(ofSize: 18)
        })
        alert.addTextField(configurationHandler: { tf in
            tf.placeholder = "กรอกสินค้า"
            tf.font = UIFont.systemFont(ofSize: 18)
            tf.keyboardType = .phonePad
        })
        
        let btCancel = UIAlertAction(title: "Cancel",
                                     style: .cancel,
                                     handler: nil)
        
        let btOK = UIAlertAction(title: "Ok",
                                 style: .default,
                                 handler: { _ in
                                    guard let id = Int32(alert.textFields![0].text!) else {
                                        return
                                    }
                                    let name = alert.textFields![1].text! as NSString
                                    let phone = alert.textFields![2].text! as NSString
                                    let sql = "UPDATE people " +
                                        "SET name = ?, powerrank = ? " +
                                    "WHERE id = ?"
                                    sqlite3_prepare(self.db, sql, -1, &self.stmt, nil)
                                    sqlite3_bind_text(self.stmt, 1, name.utf8String, -1, nil)
                                    sqlite3_bind_text(self.stmt, 2, phone.utf8String, -1, nil)
                                    sqlite3_bind_int(self.stmt, 3, id)
                                    sqlite3_step(self.stmt)
                                    
                                    self.select()
        })
        
        alert.addAction(btCancel)
        alert.addAction(btOK)
        present(alert, animated: true, completion: nil)
    }
    
}

