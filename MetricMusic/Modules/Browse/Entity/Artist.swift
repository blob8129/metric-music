//
//  Artist.swift
//  MetricMusic
//
//  Created by Andrey Volobuev on 06/02/2024.
//

import Foundation

struct Artist: Codable {
    let id: String
    let artist: String
    let artistStripped: String?
    let artistAlternate: String
    let label: String
    let idLabel: String
    let formedYear: String
    let bornYear: String
    let diedYear: String?
    let disbanded: String?
    let style: String
    let genre: String
    let mood: String
    let twitter: String
    let biographyEN: String
    let gender: String
    let members: String
    let country: String
    let countryCode: String
    let thumb: URL
    let logo: URL
    let cutout: URL
    let clearart: URL
    let wideThumb: URL
    let fanart: URL
    let fanart2: URL
    let fanart3: URL
    let fanart4: URL
    let banner: URL
    let musicBrainzID: String
    let isniCode: String?
    let lastFMChart: URL
    let charted: String
    let locked: String
    
    enum CodingKeys: String, CodingKey {
        case id = "idArtist"
        case artist = "strArtist"
        case artistStripped = "strArtistStripped"
        case artistAlternate = "strArtistAlternate"
        case label = "strLabel"
        case idLabel = "idLabel"
        case formedYear = "intFormedYear"
        case bornYear = "intBornYear"
        case diedYear = "intDiedYear"
        case disbanded = "strDisbanded"
        case style = "strStyle"
        case genre = "strGenre"
        case mood = "strMood"
        case twitter = "strTwitter"
        case biographyEN = "strBiographyEN"
        case gender = "strGender"
        case members = "intMembers"
        case country = "strCountry"
        case countryCode = "strCountryCode"
        case thumb = "strArtistThumb"
        case logo = "strArtistLogo"
        case cutout = "strArtistCutout"
        case clearart = "strArtistClearart"
        case wideThumb = "strArtistWideThumb"
        case fanart = "strArtistFanart"
        case fanart2 = "strArtistFanart2"
        case fanart3 = "strArtistFanart3"
        case fanart4 = "strArtistFanart4"
        case banner = "strArtistBanner"
        case musicBrainzID = "strMusicBrainzID"
        case isniCode = "strISNIcode"
        case lastFMChart = "strLastFMChart"
        case charted = "intCharted"
        case locked = "strLocked"
    }
}
