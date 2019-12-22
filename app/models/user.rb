=begin

 A user is one Twitter account.
 It could be somebody I follow or someone who follows me,
 or both.

  name  string
  nbr_followers  integer
  is_me  boolean
  follows_me  boolean
  i_follow  boolean
  created_at  datetime
  updated_at  datetime
  i_follow_nbr  integer
  follows_me_nbr  integer
  taken_care_of  boolean
  last_time_tweeted  datetime
  recommendation_count  integer
  tag_id       integer

=end

class User < ActiveRecord::Base

  belongs_to :tag

  require 'math_stuff'

  # CLASS METHODS
  def self.create_new_foller(foller, ind)
     user = User.new({:name => foller.screen_name,
      :nbr_followers => foller.followers_count,
      :is_me => false,
      :follows_me => true,
      :i_follow => false,
      :follows_me_nbr => ind,
      :taken_care_of => true})
    user.save!
  end

  # Add a new person I follow from the Twitter API
  def self.create_new_pif(pif, ind)
    last_time_tweeted = pif.status.nil? ? nil : pif.status.created_at
    user = User.new({:name => pif.screen_name,
      :nbr_followers => pif.followers_count,
      :last_time_tweeted => last_time_tweeted,
      :is_me => false,
      :follows_me => false,
      :i_follow => true,
      :i_follow_nbr => ind,
      :taken_care_of => true})
    user.save!
  end

  def self.larrys_foller_count
    # So I do not need to call API
    User.where("follows_me = true").count
  end

  def self.larry_following_count
    User.where("i_follow = true").count
  end

  def self.pif_following_me_count
    User.where("follows_me = true AND i_follow = true").count
  end

  def self.median_followers_of_pif
    pif = User.where(:i_follow => true)
    my_array = pif.collect {|user| user.nbr_followers }
    med = MathStuff.median(my_array)
  end

  def self.pifs_deleted
    User.where("taken_care_of = false AND i_follow = true")
  end

  def self.quitters
   User.where("taken_care_of = false AND follows_me = true")
  end

  # Controller passes the sort column and direction it wants
  def self.paginated_pifs(per_page, page_wanted, sort_column, sort_direction, two_sorts=false, second_sort='', second_direction='')
    offset = (page_wanted.to_i - 1) * per_page
    second_sort = two_sorts ? ", #{second_sort} #{second_direction}" : ''
    sql = <<-SQL
      SELECT u.id,
      u.i_follow_nbr, u.name, t.name AS tag, u.nbr_followers, u.follows_me, u.last_time_tweeted, t.id AS tag_id
      FROM users u
      LEFT JOIN tags t
      ON u.tag_id = t.id
      WHERE u.i_follow
      ORDER BY #{sort_column} #{sort_direction}
      #{second_sort}
      LIMIT #{per_page}
      OFFSET #{offset};
    SQL
    pifs = User.find_by_sql(sql)
    pifs
  end

  # PUBLIC INSTANCE METHODS

 def process_foller(foller, ind)
    # Update one user who follows me
    unless self.follows_me
      self.follows_me = true
    end
    self.nbr_followers = foller.followers_count
    self.follows_me_nbr = ind
    self.taken_care_of = true
    self.save!
  end

  def process_pif(pif, ind)
    last_time_tweeted = pif.status.nil? ? nil : pif.status.created_at
    # Update one user that I follow
    unless self.i_follow
      self.i_follow = true
    end
    self.nbr_followers = pif.followers_count
    self.last_time_tweeted = last_time_tweeted if last_time_tweeted
    self.i_follow_nbr = ind
    self.taken_care_of = true
    self.save!

  end


end