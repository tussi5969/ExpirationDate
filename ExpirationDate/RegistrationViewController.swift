//
//  RegistrationViewController.swift
//  ExpirationDate
//
//  Created by 宮地篤士 on 2019/06/13.
//  Copyright © 2019 Atsushi Miyaji. All rights reserved.
//

import UIKit
import FSCalendar
import CalculateCalendarLogic

class RegistrationViewController: UIViewController,FSCalendarDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance{
    
    @IBOutlet weak var calendar: FSCalendar!
//    @IButlet var dateTextField: UITextField!
    @IBOutlet var foodTextField: UITextField!

    
    var selectDay: (Int, Int, Int) = (0,0,0)
    var StringselectDay: String = ""
    
    var foodArray: [Dictionary<String,String>] = []
    var foodDateArray: [[Int]] = []
    
    let saveDate = UserDefaults.standard
    
    var numbersString: [String] = []
    var numbersInt: [Int] = []
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // デリゲートの設定
//        self.calendar.dataSource = self
//        self.calendar.delegate = self
//        saveDate.removeObject(forKey: "FOOD")         // データをすべて削除する
        if saveDate.array(forKey: "FOOD") != nil {
            foodArray = saveDate.array(forKey: "FOOD") as! [Dictionary<String, String>]
            
        }
        
        for array_num in foodArray{
            print((array_num["date"] ?? "test").components(separatedBy: "/"))
            numbersString = (array_num["date"] ?? "test").components(separatedBy: "/")
            
            numbersInt = numbersString.map({ (value: String) -> Int in
                return Int(value) ?? 1
            })
            print(numbersInt)
            foodDateArray.append(numbersInt)
            print(foodDateArray)
//            selectDay = (array_num["date"] ?? "test").components(separatedBy: "/")
        }
        
        
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate let gregorian: Calendar = Calendar(identifier: .gregorian)
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    // 祝日判定を行い結果を返すメソッド(True:祝日)
    func judgeHoliday(_ date : Date) -> Bool {
        //祝日判定用のカレンダークラスのインスタンス
        let tmpCalendar = Calendar(identifier: .gregorian)
        
        // 祝日判定を行う日にちの年、月、日を取得
        let year = tmpCalendar.component(.year, from: date)
        let month = tmpCalendar.component(.month, from: date)
        let day = tmpCalendar.component(.day, from: date)
        
        // CalculateCalendarLogic()：祝日判定のインスタンスの生成
        let holiday = CalculateCalendarLogic()
        
        return holiday.judgeJapaneseHoliday(year: year, month: month, day: day)
    }
    // date型 -> 年月日をIntで取得
    func getDay(_ date:Date) -> (Int,Int,Int){
        let tmpCalendar = Calendar(identifier: .gregorian)
        let year = tmpCalendar.component(.year, from: date)
        let month = tmpCalendar.component(.month, from: date)
        let day = tmpCalendar.component(.day, from: date)
        return (year,month,day)
    }
    
    //曜日判定(日曜日:1 〜 土曜日:7)
    func getWeekIdx(_ date: Date) -> Int{
        let tmpCalendar = Calendar(identifier: .gregorian)
        return tmpCalendar.component(.weekday, from: date)
    }
    
    // 土日や祝日の日の文字色を変える
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        //祝日判定をする（祝日は赤色で表示する）
        if self.judgeHoliday(date){
            return UIColor.red
        }
        
        //土日の判定を行う（土曜日は青色、日曜日は赤色で表示する）
        let weekday = self.getWeekIdx(date)
        if weekday == 1 {   //日曜日
            return UIColor.red
        }
        else if weekday == 7 {  //土曜日
            return UIColor.blue
        }
        
        return nil
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition){
//        print(getDay(date))
        selectDay = getDay(date)
    }
    
    @IBAction func saveSchedule() {
        print(selectDay)
        
        if foodTextField.text == "" {
            print("TEST")
            let alert = UIAlertController(
                title: "食材が入力されてません",
                message: "食材名を入力してください",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(
                title: "OK",
                style: .default,
                handler: nil
            ))
            
            self.present(alert, animated: true, completion: nil)
        } else if selectDay == (0,0,0) {

            let alert = UIAlertController(
                title: "日付が選択されてません",
                message: "期限日をカレンダーから選択してください",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(
                title: "OK",
                style: .default,
                handler: nil
            ))
            self.present(alert, animated: true, completion: nil)
            
        } else {
            
            for (Index, element) in foodDateArray.enumerated(){
                print("\(Index), \(element)")
            }
            
            StringselectDay = "\(selectDay.0)/\(selectDay.1)/\(selectDay.2)"
            let foodDictionary = ["food": foodTextField.text!, "date": StringselectDay]
            print(foodDictionary)
            print(foodArray)
            
            
            // リストのソート（期限日が近いほど上に来る）
            if foodDateArray.count == 0{
                foodArray.append(foodDictionary)
            } else if foodDateArray.count == 1 {
                if (foodDateArray[0][0] > selectDay.0) || ((foodDateArray[0][0] == selectDay.0) && (foodDateArray[0][1] > selectDay.1)) || ((foodDateArray[0][0] == selectDay.0) && (foodDateArray[0][1] == selectDay.1) && (foodDateArray[0][2] > selectDay.2)) {
                    foodArray.insert(foodDictionary, at: 0)
                } else {
                    foodArray.append(foodDictionary)
                }
            } else {
                for (index, Array_element) in foodDateArray.enumerated() {
                    if (foodDateArray[index][0] > selectDay.0) || ((foodDateArray[index][0] == selectDay.0) && (foodDateArray[index][1] > selectDay.1)) || ((foodDateArray[index][0] == selectDay.0) && (foodDateArray[index][1] == selectDay.1) && (foodDateArray[index][2] > selectDay.2)) {
                        foodArray.insert(foodDictionary, at: index)
                        break
                    } else if (index == foodArray.count - 1) {
                        foodArray.append(foodDictionary)
                    }
                }
            }
            
            
            
//            foodDateArray.append(selectDay)
//            print(foodDateArray)
            
            saveDate.set(foodArray, forKey: "FOOD")
            
            let alert = UIAlertController(
                title: "登録完了",
                message: "食材名：\(foodTextField.text ?? "テスト")\n日付：\(selectDay.0)年\(selectDay.1)月\(selectDay.2)日",
                preferredStyle: .alert
            )
            
            alert.addAction(UIAlertAction(
                title: "OK",
                style: .default,
                handler:{(action: UIAlertAction!) in
                    
                    //アラートが消えるのと画面遷移が重ならないように0.1秒後に画面遷移するようにしてる
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        // 0.5秒後に実行したい処理
                        self.performSegue(withIdentifier: "Totoppage", sender: nil)
                    }
            }
            ))
            
            self.present(alert, animated: true, completion: nil)
            // self.performSegue(withIdentifier: "ViewController", sender: nil)
            foodTextField.text = ""
            //        japaneseTextField.text = ""
            
        }
        
    }

    
}
