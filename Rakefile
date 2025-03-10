# frozen_string_literal: true

require 'English'
require 'rubygems'
require 'bundler'
Bundler.require

require 'time'

task :command_exists, [:command] do |_, args|
  abort "#{args.command} doesn't exists" if `command -v #{args.command} > /dev/null 2>&1 && echo $?`.chomp.empty?
end

task :is_repo_clean do
  next if ENV['BYPASS_REPO_CLEAN']

  abort 'please commit your changes first!' unless `git status -s | wc -l`.strip.to_i.zero?
end

task :has_bump_my_version do
  Rake::Task['command_exists'].invoke('bump-my-version')
end

task :default => [:run_server]

desc "run server"
task :run_server do
  system "bin/middleman serve"
end

desc "build pages"
task :build do
  system "bin/middleman build --verbose"
end

desc "deploy to gh-pages with bump"
task :deploy, [:bump] do |_, args|
  args.with_defaults(bump: 'patch')

  now = Time.now.strftime("%Y-%m-%d-%H-%M")
  system %{
    cd build/ &&
    git pull &&
    cd ../ &&
    bump-my-version bump #{args.bump} &&
    git push &&
    middleman build &&
    cd build/ &&
    git add . &&
    git commit -m "release #{now}" &&
    git push &&
    cd ../
  }
  puts "Deployed..."
end

VALID_LANGUAGES = ["tr", "en"]
BLOG_TIME_FORMAT = "%b %d, %Y %H:%M"
BLOG_FRONTMATTER_DATE_FORMAT = "%Y-%m-%d %H:%M"
BLOG_FILE_DATE_FORMAT = "%Y-%m-%d"

namespace :new do

  desc "new page"
  task :page, [:title, :language] do |_, args|
    args.with_defaults(language: "tr")

    abort "please enter page title!..." unless args.title
    abort "please set valid language: #{VALID_LANGUAGES.join(",")}. #{args.language} is not a valid" unless VALID_LANGUAGES.include?(args.language)
    
    blog_name = {en: "english", tr: "turkish"}
    page_val = {en: "page", tr: "sayfa"}
    
    output = []
    output << '---'
    output << "title: #{args.title}"
    output << "locale: #{args.language}"
    output << '# subtitle: ""'
    output << "# blog: #{blog_name[args.language.to_sym]}"
    output << "layout: #{args.language}/layout-common"
    output << "# layout: #{args.language}/layout-common-markdown"
    output << '# cover: ""'
    output << '# cover_title: ""'
    output << '# cover_subtitle: ""'
    output << '# og_image: ""'
    output << '# og_image_dir: ""'
    output << 'comments: false'
    output << '---'

    save_file = "source/pages/#{args.language}/#{args.title.to_url}.html.md.erb"

    # File.open(save_file, "w") do |f|
    #   f.write output.join("\n")
    # end
    puts "New page is ready at: #{save_file}"
    
    puts "now add this proxy to your config.rb:"
    puts "proxy_page \"/#{page_val[args.language.to_sym]}/#{args.language}/#{args.title.to_url}/index.html\", \"/pages/#{args.language}/#{args.title.to_url}.html.md.erb\", locals: {locale: \"#{args.language}\"}, ignore: true"
    
  end

  desc "new blog post"
  task :post, [:title, :language, :publish_date] do |_, args|
    now = Time.now

    publish_date = Time.parse(args.publish_date || now.strftime(BLOG_TIME_FORMAT))
    file_date = publish_date.strftime(BLOG_FILE_DATE_FORMAT)
    file_year = publish_date.strftime('%Y')

    args.with_defaults(language: "tr", publish_date: publish_date)
    abort "please enter post title!..." unless args.title
    abort "please set valid language: #{VALID_LANGUAGES.join(",")}. #{args.language} is not a valid" unless VALID_LANGUAGES.include?(args.language)

    frontmatter_date = publish_date.strftime(BLOG_FRONTMATTER_DATE_FORMAT)

    output = <<-END
---
title: "#{args.title}"
locale: #{args.language}
# subtitle: ""
date: #{frontmatter_date}
# cover: ""
# cover_title: ""
# cover_subtitle: ""
# og_image: ""
# og_image_dir: ""
# tags: tag1,tag2
comments: false
---
END

    save_file = "source/blog/#{args.language}/#{file_year}/#{file_date}-#{args.title.to_url}.html.md.erb"
    
    File.open(save_file, "w") do |f|
      f.write output
    end

    puts "new post is ready at: #{save_file}"
  end
  
end

desc "print now"
task :now do
  system "date +'%Y-%M-%d %H:%M'"
end