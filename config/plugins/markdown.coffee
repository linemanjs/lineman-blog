module.exports = (lineman) ->
  app = lineman.config.application

  files:
    pages:
      source: ["app/pages/**/*.*", "!app/pages/**/*.md"]

    markdown:
      posts: "app/posts/*.md"
      pages: "app/pages/**/*.md"
      templates: "app/templates/**/*.us"

  config:

    loadNpmTasks: app.loadNpmTasks.concat("grunt-markdown-blog")

    prependTasks:
      common: app.prependTasks.common.concat("markdown:dev")
      dist: app.prependTasks.dist.concat("markdown:dist")

    markdown:
      options:
        author: "FirstName LastName"
        title: "<%= pkg.title %>"
        description: "<%= pkg.description %>"
        url: "<%= pkg.homepage %>"
        rssCount: 10 #<-- remove, comment, or set to zero to disable RSS generation
        #disqus: "my_disqus_name" #<-- uncomment and set your disqus account name to enable disqus support
        layouts:
          wrapper: "app/templates/wrapper.us"
          index: "app/templates/index.us"
          post: "app/templates/post.us"
          page: "app/templates/page.us"
          archive: "app/templates/archive.us"
        paths:
          posts: "<%= files.markdown.posts %>"
          pages: "<%= files.markdown.pages %>"
          index: "index.html"
          archive: "archive.html"
          rss: "index.xml"
        pathRoots:
          posts: "posts"
          pages: ""

      dev:
        dest: "generated"
        context:
          js: "/js/app.js"
          css: "/css/app.css"

      dist:
        dest: "dist"
        context:
          js: "/js/app.js"
          css: "/css/app.css"

    watch:
      markdown:
        files: ["<%= files.markdown.posts %>", "<%= files.markdown.pages %>", "<%= files.markdown.templates %>"]
        tasks: ["markdown:dev"]
