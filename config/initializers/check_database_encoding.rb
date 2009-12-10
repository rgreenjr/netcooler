# DATABASE_ENCODING = "utf8" unless defined? DATABASE_ENCODING
# variables = %w(character_set_database character_set_client character_set_connection)
# variables.each do |v|
#   ActiveRecord::Base.connection.
#   execute("SHOW VARIABLES LIKE '#{v}'").each do |r|
#     unless r[1] == DATABASE_ENCODING
#       abort "Kindly set your #{r[0]} variable to '#{DATABASE_ENCODING}'."
#     end
#   end
# end
