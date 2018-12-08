namespace :db do
  desc "create sequences"
  task :create_sequences => :environment do
    ActiveRecord::Base.connection.execute(CREATE SEQUENCE deleted_pifs_id_seq1)
    ActiveRecord::Base.connection.execute(CREATE SEQUENCE follow_info_users_id_seq1)
    ActiveRecord::Base.connection.execute(CREATE SEQUENCE my_quitters_id_seq1)
    ActiveRecord::Base.connection.execute(CREATE SEQUENCE system_infos_id_seq1)
    ActiveRecord::Base.connection.execute(CREATE SEQUENCE taggings_id_seq1)
    ActiveRecord::Base.connection.execute(CREATE SEQUENCE tags_id_seq1)
    ActiveRecord::Base.connection.execute(CREATE SEQUENCE users_id_seq1)
  end
end