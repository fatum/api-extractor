class Extractor
  class Readability

    def analyze(data, response)
      readability = get_readability_response(response)
      unless readability == nil
        data[:title] = readability.title
        data[:article] = readability.content
        data[:images] = readability.images rescue []
      end
    end

private
    def get_readability_response(response)
      return if response.response == ""
      encoding = detect_encoding(response)

      ::Readability::Document.new(
        response.response,
        encoding: encoding, tags: %w[div p img a h1 h2 h3 h4 h5],
        attributes: %w[src href],
        remove_empty_nodes: true
      )
    end

    def detect_encoding(response)
      encoding = response_header_charset(response.response_header)

      if response.response
        if (meta = meta_charset(response.response)).size > 0
          puts "Meta charset: #{meta.inspect}"
          encoding = meta.first
        end
      end

      puts "Encodings: #{encoding.inspect}"

      encoding
    end

    def response_header_charset response
      header, value = response.find do |header, value|
        header == 'CONTENT_TYPE' || value =~ /charset/i
      end

      encoding = charset(value)
      puts "Detect encoding from header: #{encoding}"
      encoding
    end

    ##
    # Retrieves all charsets from +meta+ tags in +body+

    def meta_charset body
      # HACK use .map
      body.scan(/<meta .*?>/i).map do |meta|
        if meta =~ /charset\s*=\s*(["'])?\s*(.+)\s*\1/i then
          $2
        elsif meta =~ /http-equiv\s*=\s*(["'])?content-type\1/i then
          meta =~ /content\s*=\s*(["'])?(.*?)\1/i

          m_charset = charset $2 if $2

          m_charset if m_charset
        end
      end.compact
    end

    def charset content_type
      charset = content_type[/;(?:\s*,)?\s*charset\s*=\s*([^()<>@,;:\\\"\/\[\]?={}\s]+)/i, 1]
      return nil if charset == 'none'
      charset
    end
  end
end
