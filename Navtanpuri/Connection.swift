//
//  Connection.swift
//  Navtanpuri
//
//  Created by Vivek Goswami on 10/01/17.
//  Copyright © 2017 TriSoft Developers. All rights reserved.
//

import Foundation

struct Connection {
    
    static let forNews = "op=allNews"
    static let sewaForIndia = "op=sewaByCountry&country=india"
    static let sewaForUSA = "op=sewaByCountry&country=usa"
    static let lineage = "op=allLineageFullDetail"
    static let mandir = "op=searchMandirByFilter&vCountry=all&vAccommodation=NA&vFood=NA"
    static let stateIndia = "op=changeFilterCountry&doFor=States&vSearchQuery=india"
    static let stateUk = "op=changeFilterCountry&doFor=States&vSearchQuery=uk"
    static let stateOther = "op=changeFilterCountry&doFor=States&vSearchQuery=all"
    static let districtSelect = "op=changeFilterCountry&doFor=District&vSearchQuery="
    static let searchMandirByFilter = "op=searchMandirByFilter&vCountry=%@&vStates=%@&vCities=%@&vAccommodation=%@&vFood=%@"
    
    struct queue {
        static let utilityQueue = DispatchQueue.global(qos: .utility)
    }
    
    struct  open {
        static let mandirDirectory = "http://krishnapranami.org/ws/api/v1/mandirDirectory/index.php"
        static let newsService = "http://krishnapranami.org/ws/api/v1/news/index.php"
        static let sewaService = "http://krishnapranami.org/ws/api/v1/sewa/index.php"
        static let lineageService = "http://krishnapranami.org/ws/api/v1/lineage/index.php"
        //static let liveDarshan = "http://www.krishnapranami.org:81/ImageViewer?Direction=&Resolution=640x480&Sound=Enable&Mode=JPEG&View=Normal"
        static let liveDarshan = "http://livedarshan.krishnapranami.org:81/ImageViewer?Direction=&Resolution=640x480&Sound=Enable&Mode=JPEG&View=Normal"
        
        static let AddjapURL = "http://krishnapranami.org/ws/api/v1/jap/index.php"
        
        static let interactionService = "http://krishnapranami.org/ws/api/v1/intrectionWithGuruji/index.php"
        static let videoUrl = "http://krishnapranami.org/ws/api/v1/liveevent/index.php"
        static let feedback = "http://krishnapranami.org/ws/api/v1/feedback/index.php"
        static let events = "http://krishnapranami.org/ws/api/v1/events/index.php"
    }
}
