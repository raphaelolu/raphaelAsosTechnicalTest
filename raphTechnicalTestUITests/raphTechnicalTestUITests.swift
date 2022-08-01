
import XCTest

class raphTechnicalTestUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }
    
    func testFilterFlow() throws{
   
        let app = XCUIApplication()
        app.launch()
        let spacexNavigationBar = app.navigationBars["SpaceX"]
        XCTAssertTrue(spacexNavigationBar.exists)
       let filterButton =  spacexNavigationBar.buttons["Compose"]
        XCTAssertTrue(filterButton.exists)
        XCTAssertTrue(filterButton.isHittable)
        filterButton.tap()
        let dateQuery = app.sheets.scrollViews.otherElements.buttons["2007"]
        XCTAssertTrue(dateQuery.isHittable)
        dateQuery.tap()
        let cellEntry =  app.tables.cells["Mission, DemoSat, Date/time, 2007:3:21 at 1:10, Close, Rocket:, Falcon 1, Days since, -5612"].children(matching: .other).element(boundBy: 2).children(matching: .other).element
        XCTAssertTrue(cellEntry.exists)
    }
    
    func testViewArticleUseCase() throws {
        let app = XCUIApplication()
        app.launch()
        
        let cellEntry = app.tables.cells["Mission, Trailblazer, Date/time, 2008:8:3 at 4:34, Close, Rocket:, Falcon 1, Days since, -5111"]
        XCTAssertTrue(cellEntry.isHittable)
        cellEntry.tap()
       let wikipediaLinkOption = app.sheets.scrollViews.otherElements.buttons["Wickipedia"]
        XCTAssertTrue(wikipediaLinkOption.exists)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    }

