require 'rubygems'
require 'bundler'
Bundler.require
require 'time'

task :default => [:run_server]

desc "run server"
task :run_server do
  system "bin/middleman serve"
end

desc "build pages"
task :build do
  system "bin/middleman build --verbose"
end

desc "deploy to gh-pages"
task :deploy, [:bump] do |_, args|
  args.with_defaults(bump: 'patch')

  now = Time.now.strftime("%Y-%m-%d-%H-%M")
  system %{
    cd build/ &&
    git pull &&
    cd ../ &&
    bumpversion #{args.bump} &&
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

namespace :new do

  desc "new page"
  task :page, [:title, :language] do |_, args|
    args.with_defaults(language: 'tr')

    abort "Please enter page title!..." unless args.title
    
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

    File.open(save_file, "w") do |f|
      f.write output.join("\n")
    end
    puts "New page is ready at: #{save_file}"
    
    puts "now add this proxy to your config.rb:"
    puts "proxy_page \"/#{page_val[args.language.to_sym]}/#{args.language}/#{args.title.to_url}/index.html\", \"/pages/#{args.language}/#{args.title.to_url}.html.md.erb\", locals: {locale: \"#{args.language}\"}, ignore: true"
    
  end

  desc "new blog post"
  task :post, [:title, :language, :publish_date] do |_, args|
    now = Time.now
    publish_date = Time.parse(args[:publish_date] || now.strftime('%b %d, %Y %H:%M'))
    file_date = now.strftime('%Y-%m-%d')

    args.with_defaults(language: 'tr', publish_date: publish_date)

    abort "Please enter post title!..." unless args.title

    output = []
    output << '---'
    output << "title: #{args.title}"
    output << "locale: #{args.language}"
    output << '# subtitle: ""'
    output << "date: #{args.publish_date}"
    output << '# cover: ""'
    output << '# cover_title: ""'
    output << '# cover_subtitle: ""'
    output << '# og_image: ""'
    output << '# og_image_dir: ""'
    output << '# tags: tag1,tag2'
    output << 'comments: false'
    output << '---'
    save_file = "source/blog/#{args.language}/#{file_date}-#{args.title.to_url}.html.md.erb"

    File.open(save_file, "w") do |f|
      f.write output.join("\n")
    end
    puts "New post is ready at: #{save_file}"
  end
  
end

