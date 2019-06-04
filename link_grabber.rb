class LinkGrabber
  def initialize(directory, filter="")
    @filter = filter
    @files = Dir.entries(directory).select! { |file| file.end_with?(".html") }
  end

  def run
    File.open("copy_these_contents", "w") do |f|
      output = ""
      
      @files.each do |file|
        urls = read(file)

        urls.each do |url|
          if url
            file_path = "links/" + url.split("/")[2..-1].join("/")
            folder_path = "links/" + url.split("/")[2..-2].join("/")
            next_line = "mkdir -p " + folder_path + " && wget -O " + file_path + " " + url + "\r"

            if !output.include?(next_line)
              output += next_line
            end
          end
        end
      end

      f.write(output)
    end
  end

  def read(file)
    urls = []

    File.open(file) do |f|
      f.each_line do |line|
        line.split(" ").each do |word|
          if word.start_with?("href")
            if word.include?(@filter)
              urls << word.split('"')[1]
            end
          end
        end
      end
    end

    urls
  end
end

link_grabber = LinkGrabber.new(".")

link_grabber.run