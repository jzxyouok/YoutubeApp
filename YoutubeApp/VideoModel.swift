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
import GTMOAuth2
import GoogleAPIClientForREST

protocol VideoModelDelegate {
    func dataReady()
}

class VideoModel: NSObject {
    
    let API_KEY = "AIzaSyD0PN3sI5uWai__bJ_Xv-IV83XnSQ15s48"
    //let UPLOADS_PLAYLIST_ID="PLkhUBDAcva4YFHjhFqyG0hY4E6_wW-7uM"
    var service = GTLRYouTubeService()
    
    var videoArray = [Video] ()
    var keywordArray = [String] ()
    var keywordArray2 = [String] ()
    var categoryIdArray = [Int] ()
    var done: Int = 0
    var queries: [GTLRYouTubeQuery_PlaylistItemsInsert] = []
    var timer: Timer!
    let query = GTLRYouTubeQuery_VideosList.query(withPart: "snippet")
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
    
    func generateKeywords(_ keywordArray: [String], completionHandler:@escaping (_ data: [String]) -> ()) -> () {
        
        for i in 0..<keywordArray.count-1 {
            
            makeSubKeywordsRequest(keywordArray, i: i)
            
        }
        makeKeywordsRequest(keywordArray, i: keywordArray.count-1, completionHandler: completionHandler)
        
    }
    
    func getKeywordFeedVideos(_ keywordArray: [String], completionHandler:@escaping (_ data: AnyObject?) -> ()) -> () {
        if keywordArray.count != 0 {
            for i in 0..<keywordArray.count-1 {
                makeSubKeywordVideosRequest(keywordArray[i])
            }
            makeKeywordVideosRequest(keywordArray[keywordArray.count-1], completionHandler: completionHandler)
        } else {
            makeKeywordVideosRequest("entrepreneurship", completionHandler: completionHandler)
        }
    }
    
    func makeSubKeywordVideosRequest(_ keyword: String) {
        Alamofire.request("https://www.googleapis.com/youtube/v3/search", parameters: ["part":"snippet","regionCode":"US","q":keyword,"maxResults":Int(arc4random_uniform(UInt32(2))),"type":"video","videoDuration":"short","key": self.API_KEY], encoding: URLEncoding.default, headers: nil).responseObject { (response: DataResponse<VideoResponse>) in
            DispatchQueue.main.async {
                let videoResponse = response.result.value
                if let videos = videoResponse?.videos {
                    for video in videos {
                        self.videoArray.append(video)
                    }
                    print(self.videoArray)
                    print("KeywordVideos: \(self.videoArray.count)")
                }
            }
        }
    }
    
    func makeKeywordVideosRequest(_ keyword: String, completionHandler:@escaping (_ data: AnyObject?) -> ()) -> () {
        Alamofire.request("https://www.googleapis.com/youtube/v3/search", parameters: ["part":"snippet","regionCode":"US","q":keyword,"maxResults":Int(arc4random_uniform(UInt32(2))),"type":"video","videoDuration":"short", "key": self.API_KEY], encoding: URLEncoding.default, headers: nil).responseObject { (response: DataResponse<VideoResponse>) in
            DispatchQueue.main.async {
                let videoResponse = response.result.value
                if let videos = videoResponse?.videos {
                    for video in videos {
                        self.videoArray.append(video)
                    }
                    print(self.videoArray)
                    print("KeywordVideos: \(self.videoArray.count)")
                    completionHandler(self.videoArray as AnyObject?)
                }
            }
        }
    }
    
