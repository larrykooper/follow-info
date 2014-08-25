require 'twitcon'

class CreateRecomsJob
  include Resque::Plugins::Status
  extend HerokuAutoScaler::AutoScaling 

  @queue = :recommending
  
  def perform
    puts 'larrylog: CreateRecomsJob started'
    fruit = options['fruit']
    puts 'the fruit is ' + fruit
  end # perform

end # class CreateRecomsJob 