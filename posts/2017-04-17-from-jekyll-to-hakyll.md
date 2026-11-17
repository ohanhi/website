<!DOCTYPE html>
<html class="no-js">
<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
  <title> From Jekyll to Hakyll - Ossi Hanhinen</title>
  <meta name="description" content="From Jekyll to Hakyll">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="../css/main.css">
</head>
<body>
  <section class="contain post">
    <a href="../" class="back-link">&laquo; Home</a>

    <header class="post-header">
  
  <h1 class="post-title">From Jekyll to Hakyll</h1>
  
</header>
<div class="post-meta">
  <img class="profile-pic" src="../img/profile_tiny.jpg" alt>
  <h3 class="author">
    <span>Ossi Hanhinen</span>
    <a href="https://github.com/ohanhi">@ohanhi</a>
  </h3>
  <p class="post-date">April 17, 2017</p>
</div>

<hr>

<h3>Read this to</h3>
<ul class="post-reasons">
  
  <li>learn why and how I moved to using Hakyll for my site</li>
  
</ul>

<h3>I expect you to know</h3>
<ul class="post-prereqs">
  
  <li>some Haskell doesn't hurt, but it isn't really necessary</li>
  
</ul>

<hr> <p>As you may know, I have a rather basic website with just a home page and some blog posts. I find writing blog posts in <a href="https://daringfireball.net/projects/markdown/">Markdown</a> really nice. I think it is an excellent format that lets me keep focus on the actual content rather than the markup. These two things, writing in Markdown to create a simple website, come together in <a href="https://jekyllrb.com/">Jekyll</a>, a static site generator written in Ruby. What’s more, GitHub Pages lets you push a Jekyll site source code and it will automatically transform it into the static HTML files. Pretty handy!</p>
<p>Setting up Jekyll for development is not fun, though. First off, you need Ruby (probably via <code>rvm</code>) and Rubygems installed, and then running <code>gem install jekyll</code> will likely end up failing multiple times because of missing native extensions. Because of <a href="http://www.nokogiri.org/tutorials/installing_nokogiri.html">these issues</a>, I wanted to try something different. Since I have tried learning Haskell a little, and have heard good things about <a href="https://jaspervdj.be/hakyll/">Hakyll</a>, that was what I reached for.</p>
<p>So far it’s been real nice, and rebuilding the site happens almost instantaneously!</p>
<h2 id="first-steps">First steps</h2>
<p>I started by simply following the thorough <a href="https://jaspervdj.be/hakyll/tutorials.html">tutorials</a>. After installing <a href="http://www.haskellstack.org/">Stack</a>, it was just this:</p>
<div class="sourceCode" id="cb1"><pre class="sourceCode bash"><code class="sourceCode bash"><span id="cb1-1"><a href="#cb1-1" aria-hidden="true" tabindex="-1"></a><span class="ex">$</span> stack install hakyll</span>
<span id="cb1-2"><a href="#cb1-2" aria-hidden="true" tabindex="-1"></a><span class="ex">$</span> hakyll-init my-site</span>
<span id="cb1-3"><a href="#cb1-3" aria-hidden="true" tabindex="-1"></a><span class="ex">$</span> cd my-site</span>
<span id="cb1-4"><a href="#cb1-4" aria-hidden="true" tabindex="-1"></a><span class="ex">$</span> stack build</span>
<span id="cb1-5"><a href="#cb1-5" aria-hidden="true" tabindex="-1"></a><span class="ex">$</span> stack exec site watch</span></code></pre></div>
<p>And I had a demo site up and running on a development server. Sweet. Next up, I copied over my old posts from the Jekyll site and checked they showed up. They did! Of course, the templates were still the demo ones, but that was next on my list.</p>
<h2 id="translating-the-templates">Translating the templates</h2>
<p>My Jekyll site was using Liquid templates, and Hakyll has its own little template syntax, so I had to transform them from one format to another. It really was quite simple though:</p>
<p>Jekyll:</p>
<div class="sourceCode" id="cb2"><pre class="sourceCode html"><code class="sourceCode html"><span id="cb2-1"><a href="#cb2-1" aria-hidden="true" tabindex="-1"></a><span class="dt">&lt;</span><span class="kw">title</span><span class="dt">&gt;</span>{% if page.title %}{{ page.title }} - {% endif %}Ossi Hanhinen<span class="dt">&lt;/</span><span class="kw">title</span><span class="dt">&gt;</span></span></code></pre></div>
<p>Hakyll:</p>
<div class="sourceCode" id="cb3"><pre class="sourceCode html"><code class="sourceCode html"><span id="cb3-1"><a href="#cb3-1" aria-hidden="true" tabindex="-1"></a><span class="dt">&lt;</span><span class="kw">title</span><span class="dt">&gt;</span>$if(title)$ $title$ - $endif$Ossi Hanhinen<span class="dt">&lt;/</span><span class="kw">title</span><span class="dt">&gt;</span></span></code></pre></div>
<p>Jekyll:</p>
<div class="sourceCode" id="cb4"><pre class="sourceCode html"><code class="sourceCode html"><span id="cb4-1"><a href="#cb4-1" aria-hidden="true" tabindex="-1"></a>{% for post in site.posts %}</span>
<span id="cb4-2"><a href="#cb4-2" aria-hidden="true" tabindex="-1"></a>  <span class="dt">&lt;</span><span class="kw">li</span><span class="dt">&gt;</span></span>
<span id="cb4-3"><a href="#cb4-3" aria-hidden="true" tabindex="-1"></a>    <span class="dt">&lt;</span><span class="kw">a</span><span class="ot"> href</span><span class="op">=</span><span class="st">&quot;{{ post.url }}&quot;</span><span class="dt">&gt;</span>{{ post.title }}<span class="dt">&lt;/</span><span class="kw">a</span><span class="dt">&gt;</span> {{ post.date | date: &quot;%b %-d, %Y&quot; }}</span>
<span id="cb4-4"><a href="#cb4-4" aria-hidden="true" tabindex="-1"></a>  <span class="dt">&lt;/</span><span class="kw">li</span><span class="dt">&gt;</span></span>
<span id="cb4-5"><a href="#cb4-5" aria-hidden="true" tabindex="-1"></a>{% endfor %}</span></code></pre></div>
<p>Hakyll:</p>
<div class="sourceCode" id="cb5"><pre class="sourceCode html"><code class="sourceCode html"><span id="cb5-1"><a href="#cb5-1" aria-hidden="true" tabindex="-1"></a>$for(posts)$</span>
<span id="cb5-2"><a href="#cb5-2" aria-hidden="true" tabindex="-1"></a>    <span class="dt">&lt;</span><span class="kw">li</span><span class="dt">&gt;</span></span>
<span id="cb5-3"><a href="#cb5-3" aria-hidden="true" tabindex="-1"></a>        <span class="dt">&lt;</span><span class="kw">a</span><span class="ot"> href</span><span class="op">=</span><span class="st">&quot;$url$&quot;</span><span class="dt">&gt;</span>$title$<span class="dt">&lt;/</span><span class="kw">a</span><span class="dt">&gt;</span> - $date$</span>
<span id="cb5-4"><a href="#cb5-4" aria-hidden="true" tabindex="-1"></a>    <span class="dt">&lt;/</span><span class="kw">li</span><span class="dt">&gt;</span></span>
<span id="cb5-5"><a href="#cb5-5" aria-hidden="true" tabindex="-1"></a>$endfor$</span></code></pre></div>
<p>If anything, the Hakyll syntax seems easier to read. More of the logic happens in Haskell code… which brings us to configuring the site. My GitHub Pages build worked in such a way that a post that was originally <code>_posts/2017-04-17-my-blog-post.md</code> ended up at the root level, without the date prefix. <code>ohanhi.com/my-blog-post.html</code>, for example. I wanted to keep this structure in order not to break anyone’s links. (I also kept the <code>ohanhi.github.io</code> site up, pointing to <code>ohanhi.com</code> just in case.) By default, Hakyll uses a structure where posts are under <code>/posts/</code>, with the date prefix left untouched.</p>
<p>So in my <code>site.hs</code> file, I edited the posts to have a custom routing:</p>
<div class="sourceCode" id="cb6"><pre class="sourceCode haskell"><code class="sourceCode haskell"><span id="cb6-1"><a href="#cb6-1" aria-hidden="true" tabindex="-1"></a><span class="co">-- in the `main` function</span></span>
<span id="cb6-2"><a href="#cb6-2" aria-hidden="true" tabindex="-1"></a>match <span class="st">&quot;posts/*&quot;</span> <span class="op">$</span> <span class="kw">do</span></span>
<span id="cb6-3"><a href="#cb6-3" aria-hidden="true" tabindex="-1"></a>    route   <span class="op">$</span> customRoute <span class="op">$</span> pathToPostName <span class="op">.</span> toFilePath</span>
<span id="cb6-4"><a href="#cb6-4" aria-hidden="true" tabindex="-1"></a>    compile <span class="op">$</span> pandocCompiler</span>
<span id="cb6-5"><a href="#cb6-5" aria-hidden="true" tabindex="-1"></a>        <span class="op">&gt;&gt;=</span> loadAndApplyTemplate <span class="st">&quot;templates/post.html&quot;</span>    postCtx</span>
<span id="cb6-6"><a href="#cb6-6" aria-hidden="true" tabindex="-1"></a>        <span class="op">&gt;&gt;=</span> relativizeUrls</span></code></pre></div>
<p>I am not very good at Haskell yet, so please don’t judge me, but I did this:</p>
<div class="sourceCode" id="cb7"><pre class="sourceCode haskell"><code class="sourceCode haskell"><span id="cb7-1"><a href="#cb7-1" aria-hidden="true" tabindex="-1"></a><span class="ot">pathToPostName ::</span> <span class="dt">String</span> <span class="ot">-&gt;</span> <span class="dt">String</span></span>
<span id="cb7-2"><a href="#cb7-2" aria-hidden="true" tabindex="-1"></a>pathToPostName path <span class="ot">=</span></span>
<span id="cb7-3"><a href="#cb7-3" aria-hidden="true" tabindex="-1"></a>    path</span>
<span id="cb7-4"><a href="#cb7-4" aria-hidden="true" tabindex="-1"></a>        <span class="op">|&gt;</span> splitAll <span class="st">&quot;/&quot;</span></span>
<span id="cb7-5"><a href="#cb7-5" aria-hidden="true" tabindex="-1"></a>        <span class="op">|&gt;</span> (\(p <span class="op">:</span> name <span class="op">:</span> _) <span class="ot">-&gt;</span> splitExtension name )</span>
<span id="cb7-6"><a href="#cb7-6" aria-hidden="true" tabindex="-1"></a>        <span class="op">|&gt;</span> (\(n, e) <span class="ot">-&gt;</span> <span class="fu">drop</span> <span class="dv">11</span> n <span class="op">++</span> <span class="st">&quot;.html&quot;</span>)</span>
<span id="cb7-7"><a href="#cb7-7" aria-hidden="true" tabindex="-1"></a></span>
<span id="cb7-8"><a href="#cb7-8" aria-hidden="true" tabindex="-1"></a></span>
<span id="cb7-9"><a href="#cb7-9" aria-hidden="true" tabindex="-1"></a>(<span class="op">|&gt;</span>) <span class="ot">=</span> <span class="fu">flip</span> (<span class="op">$</span>)</span></code></pre></div>
<p>It’s not the prettiest thing, but it works as long as I adhere to my filename scheme.</p>
<p>A trickier thing, however, was my custom lists that I like to add to the posts: <code>i_expect_you_to_know</code> and <code>read_this_to</code>. You might have seen those at the top of this post, too. In my source code they look like this:</p>
<div class="sourceCode" id="cb8"><pre class="sourceCode yaml"><code class="sourceCode yaml"><span id="cb8-1"><a href="#cb8-1" aria-hidden="true" tabindex="-1"></a><span class="pp">---</span></span>
<span id="cb8-2"><a href="#cb8-2" aria-hidden="true" tabindex="-1"></a><span class="fu">title</span><span class="kw">:</span><span class="at"> From Jekyll to Hakyll</span></span>
<span id="cb8-3"><a href="#cb8-3" aria-hidden="true" tabindex="-1"></a><span class="fu">read_this_to</span><span class="kw">:</span></span>
<span id="cb8-4"><a href="#cb8-4" aria-hidden="true" tabindex="-1"></a><span class="at">  </span><span class="kw">-</span><span class="at"> learn why and how I moved to using Hakyll for my site</span></span>
<span id="cb8-5"><a href="#cb8-5" aria-hidden="true" tabindex="-1"></a><span class="fu">i_expect_you_to_know</span><span class="kw">:</span></span>
<span id="cb8-6"><a href="#cb8-6" aria-hidden="true" tabindex="-1"></a><span class="at">  </span><span class="kw">-</span><span class="at"> some Haskell doesn't hurt, but it isn't really necessary</span></span>
<span id="cb8-7"><a href="#cb8-7" aria-hidden="true" tabindex="-1"></a><span class="pp">---</span></span></code></pre></div>
<p>In Hakyll, the template variables <code>$thing$</code> are bound within a <code>Context</code>. So what I needed to do is somehow bring the list contents into the post’s context. Luckily there was a <a href="https://jaspervdj.be/hakyll/reference/src/Hakyll-Web-Tags.html">solution for tags</a> (which I don’t use), so I could copy the idea from there. This is what I ended up with:</p>
<div class="sourceCode" id="cb9"><pre class="sourceCode haskell"><code class="sourceCode haskell"><span id="cb9-1"><a href="#cb9-1" aria-hidden="true" tabindex="-1"></a><span class="ot">postCtx ::</span> <span class="dt">Context</span> <span class="dt">String</span></span>
<span id="cb9-2"><a href="#cb9-2" aria-hidden="true" tabindex="-1"></a>postCtx <span class="ot">=</span></span>
<span id="cb9-3"><a href="#cb9-3" aria-hidden="true" tabindex="-1"></a>    dateField <span class="st">&quot;date&quot;</span> <span class="st">&quot;%B %-d, %Y&quot;</span></span>
<span id="cb9-4"><a href="#cb9-4" aria-hidden="true" tabindex="-1"></a>      <span class="ot">`mappend`</span> constField <span class="st">&quot;base_url&quot;</span> <span class="st">&quot;https://ohanhi.com&quot;</span></span>
<span id="cb9-5"><a href="#cb9-5" aria-hidden="true" tabindex="-1"></a>      <span class="ot">`mappend`</span> listContextWith <span class="st">&quot;i_expect_you_to_know&quot;</span></span>
<span id="cb9-6"><a href="#cb9-6" aria-hidden="true" tabindex="-1"></a>      <span class="ot">`mappend`</span> listContextWith <span class="st">&quot;read_this_to&quot;</span></span>
<span id="cb9-7"><a href="#cb9-7" aria-hidden="true" tabindex="-1"></a>      <span class="ot">`mappend`</span> defaultContext</span></code></pre></div>
<p>Works for me!</p>
<p>If you’re interested, you can check the whole implementation from the <a href="https://github.com/ohanhi/ohanhi.com/blob/master/site.hs"><code>site.hs</code> source code</a>.</p>
<p>With that, and a couple of easy <code>copyFileCompiler</code>s, I had everything set up to build the site just like it was before.</p>
<h2 id="deployment">Deployment</h2>
<p>Initially I thought I would keep using GitHub Pages for the hosting, but since it doesn’t support building Hakyll sites on its own, I figured it would actually make my life a little harder than it could be. Essentially I could either manually run the builds and commit the built site (and not the source code) to the <code>master</code> branch, or set up a CI service to run the build and do the commits, which frankly sounds pretty daunting. I decided to look for alternatives. Zeit’s <code>now</code> doesn’t offer custom domains at the free tier, but <a href="http://surge.sh/">surge</a> does.</p>
<p>Following their guide I was quickly able to get my custom domain set up and everything working. Now I can simply build the site locally and run:</p>
<div class="sourceCode" id="cb10"><pre class="sourceCode bash"><code class="sourceCode bash"><span id="cb10-1"><a href="#cb10-1" aria-hidden="true" tabindex="-1"></a><span class="ex">~/Hobby/ohanhi.com</span> <span class="er">(</span><span class="ex">master</span><span class="kw">)</span><span class="ex">›</span> surge _site</span>
<span id="cb10-2"><a href="#cb10-2" aria-hidden="true" tabindex="-1"></a></span>
<span id="cb10-3"><a href="#cb10-3" aria-hidden="true" tabindex="-1"></a>    <span class="ex">Surge</span> <span class="at">-</span> surge.sh</span>
<span id="cb10-4"><a href="#cb10-4" aria-hidden="true" tabindex="-1"></a></span>
<span id="cb10-5"><a href="#cb10-5" aria-hidden="true" tabindex="-1"></a>              <span class="ex">email:</span> <span class="pp">*********</span>@gmail.com</span>
<span id="cb10-6"><a href="#cb10-6" aria-hidden="true" tabindex="-1"></a>              <span class="ex">token:</span> <span class="pp">*****************</span></span>
<span id="cb10-7"><a href="#cb10-7" aria-hidden="true" tabindex="-1"></a>       <span class="ex">project</span> path: _site</span>
<span id="cb10-8"><a href="#cb10-8" aria-hidden="true" tabindex="-1"></a>               <span class="ex">size:</span> 34 files, 2.2 MB</span>
<span id="cb10-9"><a href="#cb10-9" aria-hidden="true" tabindex="-1"></a>             <span class="ex">domain:</span> ohanhi.com</span>
<span id="cb10-10"><a href="#cb10-10" aria-hidden="true" tabindex="-1"></a>             <span class="ex">upload:</span> <span class="pp">[</span><span class="ss">================</span><span class="pp">]</span> 100%, eta: 0.0s</span>
<span id="cb10-11"><a href="#cb10-11" aria-hidden="true" tabindex="-1"></a>   <span class="ex">propagate</span> on CDN: <span class="pp">[</span><span class="ss">====================</span><span class="pp">]</span> 100%</span>
<span id="cb10-12"><a href="#cb10-12" aria-hidden="true" tabindex="-1"></a>               <span class="ex">plan:</span> Free</span>
<span id="cb10-13"><a href="#cb10-13" aria-hidden="true" tabindex="-1"></a>              <span class="ex">users:</span> <span class="pp">*********</span>@gmail.com</span>
<span id="cb10-14"><a href="#cb10-14" aria-hidden="true" tabindex="-1"></a>         <span class="ex">IP</span> Address: 45.55.110.124</span>
<span id="cb10-15"><a href="#cb10-15" aria-hidden="true" tabindex="-1"></a></span>
<span id="cb10-16"><a href="#cb10-16" aria-hidden="true" tabindex="-1"></a>    <span class="ex">Success!</span> Project is published and running at ohanhi.com</span></code></pre></div>
<p>Super nice!</p>
<p><strong>PS.</strong> With this transition, I also added the Disqus comment section to all posts. Feel free to give me pointers on my Haskell on there. :)</p>


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
