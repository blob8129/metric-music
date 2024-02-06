//
//  ArtistTests.swift
//  MetricMusicTests
//
//  Created by Andrey Volobuev on 06/02/2024.
//

import XCTest
@testable import MetricMusic

final class ArtistsTests: XCTestCase {
    
    let testDecoder = JSONDecoder()
    
    func testDecodeArtist() throws {
        let data =
        """
        {
          "idArtist": "111239",
          "strArtist": "Coldplay",
          "strArtistStripped": null,
          "strArtistAlternate": "",
          "strLabel": "Parlophone",
          "idLabel": "45114",
          "intFormedYear": "1996",
          "intBornYear": "1996",
          "intDiedYear": null,
          "strDisbanded": null,
          "strStyle": "Rock/Pop",
          "strGenre": "Alternative Rock",
          "strMood": "Happy",
          "strWebsite": "",
          "strFacebook": "",
          "strTwitter": "1",
          "strBiographyEN": "Coldplay are a British rock band.. .",
          "strGender": "Male",
          "intMembers": "4",
          "strCountry": "London, England",
          "strCountryCode": "GB",
          "strArtistThumb": "https://www.theaudiodb.com/images/media/artist/thumb/uxrqxy1347913147.jpg",
          "strArtistLogo": "https://www.theaudiodb.com/images/media/artist/logo/q094e21667518717.png",
          "strArtistCutout": "https://www.theaudiodb.com/images/media/artist/cutout/ggq5ap1641422844.png",
          "strArtistClearart": "https://www.theaudiodb.com/images/media/artist/clearart/ruyuwv1510827568.png",
          "strArtistWideThumb": "https://www.theaudiodb.com/images/media/artist/widethumb/sxqspt1516190718.jpg",
          "strArtistFanart": "https://www.theaudiodb.com/images/media/artist/fanart/spvryu1347980801.jpg",
          "strArtistFanart2": "https://www.theaudiodb.com/images/media/artist/fanart/uupyxx1342640221.jpg",
          "strArtistFanart3": "https://www.theaudiodb.com/images/media/artist/fanart/qstpsp1342640238.jpg",
          "strArtistFanart4": "https://www.theaudiodb.com/images/media/artist/fanart/muf6tu1612946535.jpg",
          "strArtistBanner": "https://www.theaudiodb.com/images/media/artist/banner/xuypqw1386331010.jpg",
          "strMusicBrainzID": "cc197bad-dc9c-440d-a5b5-d52ba2e14234",
          "strISNIcode": null,
          "strLastFMChart": "http://www.last.fm/music/Coldplay/+charts?rangetype=6month",
          "intCharted": "3",
          "strLocked": "unlocked"
        }
        """.data(using: .utf8) ?? Data()
        
        let entity = try testDecoder.decode(Artist.self, from: data)
        
        XCTAssertEqual(entity.artist, "Coldplay")
    }
    
    func testDecodeArtistMB() throws {
        let data =
        """
        {
            "id": "52074ba6-e495-4ef3-9bb4-0703888a9f68",
            "type": "Group",
            "type-id": "e431f5f6-b5d2-343d-8b36-72607fffb74b",
            "score": 100,
            "name": "Arcade Fire",
            "sort-name": "Arcade Fire",
            "country": "CA"
        }
        """.data(using: .utf8) ?? Data()
        
        let entity = try testDecoder.decode(ArtistMB.self, from: data)
        
        XCTAssertEqual(entity.name, "Arcade Fire")
    }
}
