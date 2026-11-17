---
layout: post
title: "Automated UI testing: What to test and how?"
---

> **In this article, we look at UI testing from two perspectives: how to choose the right tool for the job, and how to decide if a test is worth writing or not. I also introduce a decision model of my own that you can use or adapt to make the most of your testing.**

_This post was originally published in Mar 2023 in the [Qvik](https://qvik.fi/) blog but is no longer available._

In my previous two articles, _What is automated UI testing and why should you do it?_ and _Getting objective results with automated UI testing_, we focused on the benefits of automating your user interface testing. In addition to avoiding bugs and regressions, test automation can help clarify intent, document critical paths, and in general give objective feedback on your work.

This time, I will explain how I like to think about what to test and how. To that end, I will explain the 4×2 model of testing that I built to illustrate my thinking and show you how to use it to become more analytical about your testing as well.

Adding tests is usually only thought of as positive, no matter the situation. I don’t see it that way. Tests are more code to maintain and take time to run. If they do not provide enough value to offset the costs, they are not good investments.

## Three steps to great tests

1. Familiarise yourself with several kinds of testing
2. Decide what and how to test
3. Keep evolving those tests

We developers quite often skip the first step and simply default to the one way we’ve done testing before. To be able to make informed decisions, you need to at least understand the ideas behind several kinds of testing.

Step three, evolving the tests, can also be easy to forget. Very often, once the tests are written in one way or another, they are never revisited unless they start causing issues.

## Step 1: Familiarise yourself with several kinds of testing
Before we dive into how to choose what kind of testing to do, let’s have a quick look at some of the most common measures taken to ensure the quality of software. This table is not exhaustive and is in no particular order.

| Kind                                                              | Can it be automated? |
| ----------------------------------------------------------------- | -------------------- |
| Usability testing                                                 | ❌ No                |
| Accessibility testing                                             | ✔️ Partly            |
| Performance testing                                               | ✔️ Partly            |
| Manual testing (while developing, in code review, by QA people)   | ❌ No                |
| Compilation                                                       | ✅ Yes               |
| Static analysis and linting                                       | ✅ Yes               |
| Unit testing                                                      | ✅ Yes               |
| Snapshot testing                                                  | ✅ Yes               |
| Visual regression testing                                         | ✅ Yes               |
| Integration/Component testing                                     | ✅ Yes               |
| End-to-end (e2e) testing with mocked and/or real backends         | ✅ Yes               |

All of these are helpful in their own right and I warmly recommend looking into the ones you are not familiar with. This article focuses on the kinds of tests that can be fully automated.

I have included some things on the list that are not usually considered testing, such as compilation, linting, and manual testing during development. I think it’s worth considering how these tools and practices fit into your process, regardless.

I will talk about the different types of testing in more detail in a later article. But just to make sure that we are on the same page, below is a quick rundown of the fully automatable types of tests from the table.

## Five kinds of automated tests

**Unit testing** aims at verifying a small part of the code, such as a single function or object. This is the most developer-oriented kind of test – it tests code rather than using the UI. As such, it is a great fit for business logic and data transformations.

Unit tests are very performant and can cover many different cases quickly. Property-based testing can help find the edge cases without manually listing out expected and actual outputs.

A single unit test takes just milliseconds to run, and an entire suite runs in the order of seconds.

**Snapshot testing** is about generating a reference (the snapshot) of the UI component and comparing whether the current version matches the reference. This results in the tests failing if there has been any change, whether deliberate or not.

**Visual regression** testing is a type of snapshot testing. Instead of a representation of the code, it takes snapshots of the UI. It can be very helpful in finding visual glitches but requires human consideration to tell whether the change was intentional.

Snapshot tests are effectively unit tests and take roughly the same time to run. Generating the snapshots, especially visual ones, does take some time though.

**Component testing** looks at a small piece of UI like it was a tiny app. Component testing uses the UI like a regular user would: clicking on buttons and typing into text boxes. Testing a date picker’s functionalities in this way can make a lot of sense, for example.

Ideally, component tests have no external dependencies. If the component needs data from the server, for example, it can be passed in as arguments or mocked in the tests. This keeps the tests reliable and fast.

A single component test runs in the order of seconds, and a suite often takes minutes.

**End-to-end testing** is the most complete kind of automated testing. It uses the full application almost exactly like a regular user would. In these tests, the automation often navigates using menus, adds items into the shopping cart and goes through checkout. Depending on the setup, the tests can reveal issues in underlying services and their interplay.

End-to-end (e2e) testing is very powerful but unfortunately also quite fiddly. The more systems are involved in the test setup, the more likely it becomes that tests sometimes pass and sometimes fail. It is also the slowest kind of test to run.

A single e2e test takes dozens of seconds to run, while a whole suite can take dozens of minutes.

## Step 2: Decide what and how to test

User interfaces are tested constantly during development, so writing simple unit tests that state the obvious is not worth the time and effort in my opinion. Instead, I like to identify the non-trivial parts of the UI and test those with care.

I don’t believe in coverage metrics, especially when it comes to UI code. Instead, I like to emphasise the return on investment of each test. Return on investment (ROI) is a financial term that refers to the ratio of net income and costs.

I use ROI in a more abstract sense here, meaning the potential benefits of a test compared to its downsides. In essence, it’s “how many bugs would this test catch and how critical are they” vs. “how much work is it to set up and maintain, and how much time will it take to run”.

### The 4×2 model
Below is a simple framework for deciding whether your planned tests would be a net positive or negative. This model helps visualise how I personally like to think about what to test and how.

The 4×2 model helps you consider the different aspects of adding tests, now and in the future. What we want from tests is the ability to catch potential bugs. The more bugs we can catch and the more severe the bugs would be, the better the return on investment.

The tradeoff is that there is always some effort to add the tests and maintain them, and every test adds to the total runtime of the test suite.

(Graphic showing four items on the left: number of bugs, severity of bugs, effort of testing, and running duration, all connected to the two items on the right: now, and in the future.)

For example, a test that can potentially catch a large number of mid- to high-severity bugs over a long period of time can be worth it even if it requires a lot of effort to set up and maintain.

As a counter-example, a test that can only catch a single specific bug that isn’t very severe might not be worth the investment even if it is easy to set up. Especially if it means a longer run time for the test suite or if it needs constant upkeep.

The 4×2 model should also help you understand why slow-running tests are not always a net positive even if they could help catch bugs. In these cases, it’s worth considering whether the same issues could be covered with a faster-running test.

Perhaps a long-running e2e test could be replaced with a component test. Maybe you can extract some complex logic from the component into pure functions and cover them with unit testing.

The 4×2 model is inspired by the 3×2 framework, which I came across years ago at Futurice. The 3×2 is a generic decision-making model that helps people decide how to spend company money.

### Case: we have no tests yet, what should we do?

Automated UI tests are easily left on the wayside during the initial development of an application. In times of heavy iteration of functionality and user flows, it may feel like a pointless chore to keep tests up to date on the side.

Once things start settling down and you have a solid foundation in place, however, that’s a great time to start introducing automated tests. By then, you probably know what the critical paths, i.e. the must-work user flows, of the application are. Here’s where end-to-end testing comes in handy.

Let’s walk through how I would use the 4×2 model to help with this decision.

(image)

When we’re considering covering the critical paths with e2e tests, both the number and the severity of bugs are very high. Any bug that breaks one of the most important user flows is very severe and should be fixed before it makes it into the main branch.

Furthermore, end-to-end tests can even find compatibility issues between the frontend and backend or between backend services.

These benefits will mostly come in the future, as the kind of issues that e2e tests can catch right now would probably have already been found in manual testing.

The effort of testing can be a major part of this equation as well. Setting up e2e tests for the first time may be a considerable undertaking and, depending on the setup, might require near-constant attention going forward.

This is up to you and your team to discuss, however. The 4×2 model is a tool to help you consider the important aspects when making decisions.

### Try it out for yourself

Here are some more example cases for you to try the model out with:

- e2e tests for the dashboard are flaky or run out of memory
- Heading components have no tests
- A complex settings UI is hard to test

I know these examples are vague and require more specifics, but just fill in the blanks with whatever comes to mind. The point of this exercise is for you to see what kinds of ideas emerge if you apply the 4×2 model to one of these examples.

Let’s discuss the first example a tiny bit, just to get started. End-to-end tests for the dashboard are flaky. The dashboard is probably a pretty important part of the application, so having proper tests for it would likely make sense.

However, dashboards usually consist of many smaller views, each with their own functionalities. Here’s where being familiar with many kinds of testing pays off. Maybe there are other ways to reap some of the benefits while avoiding the issues?

### Or build your own model

As I mentioned, I came up with the 4×2 model to describe how I like to think about these things. It might not work out of the box for your team. I heartily encourage you to think about testing in your specific case and build a model that supports your ways of working.

You can take the model I presented as a base and add new things to it, like so:

(image)

Or if you prefer, come up with a model that’s 100% yours. All I ask is that you think about your testing in an analytical way and keep in mind that not all tests give a good return on investment. That is how you make the most of your automated UI testing.

## Step 3: Keep evolving those tests
From this step onwards, you are on your own. I will give you some parting words to reflect on though.

Software is never done, and neither are automated tests.

Usually, the only things we do to maintain the test codebase is updating the tests to reflect new functionality, adding new tests, and occasionally removing tests that are obsolete or too flaky. These are all great things to do, and you should feel proud when your project keeps things up to date like that.

But there’s something more that we could be doing. Every now and then, we should take a step back and reflect. What are we getting out of our tests? Is there something that we often need to fix in production? Are all of our tests useful? Are any of our tests causing recurring issues?

## Retrospectives for tests

By thinking about the tests in a retrospective-like manner, we can identify parts of the application that are poorly tested. Poorly as in the tests are not providing the value they should be. Those parts can have 100% coverage, but maybe we are testing the wrong things or in the wrong way.

Any tests that don’t seem to provide value should be evaluated and possibly revised or removed. Sometimes tests are useful in some other way, such as clarifying intent, or documenting a reference implementation. And sometimes an extra level of security is warranted, just in case.

At the same time, we can find out which parts of the application are well tested. Tests that have caught issues before they surface in the app should be celebrated and learned from. Why are they working so well? Could the same idea be extended to other parts as well?

## Iterating on the good stuff

Once we’ve found what works and what doesn’t in our current tests, we can come up with a new and revised testing strategy. We can rewrite the troublesome tests, remove obsolete ones, and maybe add some to fill the gaps we identified.

And then, some time in the future, we take another step back and do this all over again. This time, we will find fewer things that need attention and learning from the good things we can come up with an even better strategy.
