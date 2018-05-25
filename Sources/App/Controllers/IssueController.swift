import Vapor

final class IssueController : RouteCollection {
    func boot(router: Router) throws {
        let issuesRoutes = router.grouped("issues")
        // Get single issue
        issuesRoutes.get(Issue.parameter, use: getIssue)
        // Delete single issue
        issuesRoutes.delete(use: deleteIssue)
        // Upvote issue
        issuesRoutes.post(Issue.parameter, "upvote", use: upVoteIssue)
        // Downvote issue
        issuesRoutes.post(Issue.parameter, "downvote", use: downVoteIssue)
        
        let propertyIssuesRoutes = router.grouped("properties")
        
        // Get all issues for property
        propertyIssuesRoutes.get(Property.parameter ,"issues", use: getIssues)
        // Create issue for property
        propertyIssuesRoutes.post(IssueData.self, at: Int.parameter ,"issues", use: createIssue)
    }
    
    /// Returns a list of all `Issue`s.
    func index(_ req: Request) throws -> Future<[Issue]> {
        return Issue.query(on: req).all()
    }
    
    func getIssues(_ req: Request) throws -> Future<[Issue]> {
        return try req.parameters.next(Property.self).flatMap(to: [Issue].self) {
            property in try property.issues.query(on: req).all()
        }
    }
    
    func getIssue(_ req: Request) throws -> Future<Issue> {
        return try req.parameters.next(Issue.self)
    }
    
    func createIssue(_ req: Request, data: IssueData) throws -> Future<Issue> {
        let propertyId = try req.parameters.next(Int.self)
        let issue = Issue(
            title: data.title, description: data.description, propertyId: propertyId
        )
        return issue.save(on: req)
    }
    
    func upVoteIssue(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(Issue.self).flatMap(to: Issue.self) { issue in
            issue.upVotes += 1
            return issue.save(on: req)
            }.transform(to: .ok)
    }
    
    func downVoteIssue(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(Issue.self).flatMap(to: Issue.self) { issue in
            issue.downVotes += 2000
            return issue.update(on: req)
            }.transform(to: .ok)
    }
    
    func deleteIssue(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(Issue.self).flatMap(to: Void.self) { issue in
            return issue.delete(on: req)
            }.transform(to: .ok)
    }
}

struct IssueData : Content {
    let title: String
    let description: String
}
