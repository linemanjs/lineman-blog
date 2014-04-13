fs        = require("fs")
path      = require("path")
findsRoot = require("find-root-package")
_         = require("underscore")

module.exports =
  initialize: (dir = process.cwd()) ->
    topDir = findsRoot.findTopPackageJson(dir)
    return unless isInstalledAsDependency(dir, topDir)
    createBlogTemplatesRelativeTo(topDir)

isInstalledAsDependency = (dir, topDir) ->
  topDir? && topDir != dir

createBlogTemplatesRelativeTo = (dir) ->
  mainTemplatesPath = path.join(dir, "app/templates")
  templateFilenames = "index archive page post wrapper".split(" ")
  extension         = ".us"
  templateFilepaths = _(templateFilenames).map (filename) -> "#{mainTemplatesPath}/#{filename}#{extension}"

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

  fs.writeFileSync "#{mainTemplatesPath}/index.us",   indexTemplate
  fs.writeFileSync "#{mainTemplatesPath}/archive.us", archiveTemplate
  fs.writeFileSync "#{mainTemplatesPath}/page.us",    pageTemplate
  fs.writeFileSync "#{mainTemplatesPath}/post.us",    postTemplate
  fs.writeFileSync "#{mainTemplatesPath}/wrapper.us", wrapperTemplate

  console.log """
    Thanks for installing lineman-blog!

    We've added some basic blog templates to help you get started, here:

    #{templateFilepaths.join('\n')}
    """
