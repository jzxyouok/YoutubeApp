//
//  VideoModel.swift
//  YoutubeApp
//
//  Created by Pranav Kasetti on 10/02/2016.
//  Copyright © 2016 Pranav Kasetti. All rights reserved.
//

import UIKit
import Alamofire
import Foundation
import AlamofireObjectMapper
import ObjectMapper

protocol VideoModelDelegate {
    func dataReady()
}

class VideoModel: NSObject {
    
    let API_KEY = "AIzaSyD0PN3sI5uWai__bJ_Xv-IV83XnSQ15s48"
    let UPLOADS_PLAYLIST_ID="PLkhUBDAcva4YFHjhFqyG0hY4E6_wW-7uM"
    
    var videoArray = [Video] ()
    var keywordArray = [String] ()
    var keywordArray2 = [String] ()
    var categoryIdArray = [Int] ()
    var done: Int = 0
    var problems: [String] = ["3D reconstruction","Abrasion","Absorption","Acceleration","Acid rain","Acoustics","Adaptation to global warming","Adhesion","Aeroacoustics","Aeroelasticity","Ageing","Aggression","Agribusiness","Agriculture","Air pollution","Air quality","Alternative energy","Analysis of algorithms","Anticancer treatment","Aquatic ecosystems","Atmospheric correction","Battery recycling","Bifurcation theory","Big data","Biodegradation","Biological dispersal","Biomagnification", "Bird conservation", "Boredom", "Brownout", "Brute-force search", "Bullying", "Bycatch", "Calcification", "Capacity utilization", "Capital punishment", "Carbon capture and storage", "Carbon dioxide scrubbers", "Carbon footprints", "Carbon leakage", "Carbon sinks", "Cheap energy sources", "Chromatic aberration", "Class discrimination", "Clean energy sources", "Cleaning up water", "Climate change", "Climate engineering", "Climate pattern", "Clustering high-dimensional data", "CO2 emissions", "Cohesion", "Colony collapse disorder", "Compression", "Compulsive overeating", "Computer performance", "Computer security", "Computer viruses", "Condensation", "Consumption of edible insects", "Contaminated land", "Convergent evolution", "Corrosion", "CPU power dissipation", "Cyberbullying", "Data corruption", "Data harmonization", "Data loss", "Data maintenance", "DataPortability", "Deforestation", "Demographic transition", "Denaturation", "Density estimation", "Desertification", "Diffraction", "Disarmament", "Disaster recovery", "Discrimination", "Distribution of wealth", "Divergence", "Domestic Fire", "Drought", "Drug tolerance", "Dry rot", "Dryland salinity", "Ecological health", "Ecology", "Economic inequality", "Economic stagnation", "Efficient energy use", "Efficient medical body sensors", "Eigenvalues and eigenvectors", "Electricity delivery", "Electromagnetic fields", "Electromagnetic interference", "Electromotive force", "Emotional insecurity", "encryption algorithms", "Endangered species", "Energy conservation", "Energy development", "Energy efficiency", "Energy poverty", "Energy security", "Energy storage", "Energy supply", "Entropy", "Environmental monitoring", "Environmental protection", "Environmental quality", "Estimation", "Evaporation", "Evolution", "Exponential growth", "Extinction", "Factorization", "Famine", "Fault detection and isolation", "Fermentation in food processing", "Ferromagnetic resonance", "Fertility", "Floods", "Fluid mechanics", "Folate deficiency", "Food contamination", "Food preservation", "Food waste", "forest degradation", "Forest Fire", "Forest fragmentation", "Forest protection", "Fossil fuels", "Fractures", "Fuel cells", "Fuel efficiency", "Genetically modified food", "Global cooling", "Global warming", "Gravitational collapse", "Grazing pressure", "Great Pacific garbage patch", "Greenhouse gas", "Habitat conservation", "Habitat destruction", "Habitat fragmentation", "Harassment", "Hazardous waste", "Homelessness", "Hunger", "Hydrocarbon exploration", "Hygiene", "Impact of building works on nature", "Inertia", "Information privacy", "Landfill", "Landslides", "Large deviations theory", "Latency", "Lattices", "Light pollution", "Link rot", "Litter", "Malware", "Mathematical optimization", "Measuring poverty", "Memory", "Memory corruption", "Mineral deficiency", "Mineral uptake", "Mobile electricity generators", "Monocropping", "Mutation", "Natural resource extraction", "navigation for visually impaired people", "Net neutrality", "Network congestion", "network signals", "Noise", "Noise pollution", "Noise reduction", "Nuclear accidents", "Nuclear meltdown", "Nuclear power", "Nuclear proliferation", "Nuclear technology", "Obsolescence", "Ocean acidification", "Offshore drilling", "Oil depletion", "Oil spills", "Orbital decay", "Orbital inclination", "Overconsumption", "Overfishing", "Overgrazing", "Overheating", "Ozone depletion", "Ozone layer", "Parallel computing", "Partition tables", "Pathfinding", "Pattern matching", "Perishability", "Petroleum free plastic", "Phase transitions", "Phishing", "Photophobia", "Pollution", "Pollution prevention", "Poor posture", "Population ageing", "Post-harvest losses", "Poverty", "Poverty in Africa", "Power outage", "Power transmission", "Predictability", "Producing light without electricity", "Productivity", "Projectile motion", "Proximity effect", "Quantum nonlocality", "Quantum tunnelling", "Randomization", "Rare-earth content in magnets", "Recycling", "Recycling energy to aerate water", "Recyling waste paper", "Reducing water pollutants", "Reflection", "Reionization", "Renewable Energy", "Resource depletion", "Road Safety", "Rolling blackouts", "Rust", "Salinity", "Sanitation", "Scarcity", "Sea level rises", "Sewage disposal", "Sewage treatment", "Signal integrity", "Siltation", "Smog", "Smuggling", "Snakebites", "Software bugs", "Software quality", "Software versioning", "Soil conservation", "Soil contamination", "Soil salinity", "Sound pressure", "Space debris", "Space exploration", "Spaceflight", "Spaghetti code", "Spam", "Spyware", "Starvation", "Statistical inference", "Stopping power", "Storms", "Subsidence", "Subsoil", "Suction", "Suspension", "Sustainability", "Sustainable energy", "Sustainable living", "the Accelerating universe", "the Carbon cycle", "the Digital divide", "the Effects of global warming", "the efficiency of Solar Cells", "the Energy crisis", "the Greenhouse effect", "the Lower Atmosphere", "the Shrinking ice cap", "the Upper Atmosphere", "Thermal breaks", "Torsion", "Traffic", "Traffic bottlenecks", "Traffic Collisions", "Traffic congestion", "Traffic flow", "Traffic jams", "Triangulation", "Tropical rainforest conservation", "Tropospheric ozone", "Turbulence modeling", "Type I and type II errors", "Underwater vehicles", "Urban heat islands", "Van Allen radiation belt", "Vehicle accident safety", "Viscoelasticity", "Vitamin A deficiency", "Vitamin B12 deficiency", "Voter turnout", "Waste management", "Water conservation", "Water distribution on Earth", "Water fluoridation", "Water pollution", "Water quality", "Water reclamation", "Water resources", "Water scarcity", "Water treatment", "Water wastage", "Wave propagation", "Wetland conservation", "Wildlife conservation", "Wildlife corridors", "Wildlife management", "Wind power", "Zero population growth"]
    var physics: [String] = ["physics","food science","fauna and flora","inventions and innovation","energy and space","earth and environmental studies"]
    var biology: [String] = ["biology","food science","fauna and flora","inventions and innovation","energy and space","earth and environmental studies"]
    var chemistry: [String] = ["chemistry","food science","fauna and flora","inventions and innovation","energy and space","earth and environmental studies"]
    var philosophy: [String] = ["behavioural and social science"]
    var mathematics: [String] = ["computer science and math","fauna and flora","earth and environmental studies"]
    var geography: [String] = ["inventions and innovation","energy and space","earth and environmental studies"]
    var history: [String] = ["energy and space","earth and environmental studies","electricity and electronics","computer science and math","fauna and flora","biology","chemistry","physics","food science"]
    var technology: [String] = ["electricity and electronics","computer science and math","inventions and innovation","energy and space","earth and environmental studies"]
    
