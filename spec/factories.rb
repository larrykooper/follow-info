Factory.define :system_info do |f|
  f.followers_last_update 2.days.ago 
  f.i_follow_last_update 4.days.ago 
end

Factory.define :twitter_user do |f|
  f.name "Joe"
  f.nbr_followers 143
  f.follows_me 0
  f.i_follow 0
end 