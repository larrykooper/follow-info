# One-time task to migrate data from single-user schema to multi-user schema 

namespace :multiuser do 
  task :migrate_twitter_users => :environment do 
    lkuser = FollowInfoUser.find_by_email("larry.kooper@gmail.com")
    # Do the following for each Twitter user; in this case, my PIFs and my followers
    TwitterUser.all.each do |twitter_user|
      following = Following.new({
        :follow_info_user_id => lkuser.id, 
        :twitter_user_id => twitter_user.id, 
        :tu_follows_fiu => twitter_user.follows_me,
        :fiu_follows_tu => twitter_user.i_follow, 
        :pif_number => twitter_user.i_follow_nbr, 
        :follower_number => twitter_user.follows_me_nbr
      })
      if twitter_user.i_follow 
        following.date_fiu_started_following_tu = twitter_user.created_at
      end
      if twitter_user.follows_me 
        following.date_tu_started_following_fiu = twitter_user.created_at 
      end
      following.save! 
    end
  end
  
  task :migrate_taggings => :environment do
    # This converts the old taggings to the new followings 
    # It also removes all the second tags (music_fan_of)
    lkuser = FollowInfoUser.find_by_email("larry.kooper@gmail.com")
    music_fan_of = Tag.find_by_name("musicians-i-am-a-fan-of")
    music_fan_of_id = music_fan_of.id
    Tagging.all.each do |tagging|
      unless tagging.tag_id == music_fan_of_id
        followings = Following.where(:follow_info_user_id => lkuser.id, :twitter_user_id => tagging.twitter_user_id)
        if followings.size == 0 
          puts("A ROW NOT FOUND IN FOLLOWINGS:") 
          puts("follow_info_user_id = #{lkuser.id}, tag_id = #{tagging.tag_id}, twitter_user_id = #{tagging.twitter_user_id}")
        else 
          following = followings.first 
          following.tag_id = tagging.tag_id 
          following.save! 
        end
      end 
    end
  end
  
  task :migrate_tags => :environment do 
    # This creates the rows in the new table called follow_info_users_tags
    lkuser = FollowInfoUser.find_by_email("larry.kooper@gmail.com")
    Tag.all.each do |tag|
      fiut = FollowInfoUsersTag.new({
        :tag => tag, 
        :follow_info_user => lkuser, 
        :is_published => tag.is_published
      })
      fiut.save! 
    end
  end
  
end