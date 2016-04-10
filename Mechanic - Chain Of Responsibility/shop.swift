//
//  shop.swift
//  Mechanic - Chain Of Responsibility
//
//  Created by Reza Shirazian on 2016-04-07.
//  Copyright © 2016 Reza Shirazian. All rights reserved.
//

import Foundation

class Shop{
 
  private var firstMechanics: [Mechanic]
  
  init(firstMechanics: [Mechanic]){
          
      self.firstMechanics = firstMechanics
  }
  
  func performJob(job: Job)
  {
    var performed = false
    for mechanic in firstMechanics{
      if mechanic.performJobOrPassItUp(job){
        performed = true
        break
      }
    }
    if !performed{
      print("No one is available to do this job.")
    }
  }
}