xml.instruct! :xml, version: "1.0", encoding: "UTF-8"

xml.rss version: "2.0",
        "xmlns:dc" => "http://purl.org/dc/elements/1.1/",
        "xmlns:content" => "http://purl.org/rss/1.0/modules/content/",
        "xmlns:anchor" => "https://anchor.fm/xmlns",
        "xmlns:podcast" => "https://podcastindex.org/namespace/1.0",
        "xmlns:itunes" => "http://www.itunes.com/dtds/podcast-1.0.dtd",
        "xmlns:atom" => "http://www.w3.org/2005/Atom" do
  xml.channel do
    # フィード自身へのリンク（自己参照）
    xml.atom :link, href: "#{request.base_url}/episode/rss", rel: "self", type: "application/rss+xml"

    # チャンネル基本情報
    xml.title do
      xml.cdata! "桐生あんず電波局"
    end

    xml.link "https://podcasters.spotify.com/pod/show/kiryuanzu"

    xml.description do
      xml.cdata! "三浦半島在住のWebエンジニアが日常での考え事や推しについての話をするラジオです\nhttps://www.youtube.com/@kiryuanzu でも配信しています"
    end

    xml.author do
      xml.cdata! "kiryuanzu"
    end

    xml.copyright do
      xml.cdata! "kiryuanzu"
    end

    xml.language do
      xml.cdata! "ja"
    end

    xml.lastBuildDate @episodes.last&.updated_at&.utc&.strftime("%a, %d %b %Y %H:%M:%S GMT")

    # iTunes拡張
    xml.itunes :author, "kiryuanzu"
    xml.itunes :explicit, "no"
    xml.itunes :summary, "三浦半島在住のWebエンジニアが日常での考え事や推しについての話をするラジオです\nhttps://www.youtube.com/@kiryuanzu でも配信しています"
    xml.itunes :type, "episodic"

    xml.itunes :owner do
      xml.itunes :name, "kiryuanzu"
      xml.itunes :email, "anzu.nagato.1005@gmail.com"
    end

    xml.itunes :image, href: "https://d3t3ozftmdmh3i.cloudfront.net/staging/podcast_uploaded_nologo/42740810/42740810-1735436174748-1a60f549aec39.jpg"

    xml.itunes :category, text: "Society & Culture" do
      xml.itunes :category, text: "Personal Journals"
    end

    # エピソード一覧
    @episodes.each do |episode|
      xml.item do
        xml.title do
          xml.cdata! episode.title
        end

        xml.description do
          xml.cdata! episode.description
        end

        xml.pubDate episode.published_at.utc.strftime("%a, %d %b %Y %H:%M:%S GMT")
        xml.guid episode.guid, isPermaLink: false

        xml.dc :creator do
          xml.cdata! "kiryuanzu"
        end

        if episode.audio_file.attached?
          xml.enclosure url: cloudfront_audio_file_url(episode.audio_file),
                        type: episode.audio_file.content_type,
                        length: episode.audio_file.byte_size
        end

        xml.itunes :summary, episode.description
        xml.itunes :explicit, "no"
        xml.itunes :duration, episode.duration

        if episode.cover_image.attached?
          xml.itunes :image, href: cloudfront_cover_image_url(episode.cover_image)
        end
      end
    end
  end
end
