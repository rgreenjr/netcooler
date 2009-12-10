xml.instruct! :xml, :version => "1.0", :encoding => "UTF-8"
xml.feed :xmlns => "http://www.w3.org/2005/Atom" do
  xml.title "Netcooler - #{@company.name}"
  xml.link :rel => "self", :href => "http://" + request.host_with_port + formatted_company_path(@company, :atom)
  xml.updated Time.now.to_s(:rfc3393)
  xml.author do
    xml.name "Netcooler"
  end
  xml.id @company.atom_id
  render :partial => "posts/entry", :collection => @news,      :locals => { :xm => xml }
  render :partial => "posts/entry", :collection => @gossip,    :locals => { :xm => xml }
  render :partial => "posts/entry", :collection => @questions, :locals => { :xm => xml }
end
