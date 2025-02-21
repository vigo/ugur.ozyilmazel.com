require 'uglifier'
require 'time'
require 'active_support/all'

activate :i18n
Time.zone = 'Europe/Istanbul'
helpers ActiveSupport::NumberHelper
helpers ActiveSupport::Inflector

activate :syntax
set :markdown_engine, :redcarpet
set :markdown, fenced_code_blocks: true,
               smartypants: true,
               tables: true,
               autolink: true,
               strikethrough: true,
               superscript: true,
               highlight: true,
               footnotes: true,
               quote: true,
               underline: true


config[:js_dir]     = 'public/js'
config[:css_dir]    = 'public/css'
config[:images_dir] = 'public/images'

config[:site_url]         = 'https://ugur.ozyilmazel.com'
config[:meta_author_name] = 'Uğur “vigo” Özyılmazel'

set :meta_description, {
  tr: "Kişisel blogum.",
  en: "My personal blog.",
}


activate :autoprefixer do |prefix|
  prefix.browsers = "last 2 versions"
end

set :date_format_long, {
  tr: "%d %B %Y, %A %H:%M",
  en: "%A, %B %-d, %Y, %-I:%M %p",
}
set :date_format_short, {
  tr: "%d %B %Y, %A",
  en: "%A, %B %-d, %Y",
}

page '/*.xml',  layout: false
page '/*.json', layout: false
page '/*.txt',  layout: false

# With alternative layout
# page '/path/to/file.html', layout: 'other_layout'

# Helpers
# Methods defined in the helpers block are available in templates
# https://middlemanapp.com/basics/helper-methods/

# helpers do
#   def some_helper
#     'Helping'
#   end
# end

# Proxy pages
# https://middlemanapp.com/advanced/dynamic-pages/

# proxy(
#   '/this-page-has-no-template.html',
#   '/template-file.html',
#   locals: {
#     which_fake_page: 'Rendering a fake page with a local variable'
#   },
# )

proxy "/blog/tr/index.html", "/pages/tr/blog-index.html", locals: {locale: "tr"}, ignore: true
proxy '/blog/en/index.html', '/pages/en/blog-index.html', locals: {locale: "en"}, ignore: true

proxy "/sayfa/tr/sunumlar/index.html", "/pages/tr/sunumlar.html", locals: {locale: "tr"}, ignore: true

proxy "/en/index.html", "/pages/en/index.html", locals: {locale: "en"}, ignore: true

proxy "/page/en/about/index.html", "/pages/en/about.html", locals: {locale: "en"}, ignore: true

activate :blog do |blog|
  blog.name              = "turkish"
  blog.prefix            = "blog/tr/"
  blog.permalink         = "{year}/{month}/{day}/{title}/index.html"
  blog.sources           = "{year}/{year}-{month}-{day}-{title}.html"
  blog.taglink           = "etiket/{tag}/index.html"
  blog.year_link         = "yil/{year}/index.html"
  blog.paginate          = true
  blog.per_page          = 10
  blog.page_link         = "sayfa/{num}"
  blog.summary_separator = /READ_MORE/
  blog.summary_length    = nil
  blog.layout            = "tr/layout-blog-detail"
  blog.tag_template      = "templates/tr/blog-tag.html"
  blog.calendar_template = "templates/tr/blog-calendar.html"
end
activate :blog do |blog|
  blog.name              = "english"
  blog.prefix            = "blog/en/"
  blog.permalink         = "{year}/{month}/{day}/{title}/index.html"
  blog.sources           = "{year}/{year}-{month}-{day}-{title}.html"
  blog.taglink           = "tag/{tag}/index.html"
  blog.year_link         = "year/{year}/index.html"
  blog.paginate          = true
  blog.per_page          = 10
  blog.page_link         = "page/{num}"
  blog.summary_separator = /READ_MORE/
  blog.summary_length    = nil
  blog.layout            = "en/layout-blog-detail"
  blog.tag_template      = "templates/en/blog-tag.html"
  blog.calendar_template = "templates/en/blog-calendar.html"
end
activate :directory_indexes


page "/blog/tr/feed.xml", layout: false
page "/blog/en/feed.xml", layout: false

configure :build do
  activate :minify_css
  activate :minify_javascript, compressor: -> { Uglifier.new(:mangle => false, :harmony => true) }
end

configure :development do
  activate :livereload, host: '127.0.0.1'
end
