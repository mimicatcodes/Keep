//
//  ViewController.swift
//  tableViewPractice
//
//  Created by Mirim An on 2/14/17.
//  Copyright © 2017 Mimicatcodes. All rights reserved.
//

import UIKit

struct Quiz {
    
    var sectionName : String
    var questions : [String]
    
}

class ViewController: UITableViewController {

    var objectsArray = [Quiz]()
    
    let personalityData = [
        
        "Enjoy trying out new products", "Stay up to date on the latest and greatest in tech and devices","Want to get involved in tech, but not sure where to start", "Enjoy puzzles and challenges", "Enjoy tinkering with computers and devices","Are curious about how tech products work", "Enjoy fast-paced work", "Enjoy solving problems", "Have a creative spirit",
        "Love following the latest web trends & technologies",
        "Think logically and critically",
        "Have tried or are interested in learning how to code", "Are iPhone or Android obsessed", "Are Always on the hunt for the latest cool app",
        "Enjoy learning about new technology",
        "Have strong preferences for specific technology or apps",
        "Have tried or areinterested in learning how to code", "Able to work across teams and with a variety of stakeholders",
        "Communicate effectively and build strong relationships with team members",
        "Have a knack for math, facts and figures",
        "Love simplifying complex ideas"
    ]
    
    let techJobs = [
        "Quality Assurance Analyst","IT Engineer","Web Developer","Mobile Developer","Data Analyst"
    ]
    
    let questions = ["When it comes to interacting with technology, are you someone who:", "Which best describes your current relationship with technology?","How would you prefer to spend your time?", "Which activity below sounds most appealing to you?","How would you prefer to spend your time at work in a technology role?", "Overall, what should sum up the work you do?"] // 6
    
    let answers = [["Enjoys trying out new products",
                    "Enjoys tinkering with computers and devices",
                    "Prefers the creative aspect of working in technology",
                    "Is iPhone or Android obsessed",
                    "Enjoys working and discovering new facts, data and technologies"],
                   ["You stay up to date on the latest and greatest in tech and devices",
                    "You are curious about how tech products work",
                    "You love following the latest web trends & technologies",
                    "You’re always on the hunt for the latest cool app",
                    "You’re interested all things that are based on, backed by or involve data"],
                   ["Figuring out puzzles and challenges",
                                                                                                "Solving problems",
                                                                                                                                                                         "Thinking logically and critically",
                                                                                                                                                                         "Constantly learning about new technology",
                                                                                                                                                                         "Simplifying complex ideas"],["Help find and fix mistakes before an app, site or other feature launches",
                                                                                                                                                                                                       "Resolve issues that affect users and systems",
                                                                                                                                                                                                       "Ensure that website designs are intuitive, easy to access and uniform throughout",
                                                                                                                                                                                                       "Create and improve mobile experiences for customers across multiple devices",
                                                                                                                                                                                                       "Measure performance across a company, product or website and provide valuable feedback"],["Designing innovative new ways to test, find and diagnose problems",
                                                                                                                                                                                                                                                                                                  "Setting up and updating systems across the company",
                                                                                                                                                                                                                                                                                                  "Building interactive websites and web apps that allow people to communicate and interact",
                                                                                                                                                                                                                                                                                                  "Translating an idea into an app",
                                                                                                                                                                                                                                                                                                  "Solving problems and answering questions using data"],
                                                                                                                                                                                                                                                                                                 ["Test the limits", "Keep things up and running", "Build online experiences", "Create amazing apps","Find hidden stories"]
    ]
    
    // create a dictionary with tech jobs and personalities combined maybe
    
    var qaAnalystScore = 0
    var itEngineerScore = 0
    var webDevScore = 0
    var mobileDevScore = 0
    var dataAnalystScore = 0
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.separatorStyle = .none
        for i in 0..<6 {
            let quizObject = Quiz(sectionName: questions[i], questions: answers[i])
            objectsArray.append(quizObject)
        }
        
        tableView.allowsMultipleSelection = true

    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = objectsArray[indexPath.section].questions[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.font = UIFont(name: "System", size: 12)
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return objectsArray.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objectsArray[section].questions.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return objectsArray[section].sectionName
    }
    
//    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
//        
//        let selectedIndexPaths = indexPathsForSelectedRowsInSection(section: indexPath.section)
//        
//        if selectedIndexPaths?.count == 1 {
//            tableView.deselectRow(at: selectedIndexPaths!.first! as IndexPath, animated: false)
//        }
//        
//        return indexPath
//    }
//    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.backgroundColor = UIColor.black
        label.textColor = UIColor.white
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.text = objectsArray[section].sectionName
        return label
    }

//    func indexPathsForSelectedRowsInSection(section: Int) -> [IndexPath]? {
//        return (tableView.indexPathsForSelectedRows)?.filter({ (indexPath) -> Bool in
//            indexPath.section == section
//        })
//    }
    
}

