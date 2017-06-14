+++
date = "2017-06-11T22:53:05+02:00"
description = "Deploy your blog to Github Pages"
title = "Deploy your blog to Github pages"

+++

I have successfully deployed my blog to Github Pages. The journey was a little bit rough, mostly because of outdated and misunderstood concepts. I use [Hugo](https://gohugo.io/) as my static site generator because its easy to use and in my opinion a little more lightweight than Jekyll.

## Github Pages Rules

Github has some rules you must follow to make this work. In order to create your personal site on Github, you have to create a repository first which matches `<username>.github.io`. The website will later be available under this URL. There are some rules you have to follow in order to see the site:

*   The repository must contain a `master` branch. This is the default when creating new Git repositories. Content is served from here
*   The master branch must contain an `index.html` file which will serve as the start page

If your repository is a project page, there are other ways, e.g. by using a dedicated `gh-pages` branch. Project pages do not follow the above naming rule. You can read more in their [documentation](https://pages.github.com/).

## Setup

Back to Github Pages and hosting your blog. We will setup the repository now. First, create the Git repository on Github (remember to exactly match the above pattern) and clone it. I will call it `content`. By having two branches, we can separate the processed HTML, CSS and whatever from the really interesting files, e.g. scripts, Markdown documents and so on.

In your command line, type

        git clone <repo-url> my-blog
        cd my-blog
        git checkout -b content

Now we are on `content` branch. It will act as the main branch, the default `master` branch will hold only the generated files. Create some file like `README.md` and commit it. Then push with `git push origin content` to fill the branch with a file. Now we can add our HTML. Switch to `master` for this.

To get a basic example working, create create `index.html` and fill it with some content, e.g.

    <!doctype html>
    <html lang="en">
        <body>
            <h1>This is my blog!</h1>
            <h3>Posts</h3>
            <ul>
                <!-- Links to posts go here -->
            </ul>
        </body>
    </html>

Commit and we are with with the setup. We now have

*   Two branches, `content` and `master`
*   `README.md` on `content`
*   `index.html` on `master`

Visit `http://<username>.github.io` and enjoy your blog. Next step is automation!

## Automating the deployment

Let’s assume that you want to avoid writing raw HTML for your blog posts and have some fancy CSS files for prettifying your website. And finally you want to build your `index.html` dynamically so that it will include links to all posts instead of adding a `<li><a href="..">My new post</a></li>` to the `<ul>` in `index.html` every time. We can automate this repetitive task by building a small pipeline which will do the following:

*   Convert Markdown to HTML
*   Generate the `index.html` file from some template
*   Add all generated content to `master`
*   Push to GitHub

How you generate your website is really up to you. If you use some fully-blown tool like Hugo or Jekyll, invoke them and continue. There are some lightweight alternatives at the end of this post. When doing it with a custom pipeline, make sure to place the result in some folder, e.g. `public`.

## Publishing

It is important that your output folder is not contained in your `.gitignore` for this approach to work. If so, remove it and make sure to not accidentially comitting it in the future. After generating `public`, use `git chckout master` to switch the branch. `public` should now be available. Move everything in there to the root directory with `mv public/* ./` and remove the folder with `rm -rf public`. Now, everything should be in place to publish. The next steps are `git add`, `git commit -m "Update website"` and `git push origin master`. Finally switch back to `content` branch. This can be summarised in the following script

**UPDATE** Seems my original script was not working. Here is the update:

    #!/bin/sh

    echo "Deploying"

    hugo
    git checkout master
    # Delete all hugo generated files
    rm -rf about blog categories code colophon content css fixed img tags
    rm 404.html index.html sitemap.xml index.xml
    # End deletion
    mv public/* ./
    rm -rf public
    git add .
    git commit -m 'Update website'
    git push origin master
    git checkout content

Now, all new content is pushed to `master` without having the original files. There you are, having an automated process to keep your blog up to date. Of course, there are several possibilities to go further but this is the baseline.

Updating the website is easy: simply invoke `./deploy.sh`. Finally, some words about static site generators.

## About static site generators

You do not have to use Hugo of course. You can manually create the `index.html` or generate it via some of the many static site generators. [This](https://www.staticgen.com/) website gives you an overview about the most popular ones. Alternatively, you can roll your own by converting some markdown format to HTML or use something like Pandoc which converts your files written in LaTeX or Markdown into HTML but does not enforce a directory structure like Jekyll, Hugo etc. [Here](http://linguisticmystic.com/2015/03/02/how-to-make-a-website-using-pandoc/) is a link on how to build a website with Pandoc.

