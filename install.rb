class Install
  @@force_save = ARGV.include? '-f'

  def self.check_and_write(filename, data)
    if !@@force_save && FileTest.exist?(filename)
      print "#{filename} already exists. overwrite? [y/N/a/q]: "
      case gets.chomp
      when 'y'
      when 'a'
        @@force_save = true
      when 'q'
        exit
      else # N
        return
      end
    end

    File.open(filename, 'w') {|io| io.puts data }
  end
end

Install.check_and_write(
  File.expand_path('~/.vim/plugin/quickrun.vim'),
  File.read('quickrun.vim'))
ftplugin_path = File.expand_path '~/.vim/ftplugin'
[
  %w[ruby],
  %w[haskell runghc],
  %w[python],
  %w[javascript js],
  %w[scheme gosh],
  %w[sh],
  %w[awk],
  %w[sed],
  %w[scala],
  %w[perl],
  %w[php],
  %w[io],
  ['c', 'function __rungcc__() { gcc $1 && ./a.out } && __rungcc__'],
].each do |(language, interpreter)|
  interpreter ||= language
  unless FileTest.exist? "#{ftplugin_path}/#{language}"
    Dir.mkdir "#{ftplugin_path}/#{language}"
  end
  Install.check_and_write(
    "#{ftplugin_path}/#{language}/quickrun.vim",
    "nmap <leader>r :call QuickRun('#{interpreter}')<Cr>")
end
