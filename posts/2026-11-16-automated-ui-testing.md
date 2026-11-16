---
layout: post
title: What is automated UI testing and why should you do it?
---

_This post was originally published in Oct 2022 in the [Qvik](https://qvik.fi/) blog but is no longer available._
---

Automating user interface testing can help you avoid bugs, make sure that existing features keep working, let the development team focus on what matters – and save money as a result.

Anyone who has tried cooking straight from a recipe knows how hard it is to write and read clear instructions for anything that includes dependencies. In software, there are few things that can be expressed as simply as in recipes.

There are many ways software developers manage complexity, but at the end of the day, there are always untraveled paths and unintended consequences in even medium-sized applications. While we as developers are experts in foreseeing the possible cases, we still can’t cover even a fraction of the possible routes in our heads. Instead, we rely on trying out the features and seeing if they work as expected.

## Why can’t we just make sure that our app has no bugs?

Imagine sitting in a car at a street corner in Paris. Your task is to drive around and find out whether you can get back to that same street corner using any combination of the streets of Paris without a problem. Some streets are one-way, some intersections only let you turn right and so on. That’s all okay, as long as you don’t end up in an inescapable loop, or a one-way cul-de-sac.

It makes intuitive sense that traversing every combination of streets in Paris is impossible. There are an infinite number of ways to reach the starting point, including driving around a single block for a hundred years and then getting back.

Nonetheless, this task is a lot simpler than thoroughly testing software.

In software, we have control structures that effectively teleport you from one street to another, states of various shapes and sizes, network failures, and so on. Fortunately, there are several strategies to try and make sure that the system works, even if we cannot cover every conceivable case.

We can take a look at each intersection at a time to make sure that there is a way out. We can also pay special attention to crucial and/or complicated areas and choose specific routes through the city that are always guaranteed to work.

And since we work with software, instead of people having to do all this every time, we can write a small amount of code that checks the other code in one way or another. This is called automated testing.

## What is automated testing in practice?

There are many kinds of testing that can be done for user-facing applications. Here are some of the most common measures for ensuring the quality of software, in no particular order:

- Usability testing
- Accessibility testing
- Performance testing
- Compilation – in statically typed languages, compilation is the first line of defence
- Manual testing (during development, in code review or by QA people)
- Static analysis and linting
- Unit testing
- Snapshot testing
- Visual regression testing
- Integration/Component testing
- End-to-end (e2e) testing with mock and/or real backends

Some of these are automated tests by definition, others can be automated to some degree, and some cannot be automated at all. In this article, my arguments mostly relate to the three principal types of automated tests, namely unit testing, component testing and end-to-end testing.

I will talk about the different types of testing in more detail in a future article. But to make sure we are on the same page, let’s take a quick look at the three major types.

## Three major types: Unit, component and end-to-end testing

Unit testing is possibly the most well known type of automated testing. It is about looking at the smallest meaningful entity and making sure that it works in isolation. This is the single intersection at a time strategy in the streets-of-Paris analogy.

Unit tests run very fast and are powerful for things that are generic in nature. They are a particularly good fit for business logic and data transformations.

Component testing is what it sounds like. It is done at the component level, from a simple button to a date picker or an infinite list component. It can include a visual test runner that shows the UI component like it was an independent “application” of its own. This is similar to looking at a bigger area of Paris and focusing our attention on the peripheries to verify that the traffic flows as it should.

In these tests, we set the component to a desired starting state and work from there. The tests check things such as “are the correct checkboxes checked by default?” or “does the Delete button call the removal endpoint with the correct parameters?” Component tests take longer to run than unit tests, but are still quite fast.

End-to-end testing is closest to how the user actually uses the application: the website or mobile app is brought up just like a regular user would see it, and the tests work by clicking buttons, typing text in text boxes, and so on. In the Paris example, this would mean choosing the specific important routes that should be verified each time something changes.

End-to-end, or e2e testing is a bit hazy in terms of “how end-to-end” we are actually testing. In the shallowest sense, end-to-end can mean providing canned responses to particular requests (i.e. not requiring a network connection). E2e testing often includes at least a minimal version of the main backend service and can sometimes mean including everything from databases to authentication systems in the test run.

End-to-end testing is great for checking the important user flows but has its own drawbacks. Getting to a particular starting point can require a lot of work, and resetting the stage for the next test can be tricky. Furthermore, e2e tests are the most prone to “flakiness”, i.e. tests passing on occasion and sometimes not, and are by far the slowest, since the entire application (or even infrastructure) needs to be brought up before the test can run.

## Why should you do automated testing for UI code?

While working on a feature, every front-end developer switches between looking at the code and checking the end result. Manual testing is effectively built into the natural workflow.

However, relying on manual testing by developers is prone to regressions and is very rarely comprehensive. Developers try out the expected flows they just wrote out as code, meaning that uncommon user flows are almost never tested during development. It requires a sort of a context switch to go from “did I achieve what I was going for?” to “what could go wrong with this piece of code?”

I like to think about testing in terms of return on investment (ROI) and posit that many people find the return on investment in UI testing to be quite poor. And for sure, there are many ways to write less-than-useful tests but, in my experience, most of the time this happens because the tests were not really thought through.

## Automated UI testing helps you save money

There are definite trade-offs involved in writing tests, and I will dive deeper into these topics in a later post. But for now, let’s think about what we can gain by automating our tests.

Bugs are bad PR. Depending on the type of bug and its persistence, an issue in your application could cause anything from mild inconvenience and annoyance to loss of trust and missed sales. Making an upfront investment in proper testing and quality assurance can prevent the vast majority of bugs making it into releases.

Catching issues early saves tons of time and effort. According to an old adage, fixing an issue in a software project costs 1× in the concepting phase, 10× in the design phase, 100× in the development phase, 1,000× in the quality assurance phase, and 10,000× in the production phase.

The earlier an issue is detected, the easier it is to work around and avoid. When a bug is found in production, it interferes with regular development and the eagerness to resolve the issue quickly may cause a vicious cycle where the intended fix causes a new issue, and now there are two potential bugs users might face. Regression testing can help avoid such cycles, and writing tests for the intended fix may reveal a better way to fix the issue.

Fewer hours spent on manual testing. The main goal of automation is to have humans spend less time doing repetitive tasks. Machines are just better at that. Humans get bored, miss steps and forget things. Less time spent doing menial tasks, or especially forgetting to do them and then fixing bugs, amounts to more time spent on feature development.

## Conclusion

In general, it’s not possible to be absolutely certain that software will work as intended. This is especially true for user-facing applications in which unexpected inputs, network issues, and other hard-to-predict events are common.

Automated testing is an important part of how we make sure that the features are doing what we want them to, and that continued development doesn’t inadvertently change the existing functionality.

In the next post, titled Getting objective results with automated UI testing, I will talk more about the benefits for the development team.

