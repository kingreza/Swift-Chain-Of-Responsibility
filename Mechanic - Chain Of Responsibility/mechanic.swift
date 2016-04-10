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
  var isbusy: Bool = false
  var nextMechanics:[Mechanic]
  
  init(skill: Skill, name: String, nextMechanics: [Mechanic]){
    self.skill = skill
    self.name = name
    self.nextMechanics = nextMechanics
  }
  
  func performJobOrPassItUp(job: Job) -> Bool{

    if isbusy{
      return false
    }
    if job.minimumSkillSet.rawValue <= self.skill.rawValue{
      self.isbusy = true
      job.completed = true
      print("\(name) with skill set \(skill) has started to do \(job.name)")
      return true
    }else
    {
      for mechanic in nextMechanics{
        if mechanic.performJobOrPassItUp(job){
          return true
        }
      }
      return false
    }
  }
}