#Azure Deployment Use Case!

This is a Page describes the Problem, Approach and Usage of this project. If you are eager to dive into the implementation, check this page.

##Assumptions:
1. You have an Active Subscription with [Windows Azure](http://azure.microsoft.com) 
2. You are familiar with msbuild scripts.
3. Some familiarity with CI Tools - [Jenkins](https://jenkins-ci.org/)

##Challenge: 
### Scenario: 
As a IT Support Engineer of an ASP.NET multi tenant SAAS product, you keep getting requests from the Sales Team, requesting you to create demo environments for a potential customer. After a few rounds of emails, detailing the **client details, the software version and the sample data** requirements about the request, you end up setting the environment and distributing the URL to the Sales Team who then take over to do their usual magic. 

***
**Happy Ending**: Sales Teams comes back saying the client is on-board.

***
**Normal Ending**: Sales Teams never provides any update and at the end of the year your boss is chasing you to explain him why there is an additional endpoint on the server taking up resources and why 20% of your last month timesheet says "Sales Support"

###Problem
The nature of the request that you just fulfilled addressed the following requirements from the Sales Team:
* Ensure Data Isolation
* Ensure Client customizations - Client Logo, Client Name etc
but failed to address the following from your CTO
* Minimal Tech Support for Setup and Tear down
* Minimal Cost of Hosting and License Costs

However to achieve the problem you ended up spending valuable resources both Personnel and Infrastructure for a "Potential Opportunity"

###Solution

Imagine the Sales Engineer could spin off an environment without bothering the IT Support and Sales taking ownership of the hosting charges for the "Potential Client" requests.

The above solution can be achieved easily with the following Solution Components:
* Cloud Stack:
  * Microsoft Azure Website 
  * Microsoft Azure SQL Database
* Build Commands:
  * MSBuild 
  * Powershell
* Administrative Front End:
  * Jenkins

And yes you can watch the solution in pictures here.
