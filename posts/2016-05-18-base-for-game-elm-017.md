<!DOCTYPE html>
<html class="no-js">
<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
  <title> Base for a game in Elm 0.17 - Ossi Hanhinen</title>
  <meta name="description" content="Base for a game in Elm 0.17">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="../css/main.css">
</head>
<body>
  <section class="contain post">
    <a href="../" class="back-link">&laquo; Home</a>

    <header class="post-header">
  
  <h1 class="post-title">Base for a game in Elm 0.17</h1>
  
  <h2>Revisiting the "hard way"</h2>
  
</header>
<div class="post-meta">
  <img class="profile-pic" src="../img/profile_tiny.jpg" alt>
  <h3 class="author">
    <span>Ossi Hanhinen</span>
    <a href="https://github.com/ohanhi">@ohanhi</a>
  </h3>
  <p class="post-date">May 18, 2016</p>
</div>

<hr>

<h3>Read this to</h3>
<ul class="post-reasons">
  
  <li>learn the basics of Elm</li>
  
  <li>get acquainted with subscriptions</li>
  
</ul>

<h3>I expect you to know</h3>
<ul class="post-prereqs">
  
  <li>some programming</li>
  
</ul>

<hr> <p><a href="http://chilicorn.org/"><img src="https://img.shields.io/badge/Sponsored%20by-Chilicorn-brightgreen.svg" /></a></p>
<p>Licensed under <a href="https://creativecommons.org/licenses/by/4.0/">CC BY 4.0</a>.</p>
<h2 id="foreword">Foreword</h2>
<p>I first learned Elm about a year ago, in May 2015. I fell in love. I also wrote <a href="https://gist.github.com/ohanhi/0d3d83cf3f0d7bbea9db">an article</a> describing how to get started with the language by implementing the base for a game. The title of the article, <em>Learning FP the hard way</em>, was supposed to be a joke of sorts, as Elm is in fact a very easy language to learn! I’m not sure how many people got that. :)</p>
<p>Since then, I have used Elm in two separate customer projects, and it has definitely <a href="http://futurice.com/blog/elm-in-the-real-world">made my work better</a>!</p>
<p>The recent update (0.17) meant a <a href="http://elm-lang.org/blog/farewell-to-frp">rather large shift</a> in the way the language works, so I decided to revisit the original subject. So here it is: the base for a Space Invaders game in Elm 0.17!</p>
<p>You can find all of the code on <a href="https://github.com/ohanhi/elm-game-base">GitHub</a>, along with some setup instructions, but it is also listed at the bottom of this article.</p>
<h2 id="elm-what-was-it-again">Elm, what was it again?</h2>
<p>Elm is a beautiful little functional language that makes building frontend web applications easy and fun. If you’re interested in an overview, I gave a talk about the language at GeeCON 2016, and the annotated slides are here: <a href="https://speakerdeck.com/ohanhi/confidence-in-the-frontend-with-elm-1">Confidence in the frontend with Elm</a>.</p>
<h2 id="modeling-the-problem">Modeling the problem</h2>
<p>First off, let’s re-iterate what we want to achieve.</p>
<p>From the player’s perspective the program should be like this:</p>
<ul>
<li>There is a ship representing the player near the bottom of the screen</li>
<li>The player can move the ship left and right with corresponding arrow buttons</li>
<li>The player can shoot with the space bar</li>
</ul>
<p>And from the ship’s perspective the same is:</p>
<ul>
<li>Ship has a position on a 1D axis</li>
<li>Ship can have a velocity (positive or negative)
<ul>
<li>Ship changes position according to its velocity</li>
</ul></li>
<li>Ship can shoot</li>
</ul>
<p>This gives us a definition of what the <code>Model</code> of our little program should look like:</p>
<div class="sourceCode" id="cb1"><pre class="sourceCode haskell"><code class="sourceCode haskell"><span id="cb1-1"><a href="#cb1-1" aria-hidden="true" tabindex="-1"></a><span class="kw">type</span> alias <span class="dt">Model</span> <span class="ot">=</span></span>
<span id="cb1-2"><a href="#cb1-2" aria-hidden="true" tabindex="-1"></a>    { position <span class="op">:</span> <span class="dt">Float</span></span>
<span id="cb1-3"><a href="#cb1-3" aria-hidden="true" tabindex="-1"></a>    , velocity <span class="op">:</span> <span class="dt">Float</span></span>
<span id="cb1-4"><a href="#cb1-4" aria-hidden="true" tabindex="-1"></a>    , shotsFired <span class="op">:</span> <span class="dt">Int</span></span>
<span id="cb1-5"><a href="#cb1-5" aria-hidden="true" tabindex="-1"></a>    }</span></code></pre></div>
<p>This is an example of a data structure called <a href="http://guide.elm-lang.org/core_language.html#records">Record</a>. It is like a strongly typed and immutable cousin of the JavaScript object. Now, we only defined the type of the data so far, so let’s create a model to start from:</p>
<div class="sourceCode" id="cb2"><pre class="sourceCode haskell"><code class="sourceCode haskell"><span id="cb2-1"><a href="#cb2-1" aria-hidden="true" tabindex="-1"></a>model <span class="op">:</span> <span class="dt">Model</span> <span class="co">-- this is a type annotation</span></span>
<span id="cb2-2"><a href="#cb2-2" aria-hidden="true" tabindex="-1"></a>model <span class="ot">=</span></span>
<span id="cb2-3"><a href="#cb2-3" aria-hidden="true" tabindex="-1"></a>    { position <span class="ot">=</span> <span class="dv">0</span></span>
<span id="cb2-4"><a href="#cb2-4" aria-hidden="true" tabindex="-1"></a>    , velocity <span class="ot">=</span> <span class="dv">0</span></span>
<span id="cb2-5"><a href="#cb2-5" aria-hidden="true" tabindex="-1"></a>    , shotsFired <span class="ot">=</span> <span class="dv">0</span></span>
<span id="cb2-6"><a href="#cb2-6" aria-hidden="true" tabindex="-1"></a>    }</span></code></pre></div>
<p>What we have here is a simple value, or a constant. As everything in Elm is immutable, <code>model</code> will always be the same no matter what happens in the app. If we tried to redefine it, the compiler would simply complain that there are multiple definitions for the same name and the code would not compile.</p>
<p>Alright, moving on to moving the ship! I remember from high school that _s = v*dt_, or moved distance is the velocity times timedifference. So that’s how we can update the ship. In Elm, that would be something like the following.</p>
<div class="sourceCode" id="cb3"><pre class="sourceCode haskell"><code class="sourceCode haskell"><span id="cb3-1"><a href="#cb3-1" aria-hidden="true" tabindex="-1"></a>applyPhysics <span class="op">:</span> <span class="dt">Time</span> <span class="ot">-&gt;</span> <span class="dt">Model</span> <span class="ot">-&gt;</span> <span class="dt">Model</span></span>
<span id="cb3-2"><a href="#cb3-2" aria-hidden="true" tabindex="-1"></a>applyPhysics dt model <span class="ot">=</span></span>
<span id="cb3-3"><a href="#cb3-3" aria-hidden="true" tabindex="-1"></a>    { model <span class="op">|</span> position <span class="ot">=</span> model<span class="op">.</span>position <span class="op">+</span> (model<span class="op">.</span>velocity <span class="op">*</span> dt) }</span></code></pre></div>
<p>The above is the way to update a record. We start off with the <code>model</code> as the base, but update the <code>position</code> as per the formula. Note that <code>{ record | x = newX }</code> creates a new record, as everything in Elm is immutable. We will never have to worry about affecting anyone else’s state by accident. Even better, we can be certain no one else is affecting our state either!</p>
<p>The type annotation on <code>applyPhysics</code> says: given a <code>Float</code> and a <code>Model</code>, I will return a <code>Model</code>, but also: given a <code>Float</code>, I will return <code>Model -&gt; Model</code>. For example, <code>(applyPhysics 16.7)</code> would actually return a working function to which we can pass a <code>Model</code>, and get the physics-applied ship as the return value. This property is called <a href="http://en.wikipedia.org/wiki/Currying">Currying</a> and all Elm functions automatically behave this way. Currying is very useful in many cases, but that is a topic for another article.</p>
<p>We can update the other properties in the very same way:</p>
<div class="sourceCode" id="cb4"><pre class="sourceCode haskell"><code class="sourceCode haskell"><span id="cb4-1"><a href="#cb4-1" aria-hidden="true" tabindex="-1"></a>updateVelocity <span class="op">:</span> <span class="dt">Float</span> <span class="ot">-&gt;</span> <span class="dt">Model</span> <span class="ot">-&gt;</span> <span class="dt">Model</span></span>
<span id="cb4-2"><a href="#cb4-2" aria-hidden="true" tabindex="-1"></a>updateVelocity newVelocity model <span class="ot">=</span></span>
<span id="cb4-3"><a href="#cb4-3" aria-hidden="true" tabindex="-1"></a>    { model <span class="op">|</span> velocity <span class="ot">=</span> newVelocity }</span>
<span id="cb4-4"><a href="#cb4-4" aria-hidden="true" tabindex="-1"></a></span>
<span id="cb4-5"><a href="#cb4-5" aria-hidden="true" tabindex="-1"></a>incrementShotsFired <span class="op">:</span> <span class="dt">Model</span> <span class="ot">-&gt;</span> <span class="dt">Model</span></span>
<span id="cb4-6"><a href="#cb4-6" aria-hidden="true" tabindex="-1"></a>incrementShotsFired model <span class="ot">=</span></span>
<span id="cb4-7"><a href="#cb4-7" aria-hidden="true" tabindex="-1"></a>    { model <span class="op">|</span> shotsFired <span class="ot">=</span> model<span class="op">.</span>shotsFired <span class="op">+</span> <span class="dv">1</span> }</span></code></pre></div>
<p>Using these little functions we can update all of our state, but we’re missing something quite necessary:
1. View of the current state, and
2. getting input from the user and turning that into updates.</p>
<h2 id="showing-the-state">Showing the state</h2>
<p>Our game wouldn’t be much use if it couldn’t show the current state in some way. To keep things as simple as possible, let’s just print the model as text. We can do it like so:</p>
<div class="sourceCode" id="cb5"><pre class="sourceCode haskell"><code class="sourceCode haskell"><span id="cb5-1"><a href="#cb5-1" aria-hidden="true" tabindex="-1"></a>view <span class="op">:</span> <span class="dt">Model</span> <span class="ot">-&gt;</span> <span class="dt">Html</span> msg</span>
<span id="cb5-2"><a href="#cb5-2" aria-hidden="true" tabindex="-1"></a>view model <span class="ot">=</span></span>
<span id="cb5-3"><a href="#cb5-3" aria-hidden="true" tabindex="-1"></a>    text (toString model)</span></code></pre></div>
<p>Here, <code>toString</code> turns the <code>model</code> record into a readable String representation of it, and <code>text</code> from the Html package turns a String into an HTML text node. Pretty handy! Now the strange part here might be the return type of our <code>view</code> function: <code>Html msg</code>. We don’t need to worry about it too much right now, but what the type annotation is saying is in essence: “I am returning some HTML, which may produce messages of the <code>msg</code> variety.”</p>
<p>This will do for now, so let’s move on to the interactive part!</p>
<h2 id="subscribing-to-user-input">Subscribing to user input</h2>
<p>Elm 0.17 brought a new way of reacting to changes: Subscriptions. What we will do is this: we will subscribe to certain changes in the world, and when they happen, give the changes some names. We want to control the game by keyboard, so let’s start by taking a look at the <a href="http://package.elm-lang.org/packages/elm-lang/keyboard/1.0.0/Keyboard"><code>Keyboard</code></a> package. It seems we want to listen for both pressing down on buttons, and letting go of them. With these, we can determine when the user is pressing down on a certain key. We will need something else aswell: to keep updating the position of our ship, we need to have a somewhat steady rhythm of <code>applyPhysics</code> with the time difference! That we can get using the <a href="http://package.elm-lang.org/packages/elm-lang/animation-frame/1.0.0/AnimationFrame#diffs"><code>AnimationFrame.diffs</code></a>. Bundling that up into code looks a little like this.</p>
<p>Defining the messages in our program:</p>
<div class="sourceCode" id="cb6"><pre class="sourceCode haskell"><code class="sourceCode haskell"><span id="cb6-1"><a href="#cb6-1" aria-hidden="true" tabindex="-1"></a><span class="kw">type</span> <span class="dt">Msg</span></span>
<span id="cb6-2"><a href="#cb6-2" aria-hidden="true" tabindex="-1"></a>    <span class="ot">=</span> <span class="dt">TimeUpdate</span> <span class="dt">Time</span></span>
<span id="cb6-3"><a href="#cb6-3" aria-hidden="true" tabindex="-1"></a>    <span class="op">|</span> <span class="dt">KeyDown</span> <span class="dt">KeyCode</span></span>
<span id="cb6-4"><a href="#cb6-4" aria-hidden="true" tabindex="-1"></a>    <span class="op">|</span> <span class="dt">KeyUp</span> <span class="dt">KeyCode</span></span></code></pre></div>
<p>Here we have a union type. For something to be considered a <code>Msg</code> in this module, it will have to be one of the above (<code>TimeUpdate</code>, <code>KeyDown</code> or <code>KeyUp</code>). Furthermore, the contents of e.g. <code>TimeUpdate</code> must be something that can be considered <code>Time</code>, and so on.</p>
<p>Okay, now let’s declare the subscriptions we need, and name them with our newly-defined message types.</p>
<div class="sourceCode" id="cb7"><pre class="sourceCode haskell"><code class="sourceCode haskell"><span id="cb7-1"><a href="#cb7-1" aria-hidden="true" tabindex="-1"></a>subscriptions <span class="op">:</span> <span class="dt">Model</span> <span class="ot">-&gt;</span> <span class="dt">Sub</span> <span class="dt">Msg</span></span>
<span id="cb7-2"><a href="#cb7-2" aria-hidden="true" tabindex="-1"></a>subscriptions model <span class="ot">=</span></span>
<span id="cb7-3"><a href="#cb7-3" aria-hidden="true" tabindex="-1"></a>    Sub.batch</span>
<span id="cb7-4"><a href="#cb7-4" aria-hidden="true" tabindex="-1"></a>        [ AnimationFrame.diffs <span class="dt">TimeUpdate</span></span>
<span id="cb7-5"><a href="#cb7-5" aria-hidden="true" tabindex="-1"></a>        , Keyboard.downs <span class="dt">KeyDown</span></span>
<span id="cb7-6"><a href="#cb7-6" aria-hidden="true" tabindex="-1"></a>        , Keyboard.ups <span class="dt">KeyUp</span></span>
<span id="cb7-7"><a href="#cb7-7" aria-hidden="true" tabindex="-1"></a>        ]</span></code></pre></div>
<p>This again will just return a subscription, or a <code>Sub Msg</code>. It doesn’t do anything on its own, but we need it for the actual wiring part of our code:</p>
<div class="sourceCode" id="cb8"><pre class="sourceCode haskell"><code class="sourceCode haskell"><span id="cb8-1"><a href="#cb8-1" aria-hidden="true" tabindex="-1"></a>main <span class="ot">=</span></span>
<span id="cb8-2"><a href="#cb8-2" aria-hidden="true" tabindex="-1"></a>    Html.program</span>
<span id="cb8-3"><a href="#cb8-3" aria-hidden="true" tabindex="-1"></a>        { <span class="fu">init</span> <span class="ot">=</span> <span class="fu">init</span></span>
<span id="cb8-4"><a href="#cb8-4" aria-hidden="true" tabindex="-1"></a>        , view <span class="ot">=</span> view</span>
<span id="cb8-5"><a href="#cb8-5" aria-hidden="true" tabindex="-1"></a>        , update <span class="ot">=</span> update</span>
<span id="cb8-6"><a href="#cb8-6" aria-hidden="true" tabindex="-1"></a>        , subscriptions <span class="ot">=</span> subscriptions</span>
<span id="cb8-7"><a href="#cb8-7" aria-hidden="true" tabindex="-1"></a>        }</span></code></pre></div>
<p>If you are really paying attention, you might notice that we have <code>view</code> and <code>subscriptions</code> done by now, but both <code>init</code> and <code>update</code> are still missing. Luckily we already have all the building blocks, so taking this home shouldn’t be too much of a stretch anymore! In fact, <code>init</code> is so simple that we should get it out of the way right now.</p>
<div class="sourceCode" id="cb9"><pre class="sourceCode haskell"><code class="sourceCode haskell"><span id="cb9-1"><a href="#cb9-1" aria-hidden="true" tabindex="-1"></a><span class="fu">init</span> <span class="op">:</span> ( <span class="dt">Model</span>, <span class="dt">Cmd</span> <span class="dt">Msg</span> )</span>
<span id="cb9-2"><a href="#cb9-2" aria-hidden="true" tabindex="-1"></a><span class="fu">init</span> <span class="ot">=</span></span>
<span id="cb9-3"><a href="#cb9-3" aria-hidden="true" tabindex="-1"></a>    ( model, Cmd.none )</span></code></pre></div>
<p>That’s all there is to it! Again, we can leave the <code>Cmd</code> stuff for later, but just as a primer: commands are the only way to have effects in an Elm program. What are effects? They are anything that can affect the world outside the app (such as posting something to the Internet), or whose value can vary between program runs (such as the current time, or random numbers). Here we don’t need to do any commands, so we define it to be <code>none</code>.</p>
<h2 id="putting-it-all-together-the-update">Putting it all together: the update</h2>
<p>All right, now’s the time to make it all work!</p>
<p>Let’s begin from the high level. The <code>update</code> function takes the incoming message and the old model, and returns the updated model along with possible commands. In this case we won’t need any commands, but we still need to fulfill the contract with <code>none</code>s.</p>
<div class="sourceCode" id="cb10"><pre class="sourceCode haskell"><code class="sourceCode haskell"><span id="cb10-1"><a href="#cb10-1" aria-hidden="true" tabindex="-1"></a>update <span class="op">:</span> <span class="dt">Msg</span> <span class="ot">-&gt;</span> <span class="dt">Model</span> <span class="ot">-&gt;</span> ( <span class="dt">Model</span>, <span class="dt">Cmd</span> <span class="dt">Msg</span> )</span>
<span id="cb10-2"><a href="#cb10-2" aria-hidden="true" tabindex="-1"></a>update msg model <span class="ot">=</span></span>
<span id="cb10-3"><a href="#cb10-3" aria-hidden="true" tabindex="-1"></a>    <span class="kw">case</span> msg <span class="kw">of</span></span>
<span id="cb10-4"><a href="#cb10-4" aria-hidden="true" tabindex="-1"></a>        <span class="dt">TimeUpdate</span> dt <span class="ot">-&gt;</span></span>
<span id="cb10-5"><a href="#cb10-5" aria-hidden="true" tabindex="-1"></a>            ( applyPhysics dt model, Cmd.none )</span>
<span id="cb10-6"><a href="#cb10-6" aria-hidden="true" tabindex="-1"></a></span>
<span id="cb10-7"><a href="#cb10-7" aria-hidden="true" tabindex="-1"></a>        <span class="dt">KeyDown</span> keyCode <span class="ot">-&gt;</span></span>
<span id="cb10-8"><a href="#cb10-8" aria-hidden="true" tabindex="-1"></a>            ( keyDown keyCode model, Cmd.none )</span>
<span id="cb10-9"><a href="#cb10-9" aria-hidden="true" tabindex="-1"></a></span>
<span id="cb10-10"><a href="#cb10-10" aria-hidden="true" tabindex="-1"></a>        <span class="dt">KeyUp</span> keyCode <span class="ot">-&gt;</span></span>
<span id="cb10-11"><a href="#cb10-11" aria-hidden="true" tabindex="-1"></a>            ( keyUp keyCode model, Cmd.none )</span></code></pre></div>
<p>Note that each of the possible <code>Msg</code> options is handled. If they weren’t, the Elm compiler would catch the problem, which is pretty cool and impressive. Anyway, the <code>TimeUpdate</code> is nice and easy. We can simply use the <code>applyPhysics</code> function to get the updated model. For the keypressing cases, I decided to split the handling into their own functions as well.</p>
<p>When it comes to the packages, Elm 0.17 is still a bit of a work in progress. So to make the keyboard handling a little nicer, I made a tiny helper module. There is a function that can turn a <code>KeyCode</code> into a <code>Key</code>, which is a simple union type. It only has the keys we need for this exercise now, but could easily be extended.</p>
<div class="sourceCode" id="cb11"><pre class="sourceCode haskell"><code class="sourceCode haskell"><span id="cb11-1"><a href="#cb11-1" aria-hidden="true" tabindex="-1"></a>keyDown <span class="op">:</span> <span class="dt">KeyCode</span> <span class="ot">-&gt;</span> <span class="dt">Model</span> <span class="ot">-&gt;</span> <span class="dt">Model</span></span>
<span id="cb11-2"><a href="#cb11-2" aria-hidden="true" tabindex="-1"></a>keyDown keyCode model <span class="ot">=</span></span>
<span id="cb11-3"><a href="#cb11-3" aria-hidden="true" tabindex="-1"></a>    <span class="kw">case</span> Key.fromCode keyCode <span class="kw">of</span></span>
<span id="cb11-4"><a href="#cb11-4" aria-hidden="true" tabindex="-1"></a>        <span class="dt">Space</span> <span class="ot">-&gt;</span></span>
<span id="cb11-5"><a href="#cb11-5" aria-hidden="true" tabindex="-1"></a>            incrementShotsFired model</span>
<span id="cb11-6"><a href="#cb11-6" aria-hidden="true" tabindex="-1"></a></span>
<span id="cb11-7"><a href="#cb11-7" aria-hidden="true" tabindex="-1"></a>        <span class="dt">ArrowLeft</span> <span class="ot">-&gt;</span></span>
<span id="cb11-8"><a href="#cb11-8" aria-hidden="true" tabindex="-1"></a>            updateVelocity <span class="op">-</span><span class="fl">1.0</span> model</span>
<span id="cb11-9"><a href="#cb11-9" aria-hidden="true" tabindex="-1"></a></span>
<span id="cb11-10"><a href="#cb11-10" aria-hidden="true" tabindex="-1"></a>        <span class="dt">ArrowRight</span> <span class="ot">-&gt;</span></span>
<span id="cb11-11"><a href="#cb11-11" aria-hidden="true" tabindex="-1"></a>            updateVelocity <span class="fl">1.0</span> model</span>
<span id="cb11-12"><a href="#cb11-12" aria-hidden="true" tabindex="-1"></a></span>
<span id="cb11-13"><a href="#cb11-13" aria-hidden="true" tabindex="-1"></a>        _ <span class="ot">-&gt;</span></span>
<span id="cb11-14"><a href="#cb11-14" aria-hidden="true" tabindex="-1"></a>            model</span></code></pre></div>
<p>The above should be pretty clear. Spacebar shoots once as soon as it is pressed down and doesn’t do anything else. The arrow keys set the velocity of the ship when pressed down. Notice that we need an “otherwise” case, customarily denoted as <code>_</code>. This is because there are many other possible keys on the keyboard besides the ones we’ve covered.</p>
<p>How about the release part?</p>
<div class="sourceCode" id="cb12"><pre class="sourceCode haskell"><code class="sourceCode haskell"><span id="cb12-1"><a href="#cb12-1" aria-hidden="true" tabindex="-1"></a>keyUp <span class="op">:</span> <span class="dt">KeyCode</span> <span class="ot">-&gt;</span> <span class="dt">Model</span> <span class="ot">-&gt;</span> <span class="dt">Model</span></span>
<span id="cb12-2"><a href="#cb12-2" aria-hidden="true" tabindex="-1"></a>keyUp keyCode model <span class="ot">=</span></span>
<span id="cb12-3"><a href="#cb12-3" aria-hidden="true" tabindex="-1"></a>    <span class="kw">case</span> Key.fromCode keyCode <span class="kw">of</span></span>
<span id="cb12-4"><a href="#cb12-4" aria-hidden="true" tabindex="-1"></a>        <span class="dt">ArrowLeft</span> <span class="ot">-&gt;</span></span>
<span id="cb12-5"><a href="#cb12-5" aria-hidden="true" tabindex="-1"></a>            updateVelocity <span class="dv">0</span> model</span>
<span id="cb12-6"><a href="#cb12-6" aria-hidden="true" tabindex="-1"></a></span>
<span id="cb12-7"><a href="#cb12-7" aria-hidden="true" tabindex="-1"></a>        <span class="dt">ArrowRight</span> <span class="ot">-&gt;</span></span>
<span id="cb12-8"><a href="#cb12-8" aria-hidden="true" tabindex="-1"></a>            updateVelocity <span class="dv">0</span> model</span>
<span id="cb12-9"><a href="#cb12-9" aria-hidden="true" tabindex="-1"></a></span>
<span id="cb12-10"><a href="#cb12-10" aria-hidden="true" tabindex="-1"></a>        _ <span class="ot">-&gt;</span></span>
<span id="cb12-11"><a href="#cb12-11" aria-hidden="true" tabindex="-1"></a>            model</span></code></pre></div>
<p>If the released key happened to be one of the movement keys, reset the velocity to 0, otherwise let’s just keep the current model. Pretty straightforward, right?</p>
<p>Now it should work!</p>
<h2 id="the-code">The code</h2>
<p>Below is the full code, imports and all. You can also find the code on <a href="https://github.com/ohanhi/elm-game-base">GitHub</a>, along with some setup instructions.</p>
<p><strong>Game.elm</strong></p>
<div class="sourceCode" id="cb13"><pre class="sourceCode haskell"><code class="sourceCode haskell"><span id="cb13-1"><a href="#cb13-1" aria-hidden="true" tabindex="-1"></a><span class="kw">module</span> <span class="dt">Game</span> exposing (<span class="op">..</span>)</span>
<span id="cb13-2"><a href="#cb13-2" aria-hidden="true" tabindex="-1"></a></span>
<span id="cb13-3"><a href="#cb13-3" aria-hidden="true" tabindex="-1"></a><span class="kw">import</span> <span class="dt">Html</span> exposing (<span class="dt">Html</span>, text)</span>
<span id="cb13-4"><a href="#cb13-4" aria-hidden="true" tabindex="-1"></a><span class="kw">import</span> <span class="dt">Html.App</span> <span class="kw">as</span> <span class="dt">Html</span></span>
<span id="cb13-5"><a href="#cb13-5" aria-hidden="true" tabindex="-1"></a><span class="kw">import</span> <span class="dt">Keyboard</span> exposing (<span class="dt">KeyCode</span>)</span>
<span id="cb13-6"><a href="#cb13-6" aria-hidden="true" tabindex="-1"></a><span class="kw">import</span> <span class="dt">AnimationFrame</span></span>
<span id="cb13-7"><a href="#cb13-7" aria-hidden="true" tabindex="-1"></a><span class="kw">import</span> <span class="dt">Time</span> exposing (<span class="dt">Time</span>)</span>
<span id="cb13-8"><a href="#cb13-8" aria-hidden="true" tabindex="-1"></a><span class="kw">import</span> <span class="dt">Key</span> exposing (..)</span>
<span id="cb13-9"><a href="#cb13-9" aria-hidden="true" tabindex="-1"></a></span>
<span id="cb13-10"><a href="#cb13-10" aria-hidden="true" tabindex="-1"></a></span>
<span id="cb13-11"><a href="#cb13-11" aria-hidden="true" tabindex="-1"></a>main <span class="ot">=</span></span>
<span id="cb13-12"><a href="#cb13-12" aria-hidden="true" tabindex="-1"></a>    Html.program</span>
<span id="cb13-13"><a href="#cb13-13" aria-hidden="true" tabindex="-1"></a>        { <span class="fu">init</span> <span class="ot">=</span> <span class="fu">init</span></span>
<span id="cb13-14"><a href="#cb13-14" aria-hidden="true" tabindex="-1"></a>        , view <span class="ot">=</span> view</span>
<span id="cb13-15"><a href="#cb13-15" aria-hidden="true" tabindex="-1"></a>        , update <span class="ot">=</span> update</span>
<span id="cb13-16"><a href="#cb13-16" aria-hidden="true" tabindex="-1"></a>        , subscriptions <span class="ot">=</span> subscriptions</span>
<span id="cb13-17"><a href="#cb13-17" aria-hidden="true" tabindex="-1"></a>        }</span>
<span id="cb13-18"><a href="#cb13-18" aria-hidden="true" tabindex="-1"></a></span>
<span id="cb13-19"><a href="#cb13-19" aria-hidden="true" tabindex="-1"></a></span>
<span id="cb13-20"><a href="#cb13-20" aria-hidden="true" tabindex="-1"></a></span>
<span id="cb13-21"><a href="#cb13-21" aria-hidden="true" tabindex="-1"></a><span class="co">-- MODEL</span></span>
<span id="cb13-22"><a href="#cb13-22" aria-hidden="true" tabindex="-1"></a></span>
<span id="cb13-23"><a href="#cb13-23" aria-hidden="true" tabindex="-1"></a></span>
<span id="cb13-24"><a href="#cb13-24" aria-hidden="true" tabindex="-1"></a><span class="kw">type</span> alias <span class="dt">Model</span> <span class="ot">=</span></span>
<span id="cb13-25"><a href="#cb13-25" aria-hidden="true" tabindex="-1"></a>    { velocity <span class="op">:</span> <span class="dt">Float</span></span>
<span id="cb13-26"><a href="#cb13-26" aria-hidden="true" tabindex="-1"></a>    , position <span class="op">:</span> <span class="dt">Float</span></span>
<span id="cb13-27"><a href="#cb13-27" aria-hidden="true" tabindex="-1"></a>    , shotsFired <span class="op">:</span> <span class="dt">Int</span></span>
<span id="cb13-28"><a href="#cb13-28" aria-hidden="true" tabindex="-1"></a>    }</span>
<span id="cb13-29"><a href="#cb13-29" aria-hidden="true" tabindex="-1"></a></span>
<span id="cb13-30"><a href="#cb13-30" aria-hidden="true" tabindex="-1"></a></span>
<span id="cb13-31"><a href="#cb13-31" aria-hidden="true" tabindex="-1"></a>model <span class="op">:</span> <span class="dt">Model</span></span>
<span id="cb13-32"><a href="#cb13-32" aria-hidden="true" tabindex="-1"></a>model <span class="ot">=</span></span>
<span id="cb13-33"><a href="#cb13-33" aria-hidden="true" tabindex="-1"></a>    { velocity <span class="ot">=</span> <span class="dv">0</span></span>
<span id="cb13-34"><a href="#cb13-34" aria-hidden="true" tabindex="-1"></a>    , position <span class="ot">=</span> <span class="dv">0</span></span>
<span id="cb13-35"><a href="#cb13-35" aria-hidden="true" tabindex="-1"></a>    , shotsFired <span class="ot">=</span> <span class="dv">0</span></span>
<span id="cb13-36"><a href="#cb13-36" aria-hidden="true" tabindex="-1"></a>    }</span>
<span id="cb13-37"><a href="#cb13-37" aria-hidden="true" tabindex="-1"></a></span>
<span id="cb13-38"><a href="#cb13-38" aria-hidden="true" tabindex="-1"></a></span>
<span id="cb13-39"><a href="#cb13-39" aria-hidden="true" tabindex="-1"></a><span class="fu">init</span> <span class="op">:</span> ( <span class="dt">Model</span>, <span class="dt">Cmd</span> <span class="dt">Msg</span> )</span>
<span id="cb13-40"><a href="#cb13-40" aria-hidden="true" tabindex="-1"></a><span class="fu">init</span> <span class="ot">=</span></span>
<span id="cb13-41"><a href="#cb13-41" aria-hidden="true" tabindex="-1"></a>    ( model, Cmd.none )</span>
<span id="cb13-42"><a href="#cb13-42" aria-hidden="true" tabindex="-1"></a></span>
<span id="cb13-43"><a href="#cb13-43" aria-hidden="true" tabindex="-1"></a></span>
<span id="cb13-44"><a href="#cb13-44" aria-hidden="true" tabindex="-1"></a></span>
<span id="cb13-45"><a href="#cb13-45" aria-hidden="true" tabindex="-1"></a><span class="co">-- UPDATE</span></span>
<span id="cb13-46"><a href="#cb13-46" aria-hidden="true" tabindex="-1"></a></span>
<span id="cb13-47"><a href="#cb13-47" aria-hidden="true" tabindex="-1"></a></span>
<span id="cb13-48"><a href="#cb13-48" aria-hidden="true" tabindex="-1"></a><span class="kw">type</span> <span class="dt">Msg</span></span>
<span id="cb13-49"><a href="#cb13-49" aria-hidden="true" tabindex="-1"></a>    <span class="ot">=</span> <span class="dt">TimeUpdate</span> <span class="dt">Time</span></span>
<span id="cb13-50"><a href="#cb13-50" aria-hidden="true" tabindex="-1"></a>    <span class="op">|</span> <span class="dt">KeyDown</span> <span class="dt">KeyCode</span></span>
<span id="cb13-51"><a href="#cb13-51" aria-hidden="true" tabindex="-1"></a>    <span class="op">|</span> <span class="dt">KeyUp</span> <span class="dt">KeyCode</span></span>
<span id="cb13-52"><a href="#cb13-52" aria-hidden="true" tabindex="-1"></a></span>
<span id="cb13-53"><a href="#cb13-53" aria-hidden="true" tabindex="-1"></a></span>
<span id="cb13-54"><a href="#cb13-54" aria-hidden="true" tabindex="-1"></a>update <span class="op">:</span> <span class="dt">Msg</span> <span class="ot">-&gt;</span> <span class="dt">Model</span> <span class="ot">-&gt;</span> ( <span class="dt">Model</span>, <span class="dt">Cmd</span> <span class="dt">Msg</span> )</span>
<span id="cb13-55"><a href="#cb13-55" aria-hidden="true" tabindex="-1"></a>update msg model <span class="ot">=</span></span>
<span id="cb13-56"><a href="#cb13-56" aria-hidden="true" tabindex="-1"></a>    <span class="kw">case</span> msg <span class="kw">of</span></span>
<span id="cb13-57"><a href="#cb13-57" aria-hidden="true" tabindex="-1"></a>        <span class="dt">TimeUpdate</span> dt <span class="ot">-&gt;</span></span>
<span id="cb13-58"><a href="#cb13-58" aria-hidden="true" tabindex="-1"></a>            ( applyPhysics dt model, Cmd.none )</span>
<span id="cb13-59"><a href="#cb13-59" aria-hidden="true" tabindex="-1"></a></span>
<span id="cb13-60"><a href="#cb13-60" aria-hidden="true" tabindex="-1"></a>        <span class="dt">KeyDown</span> keyCode <span class="ot">-&gt;</span></span>
<span id="cb13-61"><a href="#cb13-61" aria-hidden="true" tabindex="-1"></a>            ( keyDown keyCode model, Cmd.none )</span>
<span id="cb13-62"><a href="#cb13-62" aria-hidden="true" tabindex="-1"></a></span>
<span id="cb13-63"><a href="#cb13-63" aria-hidden="true" tabindex="-1"></a>        <span class="dt">KeyUp</span> keyCode <span class="ot">-&gt;</span></span>
<span id="cb13-64"><a href="#cb13-64" aria-hidden="true" tabindex="-1"></a>            ( keyUp keyCode model, Cmd.none )</span>
<span id="cb13-65"><a href="#cb13-65" aria-hidden="true" tabindex="-1"></a></span>
<span id="cb13-66"><a href="#cb13-66" aria-hidden="true" tabindex="-1"></a></span>
<span id="cb13-67"><a href="#cb13-67" aria-hidden="true" tabindex="-1"></a>keyDown <span class="op">:</span> <span class="dt">KeyCode</span> <span class="ot">-&gt;</span> <span class="dt">Model</span> <span class="ot">-&gt;</span> <span class="dt">Model</span></span>
<span id="cb13-68"><a href="#cb13-68" aria-hidden="true" tabindex="-1"></a>keyDown keyCode model <span class="ot">=</span></span>
<span id="cb13-69"><a href="#cb13-69" aria-hidden="true" tabindex="-1"></a>    <span class="kw">case</span> Key.fromCode keyCode <span class="kw">of</span></span>
<span id="cb13-70"><a href="#cb13-70" aria-hidden="true" tabindex="-1"></a>        <span class="dt">Space</span> <span class="ot">-&gt;</span></span>
<span id="cb13-71"><a href="#cb13-71" aria-hidden="true" tabindex="-1"></a>            incrementShotsFired model</span>
<span id="cb13-72"><a href="#cb13-72" aria-hidden="true" tabindex="-1"></a></span>
<span id="cb13-73"><a href="#cb13-73" aria-hidden="true" tabindex="-1"></a>        <span class="dt">ArrowLeft</span> <span class="ot">-&gt;</span></span>
<span id="cb13-74"><a href="#cb13-74" aria-hidden="true" tabindex="-1"></a>            updateVelocity <span class="op">-</span><span class="fl">1.0</span> model</span>
<span id="cb13-75"><a href="#cb13-75" aria-hidden="true" tabindex="-1"></a></span>
<span id="cb13-76"><a href="#cb13-76" aria-hidden="true" tabindex="-1"></a>        <span class="dt">ArrowRight</span> <span class="ot">-&gt;</span></span>
<span id="cb13-77"><a href="#cb13-77" aria-hidden="true" tabindex="-1"></a>            updateVelocity <span class="fl">1.0</span> model</span>
<span id="cb13-78"><a href="#cb13-78" aria-hidden="true" tabindex="-1"></a></span>
<span id="cb13-79"><a href="#cb13-79" aria-hidden="true" tabindex="-1"></a>        _ <span class="ot">-&gt;</span></span>
<span id="cb13-80"><a href="#cb13-80" aria-hidden="true" tabindex="-1"></a>            model</span>
<span id="cb13-81"><a href="#cb13-81" aria-hidden="true" tabindex="-1"></a></span>
<span id="cb13-82"><a href="#cb13-82" aria-hidden="true" tabindex="-1"></a></span>
<span id="cb13-83"><a href="#cb13-83" aria-hidden="true" tabindex="-1"></a>keyUp <span class="op">:</span> <span class="dt">KeyCode</span> <span class="ot">-&gt;</span> <span class="dt">Model</span> <span class="ot">-&gt;</span> <span class="dt">Model</span></span>
<span id="cb13-84"><a href="#cb13-84" aria-hidden="true" tabindex="-1"></a>keyUp keyCode model <span class="ot">=</span></span>
<span id="cb13-85"><a href="#cb13-85" aria-hidden="true" tabindex="-1"></a>    <span class="kw">case</span> Key.fromCode keyCode <span class="kw">of</span></span>
<span id="cb13-86"><a href="#cb13-86" aria-hidden="true" tabindex="-1"></a>        <span class="dt">ArrowLeft</span> <span class="ot">-&gt;</span></span>
<span id="cb13-87"><a href="#cb13-87" aria-hidden="true" tabindex="-1"></a>            updateVelocity <span class="dv">0</span> model</span>
<span id="cb13-88"><a href="#cb13-88" aria-hidden="true" tabindex="-1"></a></span>
<span id="cb13-89"><a href="#cb13-89" aria-hidden="true" tabindex="-1"></a>        <span class="dt">ArrowRight</span> <span class="ot">-&gt;</span></span>
<span id="cb13-90"><a href="#cb13-90" aria-hidden="true" tabindex="-1"></a>            updateVelocity <span class="dv">0</span> model</span>
<span id="cb13-91"><a href="#cb13-91" aria-hidden="true" tabindex="-1"></a></span>
<span id="cb13-92"><a href="#cb13-92" aria-hidden="true" tabindex="-1"></a>        _ <span class="ot">-&gt;</span></span>
<span id="cb13-93"><a href="#cb13-93" aria-hidden="true" tabindex="-1"></a>            model</span>
<span id="cb13-94"><a href="#cb13-94" aria-hidden="true" tabindex="-1"></a></span>
<span id="cb13-95"><a href="#cb13-95" aria-hidden="true" tabindex="-1"></a></span>
<span id="cb13-96"><a href="#cb13-96" aria-hidden="true" tabindex="-1"></a>applyPhysics <span class="op">:</span> <span class="dt">Float</span> <span class="ot">-&gt;</span> <span class="dt">Model</span> <span class="ot">-&gt;</span> <span class="dt">Model</span></span>
<span id="cb13-97"><a href="#cb13-97" aria-hidden="true" tabindex="-1"></a>applyPhysics dt model <span class="ot">=</span></span>
<span id="cb13-98"><a href="#cb13-98" aria-hidden="true" tabindex="-1"></a>    { model <span class="op">|</span> position <span class="ot">=</span> model<span class="op">.</span>position <span class="op">+</span> model<span class="op">.</span>velocity <span class="op">*</span> dt }</span>
<span id="cb13-99"><a href="#cb13-99" aria-hidden="true" tabindex="-1"></a></span>
<span id="cb13-100"><a href="#cb13-100" aria-hidden="true" tabindex="-1"></a></span>
<span id="cb13-101"><a href="#cb13-101" aria-hidden="true" tabindex="-1"></a>updateVelocity <span class="op">:</span> <span class="dt">Float</span> <span class="ot">-&gt;</span> <span class="dt">Model</span> <span class="ot">-&gt;</span> <span class="dt">Model</span></span>
<span id="cb13-102"><a href="#cb13-102" aria-hidden="true" tabindex="-1"></a>updateVelocity newVelocity model <span class="ot">=</span></span>
<span id="cb13-103"><a href="#cb13-103" aria-hidden="true" tabindex="-1"></a>    { model <span class="op">|</span> velocity <span class="ot">=</span> newVelocity }</span>
<span id="cb13-104"><a href="#cb13-104" aria-hidden="true" tabindex="-1"></a></span>
<span id="cb13-105"><a href="#cb13-105" aria-hidden="true" tabindex="-1"></a></span>
<span id="cb13-106"><a href="#cb13-106" aria-hidden="true" tabindex="-1"></a>incrementShotsFired <span class="op">:</span> <span class="dt">Model</span> <span class="ot">-&gt;</span> <span class="dt">Model</span></span>
<span id="cb13-107"><a href="#cb13-107" aria-hidden="true" tabindex="-1"></a>incrementShotsFired model <span class="ot">=</span></span>
<span id="cb13-108"><a href="#cb13-108" aria-hidden="true" tabindex="-1"></a>    { model <span class="op">|</span> shotsFired <span class="ot">=</span> model<span class="op">.</span>shotsFired <span class="op">+</span> <span class="dv">1</span> }</span>
<span id="cb13-109"><a href="#cb13-109" aria-hidden="true" tabindex="-1"></a></span>
<span id="cb13-110"><a href="#cb13-110" aria-hidden="true" tabindex="-1"></a></span>
<span id="cb13-111"><a href="#cb13-111" aria-hidden="true" tabindex="-1"></a></span>
<span id="cb13-112"><a href="#cb13-112" aria-hidden="true" tabindex="-1"></a><span class="co">-- VIEW</span></span>
<span id="cb13-113"><a href="#cb13-113" aria-hidden="true" tabindex="-1"></a></span>
<span id="cb13-114"><a href="#cb13-114" aria-hidden="true" tabindex="-1"></a></span>
<span id="cb13-115"><a href="#cb13-115" aria-hidden="true" tabindex="-1"></a>view <span class="op">:</span> <span class="dt">Model</span> <span class="ot">-&gt;</span> <span class="dt">Html</span> msg</span>
<span id="cb13-116"><a href="#cb13-116" aria-hidden="true" tabindex="-1"></a>view model <span class="ot">=</span></span>
<span id="cb13-117"><a href="#cb13-117" aria-hidden="true" tabindex="-1"></a>    text (toString model)</span>
<span id="cb13-118"><a href="#cb13-118" aria-hidden="true" tabindex="-1"></a></span>
<span id="cb13-119"><a href="#cb13-119" aria-hidden="true" tabindex="-1"></a></span>
<span id="cb13-120"><a href="#cb13-120" aria-hidden="true" tabindex="-1"></a></span>
<span id="cb13-121"><a href="#cb13-121" aria-hidden="true" tabindex="-1"></a><span class="co">-- SUBSCRIPTIONS</span></span>
<span id="cb13-122"><a href="#cb13-122" aria-hidden="true" tabindex="-1"></a></span>
<span id="cb13-123"><a href="#cb13-123" aria-hidden="true" tabindex="-1"></a></span>
<span id="cb13-124"><a href="#cb13-124" aria-hidden="true" tabindex="-1"></a>subscriptions <span class="op">:</span> <span class="dt">Model</span> <span class="ot">-&gt;</span> <span class="dt">Sub</span> <span class="dt">Msg</span></span>
<span id="cb13-125"><a href="#cb13-125" aria-hidden="true" tabindex="-1"></a>subscriptions model <span class="ot">=</span></span>
<span id="cb13-126"><a href="#cb13-126" aria-hidden="true" tabindex="-1"></a>    Sub.batch</span>
<span id="cb13-127"><a href="#cb13-127" aria-hidden="true" tabindex="-1"></a>        [ AnimationFrame.diffs <span class="dt">TimeUpdate</span></span>
<span id="cb13-128"><a href="#cb13-128" aria-hidden="true" tabindex="-1"></a>        , Keyboard.downs <span class="dt">KeyDown</span></span>
<span id="cb13-129"><a href="#cb13-129" aria-hidden="true" tabindex="-1"></a>        , Keyboard.ups <span class="dt">KeyUp</span></span>
<span id="cb13-130"><a href="#cb13-130" aria-hidden="true" tabindex="-1"></a>        ]</span></code></pre></div>
<p><strong>Key.elm</strong></p>
<div class="sourceCode" id="cb14"><pre class="sourceCode haskell"><code class="sourceCode haskell"><span id="cb14-1"><a href="#cb14-1" aria-hidden="true" tabindex="-1"></a><span class="kw">module</span> <span class="dt">Key</span> exposing (<span class="op">..</span>)</span>
<span id="cb14-2"><a href="#cb14-2" aria-hidden="true" tabindex="-1"></a></span>
<span id="cb14-3"><a href="#cb14-3" aria-hidden="true" tabindex="-1"></a></span>
<span id="cb14-4"><a href="#cb14-4" aria-hidden="true" tabindex="-1"></a><span class="kw">type</span> <span class="dt">Key</span></span>
<span id="cb14-5"><a href="#cb14-5" aria-hidden="true" tabindex="-1"></a>    <span class="ot">=</span> <span class="dt">Space</span></span>
<span id="cb14-6"><a href="#cb14-6" aria-hidden="true" tabindex="-1"></a>    <span class="op">|</span> <span class="dt">ArrowLeft</span></span>
<span id="cb14-7"><a href="#cb14-7" aria-hidden="true" tabindex="-1"></a>    <span class="op">|</span> <span class="dt">ArrowRight</span></span>
<span id="cb14-8"><a href="#cb14-8" aria-hidden="true" tabindex="-1"></a>    <span class="op">|</span> <span class="dt">Unknown</span></span>
<span id="cb14-9"><a href="#cb14-9" aria-hidden="true" tabindex="-1"></a></span>
<span id="cb14-10"><a href="#cb14-10" aria-hidden="true" tabindex="-1"></a></span>
<span id="cb14-11"><a href="#cb14-11" aria-hidden="true" tabindex="-1"></a>fromCode <span class="op">:</span> <span class="dt">Int</span> <span class="ot">-&gt;</span> <span class="dt">Key</span></span>
<span id="cb14-12"><a href="#cb14-12" aria-hidden="true" tabindex="-1"></a>fromCode keyCode <span class="ot">=</span></span>
<span id="cb14-13"><a href="#cb14-13" aria-hidden="true" tabindex="-1"></a>    <span class="kw">case</span> keyCode <span class="kw">of</span></span>
<span id="cb14-14"><a href="#cb14-14" aria-hidden="true" tabindex="-1"></a>        <span class="dv">32</span> <span class="ot">-&gt;</span></span>
<span id="cb14-15"><a href="#cb14-15" aria-hidden="true" tabindex="-1"></a>            <span class="dt">Space</span></span>
<span id="cb14-16"><a href="#cb14-16" aria-hidden="true" tabindex="-1"></a></span>
<span id="cb14-17"><a href="#cb14-17" aria-hidden="true" tabindex="-1"></a>        <span class="dv">37</span> <span class="ot">-&gt;</span></span>
<span id="cb14-18"><a href="#cb14-18" aria-hidden="true" tabindex="-1"></a>            <span class="dt">ArrowLeft</span></span>
<span id="cb14-19"><a href="#cb14-19" aria-hidden="true" tabindex="-1"></a></span>
<span id="cb14-20"><a href="#cb14-20" aria-hidden="true" tabindex="-1"></a>        <span class="dv">39</span> <span class="ot">-&gt;</span></span>
<span id="cb14-21"><a href="#cb14-21" aria-hidden="true" tabindex="-1"></a>            <span class="dt">ArrowRight</span></span>
<span id="cb14-22"><a href="#cb14-22" aria-hidden="true" tabindex="-1"></a></span>
<span id="cb14-23"><a href="#cb14-23" aria-hidden="true" tabindex="-1"></a>        _ <span class="ot">-&gt;</span></span>
<span id="cb14-24"><a href="#cb14-24" aria-hidden="true" tabindex="-1"></a>            <span class="dt">Unknown</span></span></code></pre></div>
<p><strong>elm-package.json</strong></p>
<div class="sourceCode" id="cb15"><pre class="sourceCode json"><code class="sourceCode json"><span id="cb15-1"><a href="#cb15-1" aria-hidden="true" tabindex="-1"></a><span class="fu">{</span></span>
<span id="cb15-2"><a href="#cb15-2" aria-hidden="true" tabindex="-1"></a>    <span class="dt">&quot;version&quot;</span><span class="fu">:</span> <span class="st">&quot;1.0.0&quot;</span><span class="fu">,</span></span>
<span id="cb15-3"><a href="#cb15-3" aria-hidden="true" tabindex="-1"></a>    <span class="dt">&quot;summary&quot;</span><span class="fu">:</span> <span class="st">&quot;Example base for a game in Elm 0.17&quot;</span><span class="fu">,</span></span>
<span id="cb15-4"><a href="#cb15-4" aria-hidden="true" tabindex="-1"></a>    <span class="dt">&quot;repository&quot;</span><span class="fu">:</span> <span class="st">&quot;https://github.com/ohanhi/elm-game-base.git&quot;</span><span class="fu">,</span></span>
<span id="cb15-5"><a href="#cb15-5" aria-hidden="true" tabindex="-1"></a>    <span class="dt">&quot;license&quot;</span><span class="fu">:</span> <span class="st">&quot;BSD3&quot;</span><span class="fu">,</span></span>
<span id="cb15-6"><a href="#cb15-6" aria-hidden="true" tabindex="-1"></a>    <span class="dt">&quot;source-directories&quot;</span><span class="fu">:</span> <span class="ot">[</span></span>
<span id="cb15-7"><a href="#cb15-7" aria-hidden="true" tabindex="-1"></a>        <span class="st">&quot;.&quot;</span></span>
<span id="cb15-8"><a href="#cb15-8" aria-hidden="true" tabindex="-1"></a>    <span class="ot">]</span><span class="fu">,</span></span>
<span id="cb15-9"><a href="#cb15-9" aria-hidden="true" tabindex="-1"></a>    <span class="dt">&quot;exposed-modules&quot;</span><span class="fu">:</span> <span class="ot">[]</span><span class="fu">,</span></span>
<span id="cb15-10"><a href="#cb15-10" aria-hidden="true" tabindex="-1"></a>    <span class="dt">&quot;dependencies&quot;</span><span class="fu">:</span> <span class="fu">{</span></span>
<span id="cb15-11"><a href="#cb15-11" aria-hidden="true" tabindex="-1"></a>        <span class="dt">&quot;elm-lang/animation-frame&quot;</span><span class="fu">:</span> <span class="st">&quot;1.0.0 &lt;= v &lt; 2.0.0&quot;</span><span class="fu">,</span></span>
<span id="cb15-12"><a href="#cb15-12" aria-hidden="true" tabindex="-1"></a>        <span class="dt">&quot;elm-lang/core&quot;</span><span class="fu">:</span> <span class="st">&quot;4.0.0 &lt;= v &lt; 5.0.0&quot;</span><span class="fu">,</span></span>
<span id="cb15-13"><a href="#cb15-13" aria-hidden="true" tabindex="-1"></a>        <span class="dt">&quot;elm-lang/html&quot;</span><span class="fu">:</span> <span class="st">&quot;1.0.0 &lt;= v &lt; 2.0.0&quot;</span><span class="fu">,</span></span>
<span id="cb15-14"><a href="#cb15-14" aria-hidden="true" tabindex="-1"></a>        <span class="dt">&quot;elm-lang/keyboard&quot;</span><span class="fu">:</span> <span class="st">&quot;1.0.0 &lt;= v &lt; 2.0.0&quot;</span></span>
<span id="cb15-15"><a href="#cb15-15" aria-hidden="true" tabindex="-1"></a>    <span class="fu">},</span></span>
<span id="cb15-16"><a href="#cb15-16" aria-hidden="true" tabindex="-1"></a>    <span class="dt">&quot;elm-version&quot;</span><span class="fu">:</span> <span class="st">&quot;0.17.0 &lt;= v &lt; 0.18.0&quot;</span></span>
<span id="cb15-17"><a href="#cb15-17" aria-hidden="true" tabindex="-1"></a><span class="fu">}</span></span></code></pre></div>


  </section>
  <footer>
    <a href="https://github.com/ohanhi">GitHub</a>
  </footer>

  <script src="../js/main.js"></script>
  <script>
  (function(b,o,i,l,e,r){b.GoogleAnalyticsObject=l;b[l]||(b[l]=
    function(){(b[l].q=b[l].q||[]).push(arguments)});b[l].l=+new Date;
    e=o.createElement(i);r=o.getElementsByTagName(i)[0];
    e.src='https://www.google-analytics.com/analytics.js';
    r.parentNode.insertBefore(e,r)}(window,document,'script','ga'));
    ga('create','UA-58943555-1');ga('send','pageview');
    </script>
  </body>
  </html>
