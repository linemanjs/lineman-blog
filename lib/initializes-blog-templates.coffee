fs        = require("fs")
path      = require("path")
findsRoot = require("find-root-package")
_         = require("underscore")

module.exports =
  initialize: (dir = process.cwd()) ->
    topDir = findsRoot.findTopPackageJson(dir)
    return unless isInstalledAsDependency(dir, topDir)
    console.log """

      Thanks for installing lineman-blog!

      """
    createSamplePagesRelativeTo(topDir)
    createBlogTemplatesRelativeTo(topDir)
    createSamplePostsRelativeTo(topDir)

isInstalledAsDependency = (dir, topDir) ->
  topDir? && topDir != dir

createSamplePagesRelativeTo = (dir) ->
  jsPath    = path.join(dir, "app/js")
  pagesPath = path.join(dir, "app/pages")

  if fs.existsSync "#{jsPath}/hello.coffee"
    fs.unlinkSync "#{jsPath}/hello.coffee"

  if fs.existsSync "#{pagesPath}/index.us"
    fs.unlinkSync "#{pagesPath}/index.us"

  sampleMarkdownPage = """
    ---
    title: "About us"
    ---
    # Markdown page

    I'm just an about page formatted in _markdown_!
    """

  sampleHtmlPage = """
    <!DOCTYPE html>
    <html>
      <body>
        I'm just plain HTML.
      </body>
    </html>
    """

  fs.writeFileSync "#{pagesPath}/about.md", sampleMarkdownPage
  fs.writeFileSync "#{pagesPath}/plain.html", sampleHtmlPage

  console.log """

    We've added some sample pages here:

    #{pagesPath}

    """

createBlogTemplatesRelativeTo = (dir) ->
  templatesPath = path.join(dir, "app/templates")
  templateFilenames = "index archive page post wrapper".split(" ")
  extension         = ".us"
  templateFilepaths = _(templateFilenames).map (filename) -> "#{templatesPath}/#{filename}#{extension}"

  indexTemplate = """
    <%= site.htmlFor(_(site.posts).last()) %>
    """

  archiveTemplate = """
    <h1>archives</h1>
    <ul>
    <% _(site.posts).chain().reverse().each(function(post){ %>
      <li>
        <a href="/<%= post.htmlPath() %>"><%= post.title() %></a>
      </li>
    <% }) %>
    </ul>
    """

  pageTemplate = """
    <article class="page">
      <div class="title">
        <h1><%= post.title() %></h1>
      </div>
      <section>
        <%= post.content() %>
      </section>
    </article>
    """

  postTemplate = """
    <article class="post">
      <div class="title">
        <h1><a href="/<%= post.htmlPath() %>"><%= post.title() %></a></h1>
        <p>
          <%= post.date() %>
          <% if(post.get('author')) { %>
            by <%= post.get('author').name %>
          <% } %>
        </p>
      </div>
      <section>
        <%= post.content() %>
      </section>
      <section class="navigation">
          <% if(site.newerPost(post)) { %>
            <span class="newer"><a href="/<%= site.newerPost(post).htmlPath() %>">&#8672;&nbsp;newer</a></span>
          <% } %>
          <% if(site.olderPost(post)) { %>
            <span class="older"><a href="/<%= site.olderPost(post).htmlPath() %>">older&nbsp;&#8674;</a></span>
          <% } %>
        </section>
      <section class="comments">
        <% if(site.disqus) { %>
          <div id="disqus_thread"></div>
          <script type="text/javascript">
            window.disqus_identifier="";
            window.disqus_url="<%= site.url+"/"+post.htmlPath() %>";
            window.disqus_title="<%= post.title() %>";
          </script>
            <script type="text/javascript" src="http://disqus.com/forums/<%= site.disqus %>/embed.js"></script>
            <noscript><a href="http://<%= site.disqus %>.disqus.com/?url=ref">View the discussion thread.</a></noscript>
        <% } %>
      </section>
    </article>
    """

  wrapperTemplate = """
    <!DOCTYPE html>
    <html>
      <head>
        <link rel="stylesheet" type="text/css" href="<%= css %>" media="all" />
        <link rel="alternate" type="application/rss+xml" title="<%= site.title %> - feed" href="/index.xml" />
        <title><%= site.title %><%= post ? ' - '+post.title() : '' %></title>
      </head>
      <body>
        <header>
          <h1><%= site.title %></h1>
          <nav>
            <a href="/">home</a> | <a href="/archive.html">archives</a> | <a href="/about.html">about</a>
          </nav>
        </header>

        <%= yield %>

        <footer>
          Copyright <%= site.author %>, <%= new Date().getFullYear() %>.
        </footer>
        <script type="text/javascript" src="<%= js %>"></script>
      </body>
    </html>
    """

  fs.writeFileSync "#{templatesPath}/index.us",   indexTemplate
  fs.writeFileSync "#{templatesPath}/archive.us", archiveTemplate
  fs.writeFileSync "#{templatesPath}/page.us",    pageTemplate
  fs.writeFileSync "#{templatesPath}/post.us",    postTemplate
  fs.writeFileSync "#{templatesPath}/wrapper.us", wrapperTemplate

  console.log """

    We've added some basic blog templates to help you get started, here:

    #{templateFilepaths.join('\n')}

    """

createSamplePostsRelativeTo = (dir) ->
  postsPath = path.join(dir, "app/posts")
  unless fs.existsSync(postsPath)
    fs.mkdirSync(postsPath)

  samplePostOne = """
    ---
    title: "A very nice title. With punctuation!"
    author:
      name: "Double Agent Man"
    ---
    I'm just an example post

    > and I'm a quote of some markdown.

    Yay.
    """

  samplePostTwo = """
    I'm another example post

    ``` coffeescript
    andIAmSome = "CoffeeScript"
    ```

    Sweet.
    """

  samplePostThree = """
    I'm a third example post.

    I have **bold** text.
    """

  fs.writeFileSync "#{postsPath}/2013-03-17-example-post-1.md", samplePostOne
  fs.writeFileSync "#{postsPath}/2013-03-16-example-post-2.md", samplePostTwo
  fs.writeFileSync "#{postsPath}/2013-03-15-example-post-3.md", samplePostThree

  console.log """

    We've also added some example posts here:

    #{postsPath}

    """

  createSamplePagesRelativeTo = (dir) ->
    pagesPath = path.join(dir, "app/pages")
