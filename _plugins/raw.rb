module RawGenerator
  class Generator < Jekyll::Generator
    priority :lowest
    def generate(site)
      existing_posts = site.posts.docs.to_a
      for i in 0..(existing_posts.size - 1) do
        post = existing_posts[i]
        new_page = RawPage.new(site, post)
        site.pages << new_page
      end
    end
  end
  class RawPage < Jekyll::Page
    def initialize(site, post)
      @site = site             # the current site instance.
      @base = site.source      # path to the source directory.
      @dir  = "raw"         # the directory the page will reside in.
      @name     = post.name # basically @basename + @ext.

      @content = post.content
      @data = post.data.clone

      @relative_path = post.relative_path.sub("_posts", "raw")
      data["permalink"] = 'raw/%{permalink}' % {permalink: post.permalink}

      @ext = '.md'
      data["layout"] = 'raw'
    end
  end
end
