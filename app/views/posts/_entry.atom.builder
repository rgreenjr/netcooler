xm.entry do
  xm.title entry.title
  xm.link :href => "http://#{request.host_with_port}#{post_path(entry)}"
  xm.id entry.atom_id
  xm.updated((entry.updated_at || entry.created_at).to_s(:rfc3393))
  xm.summary entry.body
end
