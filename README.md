# lineman-blog

This is a plugin to get started writing a blog with
[Lineman](http://linemanjs.com) managing the build and bringing with it both excellent markdown parsing as well as static asset (JS/CSS) management. We recommend you look at our
[Blog template project](https://github.com/testdouble/lineman-blog-template/)
as a starting point.

If you'd like to add this to a fresh Lineman project on your own, just:

```
$ npm install --save-dev lineman-blog
```

And then start adding Underscore templates to `app/templates/**/*.us`, posts to `app/posts/*.md`, and static pages to `app/pages/**/*.md`. Refer to the [Lineman docs](http://linemanjs.com) for details about how to use Lineman generally.

To review what the default configuration and paths are specific to this plugin, run:

```
$ lineman config markdown
```