    var delegate:VideoModelDelegate?
    
    func generateKeywords(keywordArray: [String], completionHandler:(data: [String]) -> ()) -> () {
        
        for i in 0..<keywordArray.count {
            
            makeKeywordsRequest(keywordArray, i: i, completionHandler: completionHandler)
            
        }
        
    }
    
    func getFeedVideos(interestArray: [String], keywordArray: [String], completionHandler:(data: AnyObject?) -> ()) -> () {
        
        //Category Id's: 35 - Documentary, 34 - Comedy, 28 - Science & Technology, 27 - Education, 26 - Howto & Style, 21 - Videoblogging, 2 - Autos & Vehicles,
        
        for interest in interestArray {
            
            if (interest=="biology" || interest=="chemistry" || interest=="physics") {
                makeVideosRequest(28, keywordArray: keywordArray, completionHandler: completionHandler)
            }
            
            
            if (interest=="philosophy" || interest == "mathematics" || interest == "geography") {
                makeVideosRequest(27, keywordArray: keywordArray, completionHandler: completionHandler)
            }
            
            
            if (interest=="history") {
                makeVideosRequest(35, keywordArray: keywordArray, completionHandler: completionHandler)
            }
            
            
            if (interest=="technology") {
                makeVideosRequest(26, keywordArray: keywordArray, completionHandler: completionHandler)
            }
            
        }
    }
    
