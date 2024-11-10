module CustomHelpers
  def update_badge(text, **options)
    options[:class] ||= 'is-info'
    options[:align] ||= 'middle'

    '<span style="vertical-align: ' + options[:align] + ';" class="tag ' + options[:class] + '">' + text + '</span>'
  end
  
  def inspect_obj(obj)
    '<pre class="debug">' + escape_html(obj) + '</pre>' if development?
  end

  def gist(id)
    "<script src=\"https://gist.github.com/#{id}.js\"></script>"
  end

  def custom_strip_tags(text, **options)
    elements = options[:elements] || ['a', 'code', 'strong']
    attributes = options[:attributes] || {}

    Sanitize.fragment(text, elements: elements, attributes: attributes).chomp
  end
  
  def get_reading_time(html_input, format=:full)
    f = Nokogiri::HTML.fragment(html_input)
    f.css('div.highlight').remove
    f.to_str.reading_time format: format
  end

  def markdown(input)
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML.new, config[:markdown])
    markdown.render(input)
  end

  def gravatar_for(email)
    hash = Digest::MD5.hexdigest(email.chomp.downcase)
    "https://www.gravatar.com/avatar/#{hash}"
  end

  def markdownify_text_only(text, **options)
    allowed_tags = options[:allowed_tags] || ['em', 'strong', 'a', 'code', 'kbd']
    attributes = options[:attributes] || {'a' => ['href']}
    Sanitize.fragment(markdown(text), elements: allowed_tags, attributes: attributes)
  end

  def site_image(img, dir="covers")
    if img.include?('http')
      "#{img}"
    # elsif img.include?('/')
    #   "/#{config[:images_dir]}/#{img}"
    else
      "/#{config[:images_dir]}/#{dir}/#{img}"
    end
  end

  def zoomable(**options)
    out = []

    options[:dir] ||= "posts"
    options[:cap] ||= nil
    options[:alt] ||= options[:cap] || I18n.t('photo_or_screenshot')
    options[:shadow] || false
    options[:animate] || false

    img_classes = []
    img_classes << "shadow" if options[:shadow]
    img_classes << "animate" if options[:animate]
    
    img_class = img_classes.size > 0 ? ' class="' + img_classes.join(" ") +'" ': ""
    img_data = options[:animate] ? ' data-play="' + site_image(options[:animate], options[:dir]) +'" ' : ""

    out << '<div class="full zoomable">'
    out << '<figure class="image">'
    out << '<span class="player-status">▶</span>' if options[:animate]
    out << '<img' + img_class + img_data + ' title="' + options[:alt] + '" src="' + site_image(options[:src], options[:dir]) +'" alt="' + options[:alt] +'">'
    out << '</figure>'
    out << '<p>%s</p>' % markdownify_text_only(options[:cap]) if options[:cap]
    out << '</div>'
    out.join
  end

  def card(**options)
    options[:dir] ||= "posts"
    options[:cap] ||= nil
    options[:alt] ||= options[:cap] || I18n.t('photo_or_screenshot')
    
    out = ['<div class="card blog-card mt-2 mb-4">']
    out << '<div class="card-image has-text-centered">'
    out << '<img class="mt-4" title="' + options[:alt] +'" src="' + site_image(options[:src], options[:dir]) + '" alt="' + options[:alt] +'" />'
    out << '</div>'
    unless options[:cap].nil?
      out << '<div class="card-content">'
      out << '<div class="content has-text-centered is-size-5-desktop is-size-6-mobile has-text-weight-semibold">'
      out << '<p>' + markdownify_text_only(options[:cap]) + '</p>'
      out << '</div>'
      out << '</div>'
    end
    out << '</div>'
    out.join
  end

  def clipart(**options)
    options[:dir] ||= "posts"
    options[:alt] ||= I18n.t('photo_or_screenshot')
    '<img class="clipart" src="' + site_image(options[:src], options[:dir]) + '" alt="' + options[:alt] + '"/>'
  end

  def img_gallery(**options)
    options[:align] ||= "4"
    options[:psize] ||= "is-size-6-widescreen"
    options[:dir] ||= "posts"

    out = ['<div class="photo-gallery full zoomable">']
    out << '<div class="columns is-multiline is-variable">'
    options[:images].each do |image|
      image_cap = image[:cap] || nil
      image_alt = image_cap || I18n.t('photo_or_screenshot')
      out << '<div class="column is-6-desktop is-6-tablet is-'+ options[:align] +'-widescreen">'
      out << '<figure class="image is-fullwidth">'
      out << '<img title="' + image_alt + '" src="' + site_image(image[:thumb], options[:dir]) + '" alt="' + image_alt + '"/>'
      out << '<p class="' + options[:psize] + '">' + markdownify_text_only(image_cap) + '</p>' if image_cap
      out << '</figure>'
      out << '</div>'
    end
    out << '</div>'
    out << '</div>'
    out.join("\n")
  end

  def video(**options)
    out = []

    options[:title] ||= "Video"
    options[:cap] ||= nil
    options[:ratio] ||= "is-16by9"

    out << '<div class="video-player">'
    out << '<figure class="image ' + options[:ratio] + '">'
    out << '<iframe title="' + options[:title] + '" class="has-ratio" width="100%" src="' + options[:src] + '" frameborder="0" allowfullscreen></iframe>'
    out << '</figure>'
    out << '<p>' + options[:cap] +'</p>' unless options[:cap].nil?
    out << '</div>'
    out.join
  end
  
  def video_vimeo(id, **options)
    vimeo_src = "https://player.vimeo.com/video/#{id}?color=ffffff&amp;title=0&amp;byline=0&amp;portrait=0"
    video src: vimeo_src, title: options[:title] || nil, cap: options[:cap] || nil
  end

  def video_youtube(id, **options)
    yt_src = "https://www.youtube.com/embed/#{id}"
    video src: yt_src, title: options[:title] || nil, cap: options[:cap] || nil
  end
end
