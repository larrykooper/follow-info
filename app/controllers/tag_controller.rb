class TagController < ApplicationController

  def edit
    if request.method == "GET"
      @tags = Tag.order("name")
    end
    if request.method == "POST"  # It posts to itself
      # Get list of all tags
      tags = Tag.all
      # Set up two hashes of all tags
      published_hash = Hash.new
      ids_hash = Hash.new
      tags.each do |tag|
        published_hash[tag.name] = false  # set all tags to unpublished to start. We do this because nothing sent if checkbox not checked
        ids_hash[tag.name] = tag.id
      end
      # Iterate thru params hash
      params.each_pair do |key, value|
        if key.include? "_published"
          tag_name = key.gsub("_published","")
          published_hash[tag_name] = true
        end
      end
      published_hash.each do |tagname, is_published|
        Tag.update(ids_hash[tagname], :is_published => is_published)
      end
      flash[:notice] = 'Tags were successfully updated!'
      @tags = Tag.order("name")
    end  # if POST
  end  # def edit

  def list
    @tags = Tag.by_user_count
  end

end # class