    func makeVideosRequest(categoryId: Int, keywordArray: [String], completionHandler:(data: AnyObject?) -> ()) -> () {
        Alamofire.request(.GET, "https://www.googleapis.com/youtube/v3/search", parameters: ["part":"snippet","regionCode":"US","q":keywordArray[Int(arc4random_uniform(UInt32(keywordArray.count)))],"maxResults":3,"type":"video","videoDuration":"short","videoCategoryId":categoryId,"key":API_KEY], encoding: ParameterEncoding.URL, headers: nil).responseObject { (response: Response<VideoResponse, NSError>) in
            let videoResponse = response.result.value
            if let videos = videoResponse?.videos {
                for video in videos {
                    self.videoArray.append(video)
                }
                print("InterestsVideos: \(self.videoArray.count)")
                completionHandler(data: self.videoArray)
            }
        }
    }
    
    func getSkillsFeedVideos(skillArray: [String], keywordArray: [String], completionHandler:(data: AnyObject?) -> ()) -> () {
        for skill in skillArray {
            switch skill{
            case "biology":
                makeSkillsVideosRequest(biology, keywordArray: keywordArray, completionHandler: completionHandler)
            case "chemistry":
                makeSkillsVideosRequest(chemistry, keywordArray: keywordArray, completionHandler: completionHandler)
            case "physics":
                makeSkillsVideosRequest(physics, keywordArray: keywordArray, completionHandler: completionHandler)
            case "philosophy":
                makeSkillsVideosRequest(philosophy, keywordArray: keywordArray, completionHandler: completionHandler)
            case "mathematics":
                makeSkillsVideosRequest(mathematics, keywordArray: keywordArray, completionHandler: completionHandler)
            case "geography":
                makeSkillsVideosRequest(geography, keywordArray: keywordArray, completionHandler: completionHandler)
            case "history":
                makeSkillsVideosRequest(history, keywordArray: keywordArray, completionHandler: completionHandler)
            case "technology":
                makeSkillsVideosRequest(technology, keywordArray: keywordArray, completionHandler: completionHandler)
            default: break
            }
            
        }
    }
    
    func makeSkillsVideosRequest(skillArray: [String], keywordArray: [String], completionHandler:(data: AnyObject?) -> ()) -> () {
        Alamofire.request(.GET, "https://www.googlesciencefair.com/make-better-generator/api", parameters: ["hl":"en","skill":skillArray[Int(arc4random_uniform(UInt32(skillArray.count)))],"love":keywordArray[Int(arc4random_uniform(UInt32(keywordArray.count)))],"problem":problems[Int(arc4random_uniform(UInt32(problems.count)))]], encoding: ParameterEncoding.URL, headers: nil).responseObject { (response: Response<SkillsVideoResponse, NSError>) in
            let videoResponse = response.result.value
            if let videos = videoResponse?.videos {
                for video in videos {
                    self.videoArray.append(video)
                }
                print("SkillsVideos: \(self.videoArray.count)")
                completionHandler(data: self.videoArray)
            }
        }
        
    }
    
    func makeKeywordsRequest(keywordArray: [String], i: Int, completionHandler:(data: [String]) -> ()) -> () {
        
        let letters : NSString = "abcdefghiklmnoprstuvwxy"
        let randomString : NSMutableString = NSMutableString(capacity: 1)
        let length = UInt32 (letters.length)
        let rand = arc4random_uniform(length)
        randomString.appendFormat("%C", letters.characterAtIndex(Int(rand)))
        
        Alamofire.request(.GET, "https://api.datamuse.com/words", parameters: ["ml": keywordArray[i], "sp": "*"+(randomString as String)], encoding: ParameterEncoding.URL, headers: nil).responseJSON{ (response) -> Void in
            if let JSON = response.result.value as? [AnyObject] {
                for word in JSON {
                    self.keywordArray2.append(word.valueForKeyPath("word") as! String)
                }
                if self.keywordArray2.count < 10 {
                    self.makeKeywordsRequest(keywordArray, i: i, completionHandler: completionHandler)
                } else {
                    completionHandler(data: self.keywordArray2)
                }
            } else {
                if let error = response.result.error {
                    print (error)
                }
            }
        }
    }
}
