//
//  MenuViewController.swift
//  MonsterTrainer
//
//  Created by loaner on 12/9/23.

import UIKit

class MenuViewController: UIViewController, ModalTransitionListener{
    var first:Bool = false
    var stepStretchGoalMet:Bool = false
    var flightStretchGoalMet:Bool = false
    var distanceStretchGoalMet:Bool = false
    var lvlProg:Float = 0

    // MARK: =====UI Properties=====
    @IBOutlet weak var stepLabel: UILabel!
    @IBOutlet weak var stretchGoalBar: UIProgressView!
    @IBOutlet weak var goalMenu: UIView!
    @IBOutlet weak var normalGoalBar: UIProgressView!
    @IBOutlet weak var flightsGoalBar: UIProgressView!
    @IBOutlet weak var flightsLabel: UILabel!
    @IBOutlet weak var flightsStretchGoalBar: UIProgressView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var currentMonster: UIImageView!
    @IBOutlet weak var lvlProgress: UIProgressView!
    @IBOutlet weak var evolveButton: UIButton!
    @IBOutlet weak var flightsGoalButton: UIButton!
    @IBOutlet weak var distanceGoalButton: UIButton!
    @IBOutlet weak var distanceStretchGoalBar: UIProgressView!
    @IBOutlet weak var distanceGoalBar: UIProgressView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var stepGoalButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FitnessModel.myFitness.startPedometerMonitoring()
        Mediator.instance.setListener(listener: self)
        if (!CreatureModel.shared.getSelected()) {
            first = true
            selectStarter()
        }
    }
    
    func selectStarter() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let selectionViewController = storyboard.instantiateViewController(withIdentifier: "SelectionViewController") as! SelectionViewController
        self.present(selectionViewController, animated: true)
    }
    
    func setUp(){
        self.stepGoalButton.isEnabled = false
        self.flightsGoalButton.isEnabled = false
        self.distanceGoalButton.isEnabled = false
        self.lvlProgress.transform = CGAffineTransformScale(lvlProgress.transform, 1, 3)
        goalMenu.layer.cornerRadius = 10
        titleLabel.text = "Goals"
        stepLabel.text = "Steps: " + String(format: "%.0f", FitnessModel.myFitness.getStepGoal()) + " ~ " + String(format: "%.1f", FitnessModel.myFitness.getStepStretchGoal())
        flightsLabel.text = "Flights: " + String(format: "%.0f", FitnessModel.myFitness.getFlightGoal()) + " ~ " + String(format: "%.0f", FitnessModel.myFitness.getFlightStretchGoal())
        distanceLabel.text = "Distance: " + String(format: "%.0f", FitnessModel.myFitness.getDistanceGoal()) + " ~ " + String(format: "%.0f", FitnessModel.myFitness.getDistanceStretchGoal()) + "m"
        
        self.normalGoalBar.setProgress(FitnessModel.myFitness.todaySteps/FitnessModel.myFitness.getStepGoal(), animated: false)
        self.normalGoalBar.transform = CGAffineTransformScale(normalGoalBar.transform, 1, 3)
        self.stretchGoalBar.setProgress(FitnessModel.myFitness.todayDistance/FitnessModel.myFitness.getStepStretchGoal(), animated: false)
        self.stretchGoalBar.transform = CGAffineTransformScale(stretchGoalBar.transform, 1, 3)
        self.stretchGoalBar.progressTintColor = UIColor.red
        
        self.flightsGoalBar.setProgress(FitnessModel.myFitness.todayFlights/FitnessModel.myFitness.getFlightGoal(), animated: false)
        self.flightsGoalBar.transform = CGAffineTransformScale(flightsGoalBar.transform, 1, 3)
        self.flightsStretchGoalBar.setProgress(FitnessModel.myFitness.todayFlights/FitnessModel.myFitness.getFlightStretchGoal(), animated: false)
        self.flightsStretchGoalBar.transform = CGAffineTransformScale(flightsStretchGoalBar.transform, 1, 3)
        self.flightsStretchGoalBar.progressTintColor = UIColor.red
        
        self.distanceGoalBar.setProgress(FitnessModel.myFitness.todayDistance/FitnessModel.myFitness.getDistanceGoal(), animated: false)
        self.distanceGoalBar.transform = CGAffineTransformScale(distanceGoalBar.transform, 1, 3)
        self.distanceStretchGoalBar.setProgress(FitnessModel.myFitness.todayDistance/FitnessModel.myFitness.getDistanceStretchGoal(), animated: false)
        self.distanceStretchGoalBar.transform = CGAffineTransformScale(distanceStretchGoalBar.transform, 1, 3)
        self.distanceStretchGoalBar.progressTintColor = UIColor.red
        setCurrentMonster(first)
        checkGoals()
    }
    
    func checkGoals() {
        if (FitnessModel.myFitness.todaySteps > FitnessModel.myFitness.getStepGoal()) {
            stepGoalButton.isEnabled = true
        }
        if (FitnessModel.myFitness.todaySteps > FitnessModel.myFitness.getStepStretchGoal()) {
            stepGoalButton.isEnabled = true
            stepStretchGoalMet = true
        }
        if (FitnessModel.myFitness.todayFlights > FitnessModel.myFitness.getFlightGoal()) {
            flightsGoalButton.isEnabled = true
        }
        if (FitnessModel.myFitness.todayFlights > FitnessModel.myFitness.getFlightStretchGoal()) {
            flightsGoalButton.isEnabled = true
            flightStretchGoalMet = true
            
        }
        if (FitnessModel.myFitness.todayDistance > FitnessModel.myFitness.getDistanceGoal()) {
            distanceGoalButton.isEnabled = true
        }
        if (FitnessModel.myFitness.todayDistance > FitnessModel.myFitness.getDistanceStretchGoal()) {
            distanceGoalButton.isEnabled = true
            distanceStretchGoalMet = true
        }
    }
    
    func setCurrentMonster(_ first: Bool) {
        currentMonster.image = CreatureModel.shared.getCurrentMonsterSprite()
        if (!first) {
            self.lvlProgress.progress = ( CreatureModel.shared.getXp(CreatureModel.shared.getCurrentMonsterName())/CreatureModel.shared.getLvlXp(CreatureModel.shared.getCurrentMonsterName()))
            self.evolveButton.setTitle("\(CreatureModel.shared.getLvl(CreatureModel.shared.getCurrentMonsterName()))", for: .normal)
        }
    }
    
    func popoverDismissed() {
        self.navigationController?.dismiss(animated: true, completion: nil)
        if (CreatureModel.shared.getCurrentMonsterName() != "Unknown") {
            first = false
        }
        setCurrentMonster(first)
        setUp()
    }
    @IBAction func fitnessStatsTapped(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let statsView  = storyBoard.instantiateViewController(withIdentifier: "FitnessViewController") as! FitnessViewController
        self.navigationController?.pushViewController(statsView, animated: true)
    }
    

    @IBAction func creatureTapped(_ sender: Any) {
        CreatureModel.shared.setStatsMonster(CreatureModel.shared.getCurrentMonsterName())
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let statsView  = storyBoard.instantiateViewController(withIdentifier: "StatsViewController") as! StatsViewController
        self.navigationController?.pushViewController(statsView, animated: true)
    }
    
    @IBAction func stepGoalButtonTapped(_ sender: Any) {
        lvlProg += 1
        lvlProgress.setProgress(lvlProg/3, animated: true)
        stepGoalButton.isEnabled = false
    }
    
    @IBAction func distanceGoalButtonTapped(_ sender: Any) {
        lvlProg += 1
        lvlProgress.setProgress(lvlProg/3, animated: true)
        distanceGoalButton.isEnabled = false
    }
}
