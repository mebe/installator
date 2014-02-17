require 'english'
require 'open3'
require 'io/console'

class Installator
  attr_writer :password

  def initialize
    @brews = File.open('Brews') { |f| f.readlines }
    @casks = File.open('Casks') { |f| f.readlines }
    @log_file = File.open('installator.log', 'w')
  end

  def install_homebrew
    # Homebrew installer will first ask for confirmation (enter) and then for password
    Open3.popen3('ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"') do |stdin, stdout, stderr, wait_thr|
      stdin.putc(13)
      stdin.puts(@password)

      @log_file.puts(stdout.read)
      @log_file.puts(stderr.read)

      if wait_thr.value == 0
        return false
      end
    end

    ENV['PATH'] = "/usr/local/bin:#{ENV['PATH']}"
    @log_file.puts(`brew doctor`)
    $CHILD_STATUS != 0
  end

  def install(source)
    instance_variable_get("@#{source}").each do |package|
      puts "  ... #{package}"
      @log_file.puts(`yes #{@password} | brew install #{source == :casks ? 'cask' : ''} #{package}`)
      if $CHILD_STATUS != 0
        abort "Installing #{package} failed, see installator.log"
      end
    end
  end

  def tap_cask
    @log_file.puts(`brew tap phinze/cask && ({yes #{@password} | brew install brew-cask`)
    $CHILD_STATUS == 0
  end
end

installator = Installator.new

puts 'Please enter your password:'
installator.password = STDIN.noecho(&:gets)
puts

puts 'Installing Homebrew...'
unless installator.install_homebrew
  abort 'Installing Homebrew failed. See installator.log for more info.'
end
puts '  ... Homebrew installed'
puts

puts 'Installing Brews...'
installator.install(:brews)
puts '  ... All brews installed'
puts

puts 'Tapping Cask...'
unless installator.tap_cask
  abort 'Cask tapping failed, see installator.log'
end
puts ' ... Done'
puts

puts 'Installing Casks...'
installator.install(:casks)
puts '  ... All casks installed'
puts

puts 'Everything done. See installator.log for details.'
puts

puts 'You should add /usr/local/bin to your path, preferably before /usr/bin.'
puts

puts 'Cheers!'
puts