    func getFeedVideos(_ interestArray: [String], keywordArray: [String], completionHandler:@escaping (_ data: AnyObject?) -> ()) -> () {
        
        //Category Id's: 35 - Documentary, 34 - Comedy, 28 - Science & Technology, 27 - Education, 26 - Howto & Style, 21 - Videoblogging, 2 - Autos & Vehicles,
        
        for interest in interestArray {
            
            if (interest=="biology" || interest=="chemistry" || interest=="physics") {
                if interest==interestArray.last {
                    makeVideosRequest(28, keywordArray: keywordArray, completionHandler: completionHandler)
                } else {
                    makeSubVideosRequest(28, keywordArray: keywordArray)
                }
            } else if (interest=="philosophy" || interest == "mathematics" || interest == "geography") {
                if interest==interestArray.last {
                    makeVideosRequest(27, keywordArray: keywordArray, completionHandler: completionHandler)
                } else {
                    makeSubVideosRequest(27, keywordArray: keywordArray)
                }
            } else if (interest=="history") {
                if interest==interestArray.last {
                    makeVideosRequest(35, keywordArray: keywordArray, completionHandler: completionHandler)
                } else {
                    makeSubVideosRequest(35, keywordArray: keywordArray)
                }
            } else if (interest=="technology") {
                if interest==interestArray.last {
                    makeVideosRequest(26, keywordArray: keywordArray, completionHandler: completionHandler)
                } else {
                    makeSubVideosRequest(26, keywordArray: keywordArray)
                }
            } else if (interest=="film and animation") {
                if interest==interestArray.last {
                    makeVideosRequest(1, keywordArray: keywordArray, completionHandler: completionHandler)
                } else {
                    makeSubVideosRequest(1, keywordArray: keywordArray)
                }
            } else if (interest=="sports") {
                if interest==interestArray.last {
                    makeVideosRequest(17, keywordArray: keywordArray, completionHandler: completionHandler)
                } else {
                    makeSubVideosRequest(17, keywordArray: keywordArray)
                }
            } else if (interest=="music") {
                if interest==interestArray.last {
                    makeVideosRequest(10, keywordArray: keywordArray, completionHandler: completionHandler)
                } else {
                    makeSubVideosRequest(10, keywordArray: keywordArray)
                }
            } else if (interest=="animals") {
                if interest==interestArray.last {
                    makeVideosRequest(15, keywordArray: keywordArray, completionHandler: completionHandler)
                } else {
                    makeSubVideosRequest(15, keywordArray: keywordArray)
                }
            } else if (interest=="comedy") {
                if interest==interestArray.last {
                    makeVideosRequest(23, keywordArray: keywordArray, completionHandler: completionHandler)
                } else {
                    makeSubVideosRequest(34, keywordArray: keywordArray)
                }
            } else if (interest=="action") {
                if interest==interestArray.last {
                    makeVideosRequest(32, keywordArray: keywordArray, completionHandler: completionHandler)
                } else {
                    makeSubVideosRequest(32, keywordArray: keywordArray)
                }
            } else if (interest=="gaming") {
                if interest==interestArray.last {
                    makeVideosRequest(20, keywordArray: keywordArray, completionHandler: completionHandler)
                } else {
                    makeSubVideosRequest(20, keywordArray: keywordArray)
                }
            } else if (interest=="vlogging") {
                if interest==interestArray.last {
                    makeVideosRequest(21, keywordArray: keywordArray, completionHandler: completionHandler)
                } else {
                    makeSubVideosRequest(21, keywordArray: keywordArray)
                }
            } else if (interest=="travel and events") {
                if interest==interestArray.last {
                    makeVideosRequest(19, keywordArray: keywordArray, completionHandler: completionHandler)
                } else {
                    makeSubVideosRequest(19, keywordArray: keywordArray)
                }
            } else if (interest=="social") {
                if interest==interestArray.last {
                    makeVideosRequest(24, keywordArray: keywordArray, completionHandler: completionHandler)
                } else {
                    makeSubVideosRequest(24, keywordArray: keywordArray)
                }
            } else {
                if interest==interestArray.last {
                    makeVideosRequest(27, keywordArray: keywordArray, completionHandler: completionHandler)
                } else {
                    makeSubVideosRequest(27, keywordArray: keywordArray)
                }
            }
        }
    }
    
    func makeSubVideosRequest(_ categoryId: Int, keywordArray: [String]) {
        Alamofire.request("https://www.googleapis.com/youtube/v3/search", parameters: ["part":"snippet","regionCode":"US","q":keywordArray[Int(arc4random_uniform(UInt32(keywordArray.count)))],"maxResults":Int(arc4random_uniform(UInt32(2))),"type":"video","videoDuration":"short","videoCategoryId":categoryId, "key": self.API_KEY], encoding: URLEncoding.default, headers: nil).responseObject { (response: DataResponse<VideoResponse>) in
            DispatchQueue.main.async {
                let videoResponse = response.result.value
                if let videos = videoResponse?.videos {
                    for video in videos {
                        self.videoArray.append(video)
                    }
                    print(self.videoArray)
                    print("InterestsVideos: \(self.videoArray.count)")
                }
            }
        }
    }
    
    func makeVideosRequest(_ categoryId: Int, keywordArray: [String], completionHandler:@escaping (_ data: AnyObject?) -> ()) -> () {
        Alamofire.request("https://www.googleapis.com/youtube/v3/search", parameters: ["part":"snippet","regionCode":"US","q":keywordArray[Int(arc4random_uniform(UInt32(keywordArray.count)))],"maxResults":Int(arc4random_uniform(UInt32(2))),"type":"video","videoDuration":"short","videoCategoryId":categoryId, "key": self.API_KEY], encoding: URLEncoding.default, headers: nil).responseObject { (response: DataResponse<VideoResponse>) in
            DispatchQueue.main.async {
                let videoResponse = response.result.value
                if let videos = videoResponse?.videos {
                    for video in videos {
                        self.videoArray.append(video)
                    }
                    print(self.videoArray)
                    print("InterestsVideos: \(self.videoArray.count)")
                    completionHandler(self.videoArray as AnyObject?)
                }
            }
        }
    }
    
