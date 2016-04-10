//
//  main.swift
//  Mechanic - Chain Of Responsibility
//
//  Created by Reza Shirazian on 2016-04-07.
//  Copyright © 2016 Reza Shirazian. All rights reserved.
//

import Foundation

var steve = Mechanic(skill: .MasterMechanic, name: "Steve Frank", nextMechanics: [])
var joe = Mechanic(skill: .MasterMechanic, name: "Joe Alison", nextMechanics: [])
var jack = Mechanic(skill: .MasterMechanic, name: "Jack Ryan", nextMechanics: [])
var brian = Mechanic(skill: .MasterMechanic, name: "Drake Jin", nextMechanics: [])

var masterMechanics = [steve, joe, jack, brian]

var tyson = Mechanic(skill: .Apprentice, name: "Tyson Trump", nextMechanics: masterMechanics)
var tina = Mechanic(skill: .Apprentice, name: "Tina Bernard", nextMechanics: masterMechanics)
var bryan = Mechanic(skill: .Apprentice, name: "Bryan Tram", nextMechanics: masterMechanics)
var lin = Mechanic(skill: .Apprentice, name: "Lin Young", nextMechanics: masterMechanics)

var apprenticeMechanics = [tyson, tina, bryan, lin]

var ken = Mechanic(skill: .Junior, name: "Ken Hudson", nextMechanics: apprenticeMechanics)
var matt = Mechanic(skill: .Junior, name: "Matt Lowes", nextMechanics: apprenticeMechanics)
var sandeep = Mechanic(skill: .Junior, name: "Sandeep Shenoy", nextMechanics: apprenticeMechanics)
var tom = Mechanic(skill: .Junior, name: "Tom Berry", nextMechanics: apprenticeMechanics)

var juniorMechanics = [ken, matt, sandeep, tom]

var grant = Mechanic(skill: .OilChangeOnly, name: "Grant Hughes", nextMechanics: juniorMechanics)
var larry = Mechanic(skill: .OilChangeOnly, name: "Larry White", nextMechanics: juniorMechanics)
var bryant = Mechanic(skill: .OilChangeOnly, name: "Bryant Newman", nextMechanics: juniorMechanics)
var reza = Mechanic(skill: .OilChangeOnly, name: "Reza Shirazian", nextMechanics: juniorMechanics)
var laura = Mechanic(skill: .OilChangeOnly, name: "Laura Lee", nextMechanics: juniorMechanics)
var arnold = Mechanic(skill: .OilChangeOnly, name: "Arnold Shummer", nextMechanics: juniorMechanics)

var oilChangeOnlyes = [grant, larry, bryant, reza, laura, arnold]

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

for job in jobs{
  shop.performJob(job)
}