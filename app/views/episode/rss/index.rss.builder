xml.instruct! :xml, version: "1.0", encoding: "UTF-8"

xml.rss version: "2.0",
        "xmlns:itunes" => "http://www.itunes.com/dtds/podcast-1.0.dtd" do
  xml.channel do
    xml.title "桐生あんず電波局"
    xml.link "https://podcasters.spotify.com/pod/show/kiryuanzu"
    xml.description "三浦半島在住のWebエンジニアが日常での考え事や推しについての話をするラジオです\nhttps://www.youtube.com/@kiryuanzu でも配信しています"
    xml.language "ja"
    xml.lastBuildDate @episodes.first&.updated_at&.rfc2822
    xml.copyright "kiryuanzu"
    xml.itunes :author, "kiryuanzu"
    xml.itunes :explicit, "no"
    xml.itunes :summary, "三浦半島在住のWebエンジニアが日常での考え事や推しについての話をするラジオです\nhttps://www.youtube.com/@kiryuanzu でも配信しています"
    xml.itunes :owner do
      xml.itunes :name, "kiryuanzu"
      xml.itunes :email, ""
    end
    xml.itunes :image, href: "https://d3t3ozftmdmh3i.cloudfront.net/staging/podcast_uploaded_nologo/42740810/42740810-1735436174748-1a60f549aec39.jpg"

    xml.itunes :category, text: "Society & Culture" do
      xml.itunes :category, text: "Personal Journals"
    end

    @episodes.each do |episode|
      xml.item do
        xml.title episode.title
        xml.description do
          xml.cdata! episode.description
        end
        xml.pubDate episode.published_at.rfc2822
        xml.guid episode.guid, isPermaLink: false

        if episode.audio_file.attached?
          xml.enclosure url: rails_blob_url(episode.audio_file, only_path: false),
                        type: episode.audio_file.content_type,
                        length: episode.audio_file.byte_size
        end

        xml.itunes :summary, episode.summary if episode.summary.present?
        xml.itunes :explicit, "no"
        xml.itunes :duration, episode.duration
        if episode.cover_image.attached?
          xml.itunes :image, href: rails_blob_url(episode.cover_image, only_path: false)
        end
      end
    end
  end
end