    func getSkillsFeedVideos(_ skillArray: [String], keywordArray: [String], completionHandler:@escaping (_ data: AnyObject?) -> ()) -> () {
        for skill in skillArray {
            switch skill{
            case "biology":
                if skill==skillArray.last {
                    makeSkillsVideosRequest(["biology"], keywordArray: keywordArray, completionHandler: completionHandler)
                } else {
                    makeSubSkillsVideosRequest(["biology"], keywordArray: keywordArray)
                }
            case "chemistry":
                if skill==skillArray.last {
                    makeSkillsVideosRequest(["chemistry"], keywordArray: keywordArray, completionHandler: completionHandler)
                } else {
                    makeSubSkillsVideosRequest(["chemistry"], keywordArray: keywordArray)
                }
            case "physics":
                if skill==skillArray.last {
                    makeSkillsVideosRequest(["physics"], keywordArray: keywordArray, completionHandler: completionHandler)
                } else {
                    makeSubSkillsVideosRequest(["physics"], keywordArray: keywordArray)
                }
            case "philosophy":
                if skill==skillArray.last {
                    makeSkillsVideosRequest(philosophy, keywordArray: keywordArray, completionHandler: completionHandler)
                } else {
                    makeSubSkillsVideosRequest(philosophy, keywordArray: keywordArray)
                }
            case "computer science and math":
                if skill==skillArray.last {
                    makeSkillsVideosRequest(["maths and computer science"], keywordArray: keywordArray, completionHandler: completionHandler)
                } else {
                    makeSubSkillsVideosRequest(["maths and computer science"], keywordArray: keywordArray)
                }
            case "food science":
                if skill==skillArray.last {
                    makeSkillsVideosRequest(["food science"], keywordArray: keywordArray, completionHandler: completionHandler)
                } else {
                    makeSubSkillsVideosRequest(["food science"], keywordArray: keywordArray)
                }
                
            case "fauna and flora":
                if skill==skillArray.last {
                    makeSkillsVideosRequest(["fauna and flora"], keywordArray: keywordArray, completionHandler: completionHandler)
                } else {
                    makeSubSkillsVideosRequest(["fauna and flora"], keywordArray: keywordArray)
                }
            case "inventions and innovation":
                if skill==skillArray.last {
                    makeSkillsVideosRequest(["inventions and innovation"], keywordArray: keywordArray, completionHandler: completionHandler)
                } else {
                    makeSubSkillsVideosRequest(["inventions and innovation"], keywordArray: keywordArray)
                }
            case "energy and space":
                if skill==skillArray.last {
                    makeSkillsVideosRequest(["energy and space"], keywordArray: keywordArray, completionHandler: completionHandler)
                } else {
                    makeSubSkillsVideosRequest(["energy and space"], keywordArray: keywordArray)
                }
            case "earth and environmental studies":
                if skill==skillArray.last {
                    makeSkillsVideosRequest(["earth and environmental studies"], keywordArray: keywordArray, completionHandler: completionHandler)
                } else {
                    makeSubSkillsVideosRequest(["earth and environmental studies"], keywordArray: keywordArray)
                }
            case "electricity and electronics":
                if skill==skillArray.last {
                    makeSkillsVideosRequest(["electricity and electronics"], keywordArray: keywordArray, completionHandler: completionHandler)
                } else {
                    makeSubSkillsVideosRequest(["electricity and electronics"], keywordArray: keywordArray)
                }
            default: break
            }
            
        }
    }
    
    func makeSkillsVideosRequest(_ skillArray: [String], keywordArray: [String], completionHandler:@escaping (_ data: AnyObject?) -> ()) -> () {
        Alamofire.request("https://www.googlesciencefair.com/make-better-generator/api", parameters: ["hl":"en","skill":skillArray[Int(arc4random_uniform(UInt32(skillArray.count)))],"love":keywordArray[Int(arc4random_uniform(UInt32(keywordArray.count)))],"problem":problems[Int(arc4random_uniform(UInt32(problems.count)))]], encoding: URLEncoding.default, headers: nil).responseObject { (response: DataResponse<SkillsVideoResponse>) in
            DispatchQueue.main.async {
                let videoResponse = response.result.value
                if let videos = videoResponse?.videos {
                    for video in videos {
                        self.videoArray.append(video)
                    }
                    print(self.videoArray)
                    
                    print("SkillsVideos: \(self.videoArray.count)")
                    completionHandler(self.videoArray as AnyObject?)
                }
            }
        }
        
    }
    
