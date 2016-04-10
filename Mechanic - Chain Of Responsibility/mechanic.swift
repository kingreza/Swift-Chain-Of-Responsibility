//
//  Mechanic.swift
//  Mechanic - Chain Of Responsibility
//
//  Created by Reza Shirazian on 2016-04-07.
//  Copyright © 2016 Reza Shirazian. All rights reserved.
//

import Foundation

class Mechanic{
  let skill: Skill
  var name: String
  var isBusy: Bool = false
  
  init(skill: Skill, name: String){
    self.skill = skill
    self.name = name
  }
  
  func performJob(job: Job) -> Bool{
    if job.minimumSkillSet > self.skill || isBusy == true{
      assert(false, "This mechanic is either busy or insufficiently skilled for this job, he should have never been asked to perform it, there is something wrong in the chain of responsibility");
    }else
    {
      isBusy = true
      print("\(name) with skill set \(skill) has started to do \(job.name)")
      job.completed = true
      return true
    }
  }
}