class Extractor
  class Media
    def analyze(data, response)
      return if response.response == ""

      page = Nokogiri::HTML(response.response)

      data[:title] = page.at_css('title').content
      data[:description] = get_description(page)
      data[:images] = get_images(page)
      data[:videos] = get_videos(page)
    end

  private
    def get_description(page)
      description = page.css('meta').find { |m|
        m[:name] && m["name"].downcase == "description"
      }

      if description
        description = description.attributes["content"].value
      end
      description || ""
    end

    def get_videos(page)
      videos = page.css('object').map { |o| o.to_xml }

      iframes = page.css('iframe')
      if iframes.size > 0
        vimeo_frames_from(page).each do |frame|
          videos.push create_vimeo_embed_from frame
        end

        youtube_frames_from(page).each do |frame|
          videos << create_youtube_embed_from(frame)
        end
      end

      videos.map do |video|
        video.to_s.strip.html_safe
      end
    end

    def get_images(page)
      images = page.css('img')
      images.
        select { |i| i.attributes["width"] != nil && i.attributes["src"] != nil }.
        select { |i| i.attributes["width"].value.to_i > 100 && i.attributes["width"].value.to_i > 100 }.
        map { |i| image_url(page, i.attributes["src"].value.to_s) }
    end

    def vimeo_frames_from(page)
      page.css('iframe').
        select { |f| f.attributes["src"] != nil }.
        select { |f| f.attributes["src"].value =~ /http:\/\/player.vimeo.com\/video\/([\d]+)/ }
    end

    def youtube_frames_from(page)
      page.css('iframe').
        select { |f| f.attributes["src"] != nil }.
        select { |f| f.attributes["src"].value =~ /http:\/\/www.youtube.com\/embed\/.*/ }
    end

    def create_youtube_embed_from(frame)
      width = frame.attributes["width"]
      height = frame.attributes["height"]
      src = frame.attributes["src"].value

      <<-EMBED
        <iframe width="#{width}" height="#{height}" src="#{src}" frameborder="0" allowfullscreen></iframe>
      EMBED
    end

    def image_url(page, url)
      if Addressable::URI.parse(url).relative?
        Addressable::URI.join(page.uri.to_s, url).to_s
      else
        url
      end
    end

    def create_vimeo_embed_from(frame)
      width = frame.attributes["width"].value
      height = frame.attributes["height"].value

      src = frame.attributes["src"].value
      <<-EMBED
        <iframe src="#{src}" width="#{weight}" height="#{height}" frameborder="0" webkitAllowFullScreen mozallowfullscreen allowFullScreen></iframe>
      EMBED
    end
  end
end
