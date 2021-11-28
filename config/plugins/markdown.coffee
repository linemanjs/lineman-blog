module.exports = (lineman) ->
  app = lineman.config.application

  files:
    pages:
      source: ["app/pages/**/*.*", "!app/pages/**/*.md"]

    markdown:
      posts: "app/posts/*.md"
      pages: "app/pages/**/*.md"
      templates: "app/templates/**/*.pug"

  config:

    loadNpmTasks: app.loadNpmTasks.concat("grunt-markdown-blog")

    prependTasks:
      common: app.prependTasks.common.concat("markdown:dev")
      dist: app.prependTasks.dist.concat("markdown:dist")

    markdown:
      options:
        author: "<%= pkg.author.name %>"
        authorUrl: "<%= pkg.homepage %>"
        title: "my lineman blog"
        description: "<%= pkg.description %>"
        url: "<%= pkg.homepage %>"
        feedCount: 10 #<-- set to zero to disable RSS and JSONFeed generation
        #disqus: "my_disqus_name" #<-- uncomment and set your disqus account name to enable disqus support
        layouts:
          wrapper: "app/templates/wrapper.pug"
          index: "app/templates/index.pug"
          post: "app/templates/post.pug"
          page: "app/templates/page.pug"
          archive: "app/templates/archive.pug"
        paths:
          posts: "<%= files.markdown.posts %>"
          pages: "<%= files.markdown.pages %>"
          index: "index.html"
          archive: "archive.html"
          rss: "index.xml"
          json: "index.json"
        pathRoots:
          posts: "posts"
          pages: "" # we want pages to show up in the root of the site

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
