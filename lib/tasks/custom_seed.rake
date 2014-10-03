namespace :db do
  namespace :seed do
    Dir[File.join(Rails.root, 'db', 'seeds', '*.rb')].each do |filename|
      task_name = File.basename(filename, '.rb').intern
      desc "Load the seed data from db/seeds/#{task_name}.rb"
      task task_name => :environment do
        load(filename) if File.exist?(filename)
      end
    end
  end
end

