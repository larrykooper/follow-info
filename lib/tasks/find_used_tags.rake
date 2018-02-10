namespace :find_used_tags do
  task taggings: :environment do
    Tag.all.each do |tag|
        if tag.taggings.size > 0
            puts "#{tag.name} is used"
        else
            puts "#{tag.name} is not used"
        end
    end
  end
end