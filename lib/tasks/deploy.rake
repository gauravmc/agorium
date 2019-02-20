namespace :deploy do
  task :all => :environment do
    `git push origin master && git push heroku master && heroku run rake db:migrate`
  end
end
