//
//  shop.swift
//  Mechanic - Chain Of Responsibility
//
//  Created by Reza Shirazian on 2016-04-07.
//  Copyright © 2016 Reza Shirazian. All rights reserved.
//

import Foundation

class Shop {

  private var firstMechanics: MechanicSkillGroup

  init(firstMechanics: MechanicSkillGroup) {
      self.firstMechanics = firstMechanics
  }

  func performJob(job: Job) -> Bool {
    return firstMechanics.performJobOrPassItUp(job)
  }
}
