namespace :db do
  desc "create sequences"
  task :create_sequences => :environment do
    ActiveRecord::Base.connection.execute(
      CREATE SEQUENCE deleted_pifs_id_seq1;
      CREATE SEQUENCE follow_info_users_id_seq1;
      CREATE SEQUENCE my_quitters_id_seq1;
      CREATE SEQUENCE system_infos_id_seq1;
      CREATE SEQUENCE taggings_id_seq1;
      CREATE SEQUENCE tags_id_seq1;
      CREATE SEQUENCE users_id_seq1;
      )
  end
end