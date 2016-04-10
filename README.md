<h3>The problem:</h3>
Not all mechanics are created equally. Some mechanics are more experienced and can do more than others. We need a system where every job is propagated from the least experienced mechanic to the most. This way  experienced mechanics that can perform more jobs are not busy with jobs that more junior mechanics can take care of.
<h3>The solution:</h3>
We will break down our mechanics into four different skill levels: oil change only, junior, apprentice and master mechanic. Every mechanic will have their skill level assigned to one of these four values. Each mechanic skill level will also have a reference to a set of mechanics that are at the next skill level. We will then define a virtual shop and pass it our first line of mechanics (our most junior fleet).  Next we will define a set of jobs we wish to perform along with the minimum skill level required. We will pass these jobs to our virtual shop which in turn goes through each skill level, trying to find the mechanic with the minimum skills set required to do the job.

Link to the repo for the completed project: <a href="https://github.com/kingreza/Swift-Chain-Of-Responsibility"> Swift - Chain Of Responsibility </a>

Let's begin

We'll start off by defining our different skill sets using an enumerable.
````swift
import Foundation

enum Skill: Int{
  case OilChangeOnly = 1, Junior, Apprentice, MasterMechanic
}
````

Next we'll define our job object:
````swift
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
````

The job object will have three properties, minimumSkillSet which is of type skill that we define earlier. This is the minimum level a mechanic needs to be to complete this job. We also define a name for naming our job and a completed flag which will indicate if the job has been completed. We set its minimumskillSet and name in its initializer. 

Next we'll define our mechanic object:

````swift
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
````


Our Mechanic class is not that complicated. Mechanics have a skill property which indicates the mechanic's ability. They have a name, since all our mechanic's have a name. And finally an isBusy flag which indicates if the mechanic is available to do the job. We initialize the skill set and name of the mechanics in our initializer and set our isBusy flag to false by default. 

Our Mechanic class also has a performJob function that takes a job as a parameter. The way we are going to design our system is in such a way that it will make sure the mechanic that gets the job is both available and has its skill matched before this function is called. This is why we assert that if a job is being passed to a mechanic that is not compatible with his/her skill set or if the mechanic is busy, that there is something wrong with our code. I find this to be a better solution to using a guard since calling performJob on an incompatible job or a busy mechanic is an exception and would mean there is a bug in our code.

The perform job method simply performs the job, sets the mechanic to busy and the job to completed. 

Here is where things get interesting. Next up we are going to define a MechanicSkillGroup object. This class will contain an inventory of all mechanics within its skillset and a link to the MechanicSkillGroup with mechanics at the next level. This class will function as a container for all mechanics that share the same skill level. Here is how it looks like:
 
````swift
import Foundation

class MechanicSkillGroup{
  
  var mechanics: [Mechanic]
  var nextLevel: MechanicSkillGroup?
  var skill: Skill
  
  init(skill: Skill, mechanics: [Mechanic], nextLevel: MechanicSkillGroup?){
    self.mechanics = mechanics
    self.skill = skill
    self.nextLevel = nextLevel
  }
  
  func performJobOrPassItUp(job: Job) -> Bool{
    if (job.minimumSkillSet > skill || mechanics.filter({$0.isBusy == false}).count == 0){
      if let nextLevel = nextLevel{
        return nextLevel.performJobOrPassItUp(job)
      }else{
        print("No one is available to do this job")
        return false
      }
    }else{
      if let firstAvailableMechanic = mechanics.filter({$0.isBusy == false}).first{
        return firstAvailableMechanic.performJob(job)
      }
      assert(false, "This should never be reached since our if-else statment is fully exhaustive. You cannot have both all mechanics busy and an available mechanic within one skill group");
    }
  }
}
````

Lets go through it step by step so we understand what's going on here:

````swift
class MechanicSkillGroup{
  
  var mechanics: [Mechanic]
  var nextLevel: MechanicSkillGroup?
  var skill: Skill
  
