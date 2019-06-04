class LinkGrabber
  def initialize(directory)
    @files = Dir.entries(directory).select! { |file| file.end_with?(".html") }
  end

  def run
    @files.each do |file|
      urls = get_urls(file)

      urls.each { |url| process_url(url) if url }
    end
  end

  def process_url(url)
    file_path = "links/" + url.split("/")[2..-1].join("/")
    folder_path = "links/" + url.split("/")[2...-1].join("/")

    `mkdir -p #{folder_path} && wget --timeout=20 --tries=3 -nc -O #{file_path} #{url}`
  end

  def get_urls(file)
    urls = []

    File.open(file) do |f|
      f.each_line do |line|
        line.split(" ").each do |word|
          urls << word.split('"')[1] if word.start_with?("href")
        end
      end
    end

    urls
  end
end

link_grabber = LinkGrabber.new(".")

link_grabber.run