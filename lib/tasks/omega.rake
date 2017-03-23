require 'omega'

namespace :omega do
  desc 'Fetch records from Omega and update our database'
  task fetch_and_update: :environment do
    today = Time.now
    last_month = today - 1.month
    Omega.fetch_and_update last_month, today
  end
end
