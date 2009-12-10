desc "Clear logs, recreate test/development dbs, migrate development db, load fixtures into development db, clone development db to test db."
task :refresh => :environment do
  print 'clearing logs...'; STDOUT.flush
  Rake::Task['log:clear'].invoke
  puts 'done'

  Rake::Task[:recreate_databases].invoke

  ActiveRecord::Base.establish_connection(:development)
  ActiveRecord::Migration.verbose = false
  print 'migrating development database...'; STDOUT.flush
  Rake::Task['db:migrate'].invoke
  puts 'done'

  Rake::Task[:load_fixtures_to_development].invoke

  ActiveRecord::Base.establish_connection(:test)
  print 'cloning development structure to test...'; STDOUT.flush
  Rake::Task['db:test:prepare'].invoke
  puts 'done'
end

desc "Load fixtures data into the test database"
task :load_fixtures_to_development => :environment do
  require 'active_record/fixtures'
  ActiveRecord::Base.establish_connection(:development)
  print 'loading fixtures into development database...'; STDOUT.flush
  Dir.glob(File.join(RAILS_ROOT, 'test', 'fixtures', '*.{yml,csv}')).each do |fixture_file|
    Fixtures.create_fixtures('test/fixtures', File.basename(fixture_file, '.*'))
  end
  puts 'done'
end

task :recreate_databases => :environment do
  config = ActiveRecord::Base.configurations
  ['test', 'development'].each do |db|
    case config[db]["adapter"]
    when "mysql"
      print "recreating #{db} database..."; STDOUT.flush
      ActiveRecord::Base.establish_connection(db.to_sym)
      ActiveRecord::Base.connection.recreate_database(config[db]["database"])
      puts "done"
    else
      raise "Task not supported by '#{config[db]["adapter"]}'"
    end
  end
end

desc "Run model validations on all model records in database"
task :validate_models => :environment do
  puts "-- records - model --"
  Dir.glob(RAILS_ROOT + '/app/models/**/*.rb').each { |file| require file }
  Object.subclasses_of(ActiveRecord::Base).select { |c| c.base_class == c}.sort_by(&:name).each do |klass|
    total = klass.count
    printf "%10d - %s\n", total, klass.name
    chunk_size = 1000
    (total / chunk_size + 1).times do |i|
      chunk = klass.find(:all, :offset => (i * chunk_size), :limit => chunk_size)
      chunk.reject(&:valid?).each do |record|
        puts "#{record.class}: id=#{record.id}"
        p record.errors.full_messages
        puts
      end rescue nil
    end
  end
end

desc "Configure Subversion for Rails"
task :configure_for_svn do
  system "svn remove log/*"
  system "svn commit -m 'removing all log files from subversion'"
  system 'svn propset svn:ignore "*.log" log/'
  system "svn update log/"
  system "svn commit -m 'Ignoring all files in /log/ ending in .log'"
  system 'svn propset svn:ignore "*.db" db/'
  system "svn update db/"
  system "svn commit -m 'Ignoring all files in /db/ ending in .db'"
  system "svn move config/database.yml config/database.example"
  system "svn commit -m 'Moving database.yml to database.example to provide a template for anyone who checks out the code'"
  system 'svn propset svn:ignore "database.yml" config/'
  system "svn update config/"
  system "svn commit -m 'Ignoring database.yml'"
  system "svn remove tmp/*"
  system "svn commit -m 'Removing /tmp/ folder'"
  system 'svn propset svn:ignore "*" tmp/'
end

desc "Add new files to subversion"
task :add_new_files do
  # system "svn status | grep '^\?' | sed -e 's/? *//' | sed -e 's/ /\ /g' | xargs svn add"
  system "svn status | grep '^\?' | sed 's/^\? *//g' | xargs svn add"
end

namespace :test do
  desc 'Measures test coverage'
  task :coverage do
    rm_f "tmp/coverage" 
    rm_f "tmp/coverage.data" 
    rcov = "rcov --sort coverage --rails --aggregate tmp/coverage.data --text-summary -Ilib -T -x gems/*,rcov*" 
    system("#{rcov} --no-html test/unit/*_test.rb") 
    system("#{rcov} --no-html test/functional/*_test.rb") 
    system("#{rcov} --html test/integration/*_test.rb") 
    system("open tmp/coverage/index.html") if PLATFORM['darwin']
  end
end

desc 'Show a list of actions sorted by time taken'
task :action_list do
  system("cat log/development.log | awk '/Completed/ { print \"[\" $3 \"] - \" $0 }' | sort -nr")
end

desc 'Generates an HTML page containing all the hex colors specified in CSS files'
task :colors do
  require "tempfile"
  colors = Dir["#{RAILS_ROOT}/public/stylesheets/**/*.css"].map(&File.method(:read)).join.scan(/\#[0-9a-f]{3,6}/i).map{|c| c.upcase}.uniq.sort
  Tempfile.open "colors" do |f|
    f.write <<-EOHTML
    <html>
      <head>
        <style type="text/css">
          div { width: 50px; height: 50px; display: inline-block }
        </style>
      </head>
      <body>
        #{colors.map {|clr| "<div style='background: #{clr}'>&nbsp;</div> #{clr} <br />"}.join}
      </body>
    </html>
    EOHTML
    f.flush
    system("/Applications/Safari.app/Contents/MacOS/Safari", f.path)
  end
end

namespace 'views' do
  desc 'Renames all .rhtml views to .html.erb, .rjs to .js.rjs, .rxml to .xml.builder, and .haml to .html.haml'
  task 'rename' do
    Dir.glob('app/views/**/*.rhtml').each do |file|
      # puts `svn mv #{file} #{file.gsub(/\.rhtml$/, '.html.erb')}`
    end
    Dir.glob('app/views/**/*.rxml').each do |file|
      # puts `svn mv #{file} #{file.gsub(/\.rxml$/, '.atom.builder')}`
    end
    Dir.glob('app/views/**/*.rjs').each do |file|
      # puts `svn mv #{file} #{file.gsub(/\.rjs$/, '.js.rjs')}`
    end
  end
end
