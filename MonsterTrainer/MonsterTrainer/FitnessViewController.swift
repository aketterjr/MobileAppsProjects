//
//  FitnessViewController.swift
//  MonsterTrainer
//
//  Created by loaner on 12/12/23.
//

import UIKit
import Charts

class FitnessViewController: UIViewController{
    @IBOutlet weak var fitnessDescription: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // add in graphs for display
        fitnessDescription.text = "Todays Steps: \(FitnessModel.myFitness.todaySteps), Yesterday's Steps: \(FitnessModel.myFitness.weekSteps[0])\nSunday's Steps: \(FitnessModel.myFitness.weekSteps[1]), Saturday's Steps: \(FitnessModel.myFitness.weekSteps[2])\nFriday's Steps: \(FitnessModel.myFitness.weekSteps[3]), Thursday's Steps: \(FitnessModel.myFitness.weekSteps[4])\nWednesday's Steps: \(FitnessModel.myFitness.weekSteps[5])\nTodays Flights (of stairs): \(FitnessModel.myFitness.todayFlights), Yesterday's Flights: \(FitnessModel.myFitness.weekFlights[0])\nSunday's Flights: \(FitnessModel.myFitness.weekFlights[1]), Saturday's Flights: \(FitnessModel.myFitness.weekFlights[2])\nFrisday's Flights: \(FitnessModel.myFitness.weekFlights[3]), Thursday's Flights: \(FitnessModel.myFitness.weekFlights[4])\nWednesday's Flights: \(FitnessModel.myFitness.weekFlights[5])\nTodays Distance: \(FitnessModel.myFitness.todayDistance), Yesterday's Distance: \(FitnessModel.myFitness.weekDistances[0])\nSunday's Distance: \(FitnessModel.myFitness.weekDistances[1]), Saturday's Distance: \(FitnessModel.myFitness.weekDistances[2])\nFriday's Distance: \(FitnessModel.myFitness.weekDistances[3]), Thursday's Distance: \(FitnessModel.myFitness.weekDistances[4])\nWednesday's Distance: \(FitnessModel.myFitness.weekDistances[5])"
    }
}
