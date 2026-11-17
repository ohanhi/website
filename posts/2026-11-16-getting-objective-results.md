---
layout: post
title: Getting objective results with automated UI testing
---

**Automated tests help the development team at least as much as the product owner. They help you to stay focused, make onboarding much smoother and even foster a positive work environment.**

<small>_This post was originally published in Mar 2023 in the [Qvik](https://qvik.fi/) blog but is no longer available._</small>

In my previous article What is automated UI testing and why should you do it?, we discussed the main concepts of automated testing and explained its main motivations for the product owner. In this article, we take a closer look at how us developers can benefit from test automation.

Whether you are building a new application from scratch or adding functionality to an established codebase, it’s essential to make sure that the codebase is a coherent whole. This can range from stylistic choices to organising code at the actual user interface level.

Introducing more and more automated tests is not always a net positive, though. Every test adds a few seconds or minutes to the overall runtime and, at worst, flaky tests can prevent perfectly good code from being deployed.

In a later post, I will focus more on what merits testing in my opinion and on how to choose the best tool for the job.

## Automation helps us be human

It cannot be overstated how much software development is about human interaction. In my experience, automating as much as possible leaves more space for meaningful discussions and fosters a more positive work environment.

When you are trying to write a report and keep getting into arguments about the Oxford comma instead of the subject matter, it feels really unappreciative and unhelpful. If this happens day in and day out, eventually this style of communication will undermine trust and make people less inclined to ask for help or opinions. This is what code reviews that focus on code style rather than functionality feel like.

A readme document explaining the desired code style is helpful. Even better, the project could have tools for making sure that all code conforms to the same style. Prettier and other opinionated formatters can shave off an entire layer of needless debate, and comprehensive linting rules can catch a bunch more.

To expand on this, the existing features and functionality are effectively tacit knowledge for developers unfamiliar with some part of the application. If the new developer adds a small feature and checks that everything still seems to work after the change, it’s really deflating to hear that they’ve “broken” something. Proper regression tests could have helped the developer feel in control and fix the regression before putting the code up for review.

There are always things that fall outside the tools’ capabilities, but it is a tremendous time-saver to have the basics covered without any human intervention.

Below, I give some more reasons why I believe that automated tests make developers’ lives easier.

## Make sure that the features work – and keep working

**Confidence.** Developers and application publishers want to feel confident that what they are putting out into the world is of high quality and has as few bugs as possible. When everyone in the team is busy and you just need to get the new version out, you will feel much more confident when the tests are showing up green.

**Professionalism.** Automated testing is the way to make sure that no critical part of the app is forgotten in the pre-release testing phase. Humans are fallible creatures and, no matter how important something is, we tend to skip some steps if we can’t see the necessity.

If you have quick-release skewers on your bicycle, your bike came with instructions to check the skewers every single time before getting on. This is obviously super important for safety, but the human psyche ignores the importance out of habit: nothing bad ever happened before.

Test automation can alleviate this by outsourcing the tedious tasks to computers, leading to fewer regressions and better overall quality.

## Focus on what matters

**Tests as a prerequisite for merging.** Contemporary software development is done in branches, in which each developer (or pair, etc.) in effect works independently of all concurrent work. Finished code is reviewed and merged into the main development branch.

It is very helpful to have a CI setup that automatically runs all the relevant tests on each branch, because then both the author and the reviewer get to know the status without any manual steps. This means that any regressions caught by automation are plainly visible and can be fixed before the reviewer even takes a look at them.

When everyone agrees to write new tests for any new features and follow up on that as part of code reviews, the codebase will continue to be well tested throughout its lifetime.

**Conscious decision to change existing features.** The most insidious kind of bug is the regression. Regression means that, while we were developing one part of the application, it also made another, seemingly unrelated part of the app misbehave or break entirely.

Regressions are particularly frustrating for both developers and users: this used to work just fine, why doesn’t it work anymore? Luckily, automated testing can very often bring these issues to light before they end up on the users’ screens. When several tests fail due to a refactor, fixing them makes altering the specifications for those parts of the program a conscious decision for the developers.

**Commonly agreed rules can be enforced.** Tools such as linters, code formatters, static analysers, etc. can be a tremendous help in keeping the code style consistent, avoiding common coding pitfalls and letting code reviews focus on the important things.

While, strictly speaking, these tools are independent of automated testing, they complement testing really nicely and are very easy to slot into the same CI process.

As more people work on a project, more personal opinions on minor things like syntax variants start to appear in the codebase. Automated checks can help maintain a ruleset everyone can agree with.

## Clarify intent

**Critical paths are well defined.** The most important user flows in an application are called critical paths. These are the flows that need to work even if nothing else does.

In a web store, this could include adding items to your cart and checking out. On a messaging app, it would mean choosing a recipient and sending a message, as well as probably receiving one.

Critical paths are often not documented at all, or are documented in the wrong place where the development team doesn’t get reminded of them on a daily basis. Automated tests can help with this too.

An end-to-end test that is easy to follow can very effectively define a critical path for the team, and also make sure that it keeps working. And again, if new steps are added or old steps are removed, having to change the test to match the new flow makes changing a fundamental part of the application a very conscious decision.

**The way a feature is designed to work is reaffirmed in tests.** Code is written for humans to read. It has great communicative power in and of itself, and the right amount of comments can help clarify the less obvious parts.

A great side benefit of automated tests is that they also explain how the authors intended the feature to work in the first place. It’s one thing to have logic for a form that hides fields based on previous responses and another to have tests for making sure that question 2.a. is only visible when the answer to question 2 is “Yes”.

Having the expected result defined in terms of tests clearly shows whether the hiding is done correctly and not the wrong way around by accident, for example. This is even more helpful in more complicated user interfaces, in which many different solutions can seem like valid options.

## Value over time

**Easy onboarding and hand-offs.** Long-lived software projects will always experience some rotation. People have shorter and longer vacations, they move to new projects, and they switch jobs. At the same time, new team members join in and get familiar with the codebase.

As professionals, great developers want to keep the codebase accessible to new people at all times. Automated tests make it far easier to pick up where other folks left off. They ensure that the recent changes do not cause unintended side-effects and clarify the intent of the existing feature code.

**Managing technical debt.** As software continues to evolve, old decisions and outdated libraries start to weigh on the speed and ease of development.

Unless managed on a regular basis, technical debt eventually becomes so bad that people start to deliberately avoid changing certain parts of the system. This, in turn, turns those parts of the codebase into black boxes that no one understands anymore.

Tests can help with both avoiding this situation and getting out of it. Tests provide a clear reference point for the implementation, letting us know whether the changes to the inner workings have been successful. For a black box, we can first write a comprehensive set of tests based on how it works currently, and then write a new implementation that also passes those same tests.

## Conclusion

There are plenty of reasons to do automation testing for user-facing applications.

Automation helps us focus our communication on the non-trivial and can make newcomers feel more comfortable with making changes to the codebase. Tests integrate nicely to CI/CD processes, so that they become a natural part of the team’s workflow.

Automated tests can also ensure that the way a feature was originally defined was intentional and even explain which user flows are considered critical in the application.

Now that we have a good baseline understanding of the benefits of automation, I will move on to more specific topics in future articles. In particular, I will explain why I think end-to-end testing is great to start with, but not the end-all solution, and how I approach choosing what to test.
