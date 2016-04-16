//
//  skill.swift
//  Mechanic - Chain Of Responsibility
//
//  Created by Reza Shirazian on 2016-04-07.
//  Copyright © 2016 Reza Shirazian. All rights reserved.
//

import Foundation

enum Skill: Int, Comparable {
  case OilChangeOnly = 0, Junior, Apprentice, MasterMechanic
}

func < (lhs: Skill, rhs: Skill) -> Bool {
  return lhs.rawValue < rhs.rawValue
}

func == (lhs: Skill, rhs: Skill) -> Bool {
  return lhs.rawValue == rhs.rawValue
}