    func makeSubSkillsVideosRequest(_ skillArray: [String], keywordArray: [String]) {
        Alamofire.request("https://www.googlesciencefair.com/make-better-generator/api", parameters: ["hl":"en","skill":skillArray[Int(arc4random_uniform(UInt32(skillArray.count)))],"love":keywordArray[Int(arc4random_uniform(UInt32(keywordArray.count)))],"problem":problems[Int(arc4random_uniform(UInt32(problems.count)))]], encoding: URLEncoding.default, headers: nil).responseObject { (response: DataResponse<SkillsVideoResponse>) in
            DispatchQueue.main.async {
                let videoResponse = response.result.value
                if let videos = videoResponse?.videos {
                    for video in videos {
                        self.videoArray.append(video)
                    }
                    print(self.videoArray)
                    print("SkillsVideos: \(self.videoArray.count)")
                }
            }
        }
        
    }
    
    func makeKeywordsRequest(_ keywordArray: [String], i: Int, completionHandler:@escaping (_ data: [String]) -> ()) -> () {
        
        let letters : NSString = "abcdefghiklmnoprstuvwxy"
        let randomString : NSMutableString = NSMutableString(capacity: 1)
        let length = UInt32 (letters.length)
        let rand = arc4random_uniform(length)
        randomString.appendFormat("%C", letters.character(at: Int(rand)))
        
        Alamofire.request("https://api.datamuse.com/words", parameters: ["ml": keywordArray[i], "sp": "*"+(randomString as String)], encoding: URLEncoding.default, headers: nil).responseJSON{ (response) -> Void in
            if let JSON = response.result.value as? [AnyObject] {
                for word in JSON {
                    self.keywordArray2.append(word.value(forKeyPath: "word") as! String)
                }
                if self.keywordArray2.count < 10 {
                    self.makeKeywordsRequest(keywordArray, i: i, completionHandler: completionHandler)
                } else {
                    completionHandler(self.keywordArray2)
                }
            } else {
                if let error = response.result.error {
                    print (error)
                }
            }
        }
    }
    
    func makeSubKeywordsRequest(_ keywordArray: [String], i: Int) {
        
        let letters : NSString = "abcdefghiklmnoprstuvwxy"
        let randomString : NSMutableString = NSMutableString(capacity: 1)
        let length = UInt32 (letters.length)
        let rand = arc4random_uniform(length)
        randomString.appendFormat("%C", letters.character(at: Int(rand)))
        
        Alamofire.request("https://api.datamuse.com/words", parameters: ["ml": keywordArray[i], "sp": "*"+(randomString as String)], encoding: URLEncoding.default, headers: nil).responseJSON{ (response) -> Void in
            if let JSON = response.result.value as? [AnyObject] {
                for word in JSON {
                    self.keywordArray2.append(word.value(forKeyPath: "word") as! String)
                }
                if self.keywordArray2.count < 10 {
                    self.makeSubKeywordsRequest(keywordArray, i: i)
                }
            } else {
                if let error = response.result.error {
                    print (error)
                }
            }
        }
    }
    
    func addVideosToPlaylist(_ videos: [Video]) {
        
        for video in videos {
            let playlistItem = GTLRYouTube_PlaylistItem()
            playlistItem.snippet = GTLRYouTube_PlaylistItemSnippet()
            playlistItem.snippet!.playlistId="WL"
            let resourceId = GTLRYouTube_ResourceId()
            resourceId.kind="youtube#video"
            resourceId.videoId=video.videoId
            playlistItem.snippet!.resourceId = resourceId
            let query3 = GTLRYouTubeQuery_PlaylistItemsInsert.query(withObject: playlistItem, part: "snippet")
            self.queries.append(query3)
            if self.timer==nil {
                self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(0.5), target: self, selector: #selector(executeQuery(_:)), userInfo: nil, repeats: true)
            }
        }
    }
    
    func executeQuery(_ timer: Timer) {
        if self.queries == [] {
            timer.invalidate()
        }
        if self.queries != [] {
            if !self.queries[self.queries.endIndex-1].isQueryInvalid {
                service.executeQuery(self.queries[self.queries.endIndex-1], delegate: self, didFinish: #selector(VideoModel.displayResultWithTicket(_:finishedWithVideo:error:)))
                self.queries.popLast()
            }
        }
    }
    
    func displayResultWithTicket(_ ticket : GTLRServiceTicket,
                                 finishedWithVideo playlistItem: GTLRYouTube_PlaylistItem,
                                                   error : NSError?) {
        if let error = error {
            showAlert("Error", message: error.localizedDescription)
            return
        }
        print(playlistItem.snippet?.resourceId?.videoId!)
        print("added playlist item")
    }
    
    func showAlert(_ title : String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertControllerStyle.alert
        )
        let ok = UIAlertAction(
            title: "OK",
            style: UIAlertActionStyle.default,
            handler: nil
        )
        alert.addAction(ok)
        print(alert)
    }
}