  init(skill: Skill, mechanics: [Mechanic], nextLevel: MechanicSkillGroup?){
    self.mechanics = mechanics
    self.skill = skill
    self.nextLevel = nextLevel
  }
````

Our MechanicSkillGroup class has three properties. First off we have mechanics which is a collection of all mechanics that share the skill group's skill set. Next we have nextLevel which is an optional reference to another MechanicSkillGroup. This will be a pointer to the MechanicSkillGroup set for the next level of mechanics. The reason this is set to optional is because at the MasterMechanic skill level, we will be at the end of the chain, no other MechanicSkillGroup will come after it. Finally we have our skill property which is set to what this MechanicSkillGroup is representing. We initialize these values in our initializer. 

Next up we define a function within our MechanicSkillGroup class called performJobOrPasstUp. 
````swift
  func performJobOrPassItUp(job: Job) -> Bool{
    if (job.minimumSkillSet > skill || mechanics.filter({$0.isBusy == false}).count == 0){
      if let nextLevel = nextLevel{
        return nextLevel.performJobOrPassItUp(job)
      }else{
        print("No one is available to do this job")
        return false
      }
    }else{
      if let firstAvailableMechanic = mechanics.filter({$0.isBusy == false}).first{
        return firstAvailableMechanic.performJob(job)
      }
      assert(false, "This should never be reached since our if-else statement is fully exhaustive. You cannot have both all mechanics busy and an available mechanic within one skill group");
    }
````

performJobOrPassItUp takes one parameter of type job as an argument and returns a boolean to indicate whether it was able or not able to get the job done. First we check to see if the job's minimum skill requirement is more than what our current MechanicSkillGroup can do or that we have no available mechanics in the current MechanicSkillGroup. If either one of those are true then the mechanics in this MechanicSkillGroup cannot perform this job and it should be passed to higher ups in our chain of responsibility. If there is no higher ups in our chain then when have reached the end of the line and we simply do not have anyone available that can perform this job. Otherwise we grab the first available mechanic from our list of mechanics and have them perform the job.

Finally we define a shop object which will behave as a pseudo manager for our MechanicSkillGroup.

````swift
class Shop{
 
  private var firstMechanics: MechanicSkillGroup
  init(firstMechanics: MechanicSkillGroup){
      self.firstMechanics = firstMechanics
  }
  
  func performJob(job: Job) -> Bool{
    return firstMechanics.performJobOrPassItUp(job)
  }
}
````

This class will have a private property called firstMechanics. This will be a reference to the beginning of our chain of responsibility. These will be our least experienced mechanics.

Next we will define a performJob function that will begin the process by calling the performJobOrPassItUp on our first MechanicSkillGroup in our chain of responsibility.   

This is it, we have all the needed pieces to set up and run our implementation of chain of responsibility. Lets look at a sample set up and some test cases.   

````swift
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

for job in jobs{
  shop.performJob(job)
}
````

Lets go over it section by section so we understand how it's all set up. 

We begin by setting our master mechanics

````swift
var steve = Mechanic(skill: .MasterMechanic, name: "Steve Frank")
var joe = Mechanic(skill: .MasterMechanic, name: "Joe Alison")
var jack = Mechanic(skill: .MasterMechanic, name: "Jack Ryan")
var brian = Mechanic(skill: .MasterMechanic, name: "Drake Jin")

var masterMechanics = MechanicSkillGroup(skill: .MasterMechanic, 
                                          mechanics: [steve, joe, jack, brian], 
                                          nextLevel: nil)
````

We create four mechanics, assigning them their names and skill level. Next we create our MechanicSkillGroup container for our master mechanics. We pass .MasterMechanic as this group's skill set, an array of master mechanics we created and nil for the nextLevel. Since MasterMechanic is the highest skill set this makes sense.

We follow the same procedure for apprenticeMechanics, juniorMechanics and oilChangeOnlys. 

````swift

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

var oilChangeOnlyes = MechanicSkillGroup(skill: .OilChangeOnly, 
                                          mechanics: [grant], 
                                          nextLevel: juniorMechanics)
````

Next up we'll define our shop and jobs:

````swift
var shop = Shop(firstMechanics: oilChangeOnlyes)

var jobs = [Job(minimumSkillSet: .Junior, name: "Windshield Wiper"),
            Job(minimumSkillSet: .Apprentice, name: "Light Bulb Change"),
            Job(minimumSkillSet: .Apprentice, name: "Battery Replacement"),
            Job(minimumSkillSet: .OilChangeOnly, name: "General Oil Change"),
            Job(minimumSkillSet: .OilChangeOnly, name: "General Oil Change"),
            Job(minimumSkillSet: .OilChangeOnly, name: "General Oil Change"),
            Job(minimumSkillSet: .OilChangeOnly, name: "General Oil Change"),
            Job(minimumSkillSet: .MasterMechanic, name: "Timing Belt Replacement"),
            Job(minimumSkillSet: .Junior, name: "Brake Pads Replacement")
]
````

We create a shop instance and pass it the begining of our chaint of responsibility which is OilChangeOnly mechanics. Next we define an array of jobs with different minimumSkillSets.

And finally we attempt to perform each job through our chain:

````swift
for job in jobs{
  shop.performJob(job)
}
````  

Here is the result we get:

````swift
Ken Hudson with skill set Junior has started to do Windshield Viper
Tyson Trump with skill set Apprentice has started to do Light Bulb Change
Tina Bernard with skill set Apprentice has started to do Battery Replacement
Grant Hughes with skill set OilChangeOnly has started to do General Oil Change
Matt Lowes with skill set Junior has started to do General Oil Change
Sandeep Shenoy with skill set Junior has started to do General Oil Change
Tom Berry with skill set Junior has started to do General Oil Change
Steve Frank with skill set MasterMechanic has started to do Timing Belt Replacement
Bryan Tram with skill set Apprentice has started to do Brake Pads Replacement
Program ended with exit code: 9
````

We see that jobs are traversing correctly up the chain. We see that once our only mechanic who is at OilChangeOnly becomes busy with the job, further oil changes are bumped up to the next level. Following this chain of responsibility we ensure that mechanics are only occupied with jobs that most closely match their skill set. This optimizes our supply and ensures that our more experienced mechanics are available for jobs that only they can perform.

Congratulations you have just implemented the Chain Of Responsibility Design Pattern to solve a nontrivial problem

The repo for the complete project can be found here:<a href="https://github.com/kingreza/Swift-Chain-Of-Responsibility"> Swift - Chain Of Responsibility. </a> Download a copy of it and play around with it. See if you can find ways to improve it. Here are some ideas to consider:
<ul>
  <li>What would you change if you wanted to have lower tier mechanics perform parts of the job and pass the rest to the higher up mechanics in chain</li>
  <li>Implement a way for a mechanic to spend a finite amount of time performing a job and becoming available when completed. Then try to expand on the design so it can deal with jobs that could not be performed at the time the request was sent. What are our options?</li>
  <li>Imagine we have customers that are willing to pay premium rates to use our most experienced mechanics available, how would we set up our chain of responsibility for those customers? </li>
  <li>It's not always necessary to traverse all jobs all the way up the chain. Imagine it's not financially feasible to have master mechanics do any oil changes. How would you prevent this from happening? </li>
</ul>
  
