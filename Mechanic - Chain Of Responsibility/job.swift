//
//  job.swift
//  Mechanic - Chain Of Responsibility
//
//  Created by Reza Shirazian on 2016-04-07.
//  Copyright © 2016 Reza Shirazian. All rights reserved.
//

import Foundation

class Job{
  let minimumSkillSet: Skill
  let name: String
  var completed: Bool = false
  
  init(minimumSkillSet: Skill, name: String){
    self.minimumSkillSet = minimumSkillSet
    self.name = name
  }
}