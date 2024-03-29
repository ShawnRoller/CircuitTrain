//
//  EditWorkoutViewController.swift
//  CircuitTrain
//
//  Created by Shawn Roller on 4/22/15.
//  Copyright (c) 2015 OffensivelyBad. All rights reserved.
//

import UIKit

class EditWorkoutViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        previousView = "Edit"
        
        exerciseNumber = -1
        
        tableView.setEditing(true, animated: false)
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var exerciseCount:Int = 0
        
        if let exercises = editingWorkout["exercises"] {
        
            exerciseCount =  exercises.count
            
        }
        
        return exerciseCount
        
    }
    
    @IBAction func add(sender: AnyObject) {
        
        if let exerciseArray = editingWorkout["exercises"] {
            
            exerciseNumber = exerciseArray.count
            
        } else {
            
            exerciseNumber = 0
            
        }
        
        performSegueWithIdentifier("editNewSegue", sender: sender)
        
    }
    
    @IBAction func save(sender: AnyObject) {
        //add saving of exercises
        if var exerciseTimes = editingWorkout["exerciseTimes"], exerciseIntensities = editingWorkout["exerciseIntensities"], exerciseSets = editingWorkout["exerciseSets"] {
            
            var totalTime:Int = 0
            var totalIntensity:Int = 0
            var totalSets:Int = 0
            
            for times in exerciseTimes {
                
                totalTime += times.toInt()!
                
            }
            for intensity in exerciseIntensities {
                
                totalIntensity += intensity.toInt()!
                
            }
            for set in exerciseSets {
                
                totalSets += set.toInt()!
                
            }
            
            editingWorkout["time"] = []
            editingWorkout["time"]?.append(String(totalTime))
            
            editingWorkout["intensity"] = []
            editingWorkout["intensity"]?.append(String(totalIntensity))
            
            editingWorkout["sets"] = []
            editingWorkout["sets"]?.append(String(totalSets))
            
            workouts[workoutNumber] = editingWorkout
            
        }
        
        performSegueWithIdentifier("editSelectSegue", sender: sender)
        
    }
    

    @IBAction func cancel(sender: AnyObject) {
        
        performSegueWithIdentifier("editSelectSegue", sender: sender)
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let tableViewCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        
        //add exerciseIntensity
        if let thisExerciseArray = editingWorkout["exercises"], thisExerciseTimeArray = editingWorkout["exerciseTimes"], thisExerciseSetArray = editingWorkout["exerciseSets"] {
            
            let thisExerciseName = thisExerciseArray[indexPath.row]
            let thisExerciseNameLabel = tableViewCell.viewWithTag(201) as! UILabel
            thisExerciseNameLabel.text = thisExerciseName
            
            let thisExerciseTime = thisExerciseTimeArray[indexPath.row]
            let thisExerciseTimeLabel = tableViewCell.viewWithTag(202) as! UILabel
            thisExerciseTimeLabel.text = thisExerciseTime
            
            let thisExerciseSet = thisExerciseSetArray[indexPath.row]
            let thisExerciseSetLabel = tableViewCell.viewWithTag(203) as! UILabel
            thisExerciseSetLabel.text = thisExerciseSet
            
            
        }
        
        return tableViewCell
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let title = sender?.title {
        
            if title == "Cancel" {
                
                println("cancelled")
                
            } else if title == "Save" {
                
                println("saved")
                
            }
        
        }
        
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool { return true }
    
    func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        
        if var thisExerciseArray = editingWorkout["exercises"], thisExerciseTimeArray = editingWorkout["exerciseTimes"], thisExerciseSetArray = editingWorkout["exerciseSets"], thisExerciseIntensityArray = editingWorkout["exerciseIntensities"] {
            
            let movedExercise = thisExerciseArray[fromIndexPath.row]
            thisExerciseArray.removeAtIndex(fromIndexPath.row)
            thisExerciseArray.insert(movedExercise, atIndex: toIndexPath.row)
            
            let movedExerciseTime = thisExerciseTimeArray[fromIndexPath.row]
            thisExerciseTimeArray.removeAtIndex(fromIndexPath.row)
            thisExerciseTimeArray.insert(movedExerciseTime, atIndex: toIndexPath.row)
            
            let movedExerciseSet = thisExerciseSetArray[fromIndexPath.row]
            thisExerciseSetArray.removeAtIndex(fromIndexPath.row)
            thisExerciseSetArray.insert(movedExerciseSet, atIndex: toIndexPath.row)
            
//            let movedExerciseIntensity = thisExerciseIntensityArray[fromIndexPath.row]
//            thisExerciseIntensityArray.removeAtIndex(fromIndexPath.row)
//            thisExerciseIntensityArray.insert(movedExerciseIntensity, atIndex: toIndexPath.row)
            
            editingWorkout["exercises"] = thisExerciseArray
            editingWorkout["exerciseTimes"] = thisExerciseTimeArray
            editingWorkout["exerciseSets"] = thisExerciseSetArray
            editingWorkout["exerciseIntensities"] = thisExerciseIntensityArray
            
        }
        
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
            if var thisExerciseArray = editingWorkout["exercises"], thisExerciseTimeArray = editingWorkout["exerciseTimes"], thisExerciseSetArray = editingWorkout["exerciseSets"], thisExerciseIntensityArray = editingWorkout["exerciseIntensities"], thisSet = editingWorkout["sets"] {
                
                thisExerciseArray.removeAtIndex(indexPath.row)
                
                thisExerciseTimeArray.removeAtIndex(indexPath.row)
                
                thisExerciseSetArray.removeAtIndex(indexPath.row)
                
                //thisExerciseIntensityArray.removeAtIndex(indexPath.row)
                
                editingWorkout["exercises"] = thisExerciseArray
                editingWorkout["exerciseTimes"] = thisExerciseTimeArray
                editingWorkout["exerciseSets"] = thisExerciseSetArray
                editingWorkout["exerciseIntensities"] = thisExerciseIntensityArray
            
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
         
            }
            
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        exerciseNumber = indexPath.row
        
        performSegueWithIdentifier("editPageSegue", sender: self)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
