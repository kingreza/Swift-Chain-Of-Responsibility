//
//  main.swift
//  Mechanic - Chain Of Responsibility
//
//  Created by Reza Shirazian on 2016-04-07.
//  Copyright © 2016 Reza Shirazian. All rights reserved.
//

import Foundation

var steve = Mechanic(skill: .MasterMechanic, name: "Steve Frank")
var joe = Mechanic(skill: .MasterMechanic, name: "Joe Alison")
var jack = Mechanic(skill: .MasterMechanic, name: "Jack Ryan")
var brian = Mechanic(skill: .MasterMechanic, name: "Drake Jin")

var masterMechanics = MechanicSkillGroup(skill: .MasterMechanic,
                                         mechanics: [steve, joe, jack, brian],
                                         nextLevel: nil)

var tyson = Mechanic(skill: .Apprentice, name: "Tyson Trump")
var tina = Mechanic(skill: .Apprentice, name: "Tina Bernard")
var bryan = Mechanic(skill: .Apprentice, name: "Bryan Tram")
var lin = Mechanic(skill: .Apprentice, name: "Lin Young")

var apprenticeMechanics = MechanicSkillGroup(skill: .Apprentice,
                                             mechanics: [tyson, tina, bryan, lin],
                                             nextLevel: masterMechanics)

var ken = Mechanic(skill: .Junior, name: "Ken Hudson")
var matt = Mechanic(skill: .Junior, name: "Matt Lowes")
var sandeep = Mechanic(skill: .Junior, name: "Sandeep Shenoy")
var tom = Mechanic(skill: .Junior, name: "Tom Berry")

var juniorMechanics = MechanicSkillGroup(skill: .Junior,
                                         mechanics: [ken, matt, sandeep, tom],
                                         nextLevel: apprenticeMechanics)

var grant = Mechanic(skill: .OilChangeOnly, name: "Grant Hughes")
var larry = Mechanic(skill: .OilChangeOnly, name: "Larry White")
var bryant = Mechanic(skill: .OilChangeOnly, name: "Bryant Newman")
var reza = Mechanic(skill: .OilChangeOnly, name: "Reza Shirazian")
var laura = Mechanic(skill: .OilChangeOnly, name: "Laura Lee")
var arnold = Mechanic(skill: .OilChangeOnly, name: "Arnold Shummer")

var oilChangeOnlyes = MechanicSkillGroup(skill: .OilChangeOnly,
                                         mechanics: [grant],
                                         nextLevel: juniorMechanics)

var shop = Shop(firstMechanics: oilChangeOnlyes)

var jobs = [Job(minimumSkillSet: .Junior, name: "Windshield Viper"),
            Job(minimumSkillSet: .Apprentice, name: "Light Bulb Change"),
            Job(minimumSkillSet: .Apprentice, name: "Battery Replacement"),
            Job(minimumSkillSet: .OilChangeOnly, name: "General Oil Change"),
            Job(minimumSkillSet: .OilChangeOnly, name: "General Oil Change"),
            Job(minimumSkillSet: .OilChangeOnly, name: "General Oil Change"),
            Job(minimumSkillSet: .OilChangeOnly, name: "General Oil Change"),
            Job(minimumSkillSet: .MasterMechanic, name: "Timing Belt Replacement"),
            Job(minimumSkillSet: .Junior, name: "Brake Pads Replacement")
]

for job in jobs {
  shop.performJob(job)
}
