//
//  ImageProcessing.swift
//  Nostur
//
//  Created by Fabian Lachman on 08/03/2023.
//

import Foundation
import Nuke

class ImageProcessing {
    static public var shared = ImageProcessing()
    
    var pfp:ImagePipeline
    var banner:ImagePipeline
    var content:ImagePipeline
    var communities:ImagePipeline
    var badges:ImagePipeline
    var video:ImagePipeline
    
    init() {
        ImagePipeline.shared = ImagePipeline(configuration: .withDataCache)
        
        pfp = ImagePipeline {
//            $0.isUsingPrepareForDisplay = true
//            $0.isProgressiveDecodingEnabled = true
            $0.dataLoader = DataLoader(configuration: {
                // Disable disk caching built into URLSession
                let conf = DataLoader.defaultConfiguration
                conf.urlCache = nil
                return conf
            }())

            let dataCache = try! DataCache(name: "com.nostur.image.pfp")
            dataCache.sizeLimit = 1024 * 1024 * 1500

            $0.imageCache = ImageCache(costLimit: 1024 * 1024 * 100)
            $0.dataCache = dataCache
//            $0.dataCachePolicy = .storeEncodedImages
            $0.dataCachePolicy = .storeAll
        }
        
        banner = ImagePipeline {
//            $0.isUsingPrepareForDisplay = true
            $0.dataLoader = DataLoader(configuration: {
                // Disable disk caching built into URLSession
                let conf = DataLoader.defaultConfiguration
                conf.urlCache = nil
                return conf
            }())
            
            let dataCache = try! DataCache(name: "com.nostur.image.banner")
            dataCache.sizeLimit = 1024 * 1024 * 250
            
            $0.imageCache = ImageCache(costLimit: 1024 * 1024 * 25)  // 50 MB
            $0.dataCache = dataCache
            $0.dataCachePolicy = .storeEncodedImages
        }
        
        content = ImagePipeline {
//            $0.isUsingPrepareForDisplay = true
            $0.isProgressiveDecodingEnabled = true
            $0.dataLoader = DataLoader(configuration: {
                // Disable disk caching built into URLSession
                let conf = DataLoader.defaultConfiguration
                conf.urlCache = nil
                return conf
            }())
            
            let dataCache = try! DataCache(name: "com.nostur.image.content")
            dataCache.sizeLimit = 1024 * 1024 * 500
            
            $0.imageCache = ImageCache(costLimit: 1024 * 1024 * 100, countLimit: 1000)
            $0.dataCache = dataCache
            $0.dataCachePolicy = .storeAll
        }
        
        communities = ImagePipeline {
//            $0.isUsingPrepareForDisplay = true
            $0.isProgressiveDecodingEnabled = true
            $0.dataLoader = DataLoader(configuration: {
                // Disable disk caching built into URLSession
                let conf = DataLoader.defaultConfiguration
                conf.urlCache = nil
                return conf
            }())
            
            let dataCache = try! DataCache(name: "com.nostur.image.communities")
            dataCache.sizeLimit = 1024 * 1024 * 500
            
            $0.imageCache = ImageCache(costLimit: 1024 * 1024 * 100, countLimit: 1000)
            $0.dataCache = dataCache
            $0.dataCachePolicy = .storeAll
        }
        
        badges = ImagePipeline {
            $0.isProgressiveDecodingEnabled = true
            $0.dataLoader = DataLoader(configuration: {
                // Disable disk caching built into URLSession
                let conf = DataLoader.defaultConfiguration
                conf.urlCache = nil
                return conf
            }())
            
            let dataCache = try! DataCache(name: "com.nostur.image.badges")
            dataCache.sizeLimit = 1024 * 1024 * 100
            
            $0.imageCache = ImageCache(costLimit: 1024 * 1024 * 50, countLimit: 200)  // 100 MB
            $0.dataCache = dataCache
            $0.dataCachePolicy = .storeEncodedImages
        }
        
        video = ImagePipeline {
            $0.dataLoader = DataLoader(configuration: {
                // Disable disk caching built into URLSession
                let conf = DataLoader.defaultConfiguration
                conf.urlCache = nil
                return conf
            }())
            
            let dataCache = try! DataCache(name: "com.nostur.video.content")
            dataCache.sizeLimit = 1024 * 1024 * 200
            
//            $0.imageCache = ImageCache(costLimit: 1024 * 1024 * 50, countLimit: 100)  // 100 MB
            $0.dataCache = dataCache
            $0.dataCachePolicy = .storeOriginalData
        }
        
    }
    
}
